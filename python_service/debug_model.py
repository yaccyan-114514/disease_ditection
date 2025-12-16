"""
模型调试脚本 - 用于诊断模型预测问题
"""
import os
import json
import numpy as np
from PIL import Image
import tensorflow as tf
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input
from tensorflow.keras import layers as L
from tensorflow.keras.applications import MobileNetV3Small

# 配置
IMG_SIZE = (160, 160)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
WEIGHTS_PATH = os.path.join(SCRIPT_DIR, "streamlit_app", "model", "best_model_tuned.weights.h5")
CLASS_NAMES_PATH = os.path.join(SCRIPT_DIR, "streamlit_app", "model", "class_names.json")

BEST = {
    "use_data_augmentation": False,
    "dense_units": 256,
    "dropout": 0.1,
    "activation": "swish"
}

def load_class_names(path: str):
    """加载类别名称"""
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            names = json.load(f)
        return names
    return None

def build_inference_model(num_classes: int, img_size=IMG_SIZE) -> tf.keras.Model:
    """构建推理模型"""
    base = MobileNetV3Small(
        input_shape=(img_size[0], img_size[1], 3),
        include_top=False,
        weights=None
    )
    base.trainable = False

    inp = L.Input(shape=(img_size[0], img_size[1], 3), name="input")
    x = base(inp)
    x = L.GlobalAveragePooling2D(name="gap")(x)
    x = L.Dropout(BEST["dropout"], name="dropout")(x)

    kernel_init = "glorot_uniform" if BEST["activation"] == "swish" else "he_normal"

    x = L.Dense(
        BEST["dense_units"],
        use_bias=False,
        kernel_initializer=kernel_init,
        name=f"dense{BEST['dense_units']}"
    )(x)
    x = L.BatchNormalization(name="bn")(x)
    act = tf.keras.activations.swish if BEST["activation"] == "swish" else tf.keras.activations.relu
    x = L.Activation(act, name=BEST["activation"])(x)

    out = L.Dense(num_classes, activation="softmax", dtype="float32", name="pred")(x)
    return tf.keras.Model(inp, out, name="leaf_inference")

def preprocess_image_pil(pil_img: Image.Image, img_size=IMG_SIZE) -> np.ndarray:
    """预处理图片"""
    img = pil_img.convert("RGB").resize(img_size)
    arr = np.asarray(img, dtype=np.float32)
    arr = preprocess_input(arr)
    return np.expand_dims(arr, axis=0)

def analyze_model_predictions(image_path: str):
    """分析模型对图片的预测结果"""
    print("=" * 60)
    print("模型诊断工具")
    print("=" * 60)
    
    # 加载类别名称
    class_names = load_class_names(CLASS_NAMES_PATH)
    if class_names is None:
        print("❌ 无法加载类别名称文件")
        return
    
    num_classes = len(class_names)
    print(f"✓ 类别数量: {num_classes}")
    print(f"✓ 类别列表: {class_names[:5]}... (显示前5个)")
    
    # 统计Tomato类别
    tomato_classes = [i for i, name in enumerate(class_names) if name.startswith("Tomato")]
    print(f"\n📊 类别分析:")
    print(f"   - Tomato相关类别数量: {len(tomato_classes)}")
    print(f"   - Tomato类别占比: {len(tomato_classes)/num_classes*100:.1f}%")
    print(f"   - Tomato类别索引: {tomato_classes}")
    
    # 加载模型
    print(f"\n🔄 加载模型...")
    model = build_inference_model(num_classes=num_classes, img_size=IMG_SIZE)
    
    if not os.path.exists(WEIGHTS_PATH):
        print(f"❌ 模型权重文件不存在: {WEIGHTS_PATH}")
        return
    
    try:
        model.load_weights(WEIGHTS_PATH)
        print(f"✓ 模型权重加载成功")
    except Exception as e:
        print(f"❌ 模型权重加载失败: {e}")
        return
    
    # 加载并预处理图片
    if not os.path.exists(image_path):
        print(f"❌ 图片文件不存在: {image_path}")
        return
    
    print(f"\n🖼️  加载图片: {image_path}")
    image = Image.open(image_path)
    x = preprocess_image_pil(image, IMG_SIZE)
    print(f"✓ 图片预处理完成，形状: {x.shape}")
    
    # 进行预测
    print(f"\n🔮 进行预测...")
    pred = model.predict(x, verbose=0)[0]
    
    # 分析预测结果
    print(f"\n📈 预测结果分析:")
    print(f"   - 预测概率分布形状: {pred.shape}")
    print(f"   - 预测概率总和: {np.sum(pred):.6f} (应该接近1.0)")
    print(f"   - 最大概率值: {np.max(pred):.6f}")
    print(f"   - 最小概率值: {np.min(pred):.6f}")
    print(f"   - 概率标准差: {np.std(pred):.6f}")
    
    # Top 5 预测
    top_indices = np.argsort(pred)[::-1][:5]
    print(f"\n🏆 Top 5 预测结果:")
    for i, idx in enumerate(top_indices):
        class_name = class_names[idx] if idx < len(class_names) else f"Class {idx}"
        confidence = pred[idx]
        is_tomato = class_name.startswith("Tomato")
        marker = "🍅" if is_tomato else "  "
        print(f"   {i+1}. {marker} {class_name}: {confidence*100:.2f}%")
    
    # 检查是否所有预测都偏向Tomato
    tomato_probs = [pred[i] for i in tomato_classes]
    total_tomato_prob = sum(tomato_probs)
    print(f"\n⚠️  诊断结果:")
    print(f"   - 所有Tomato类别的总概率: {total_tomato_prob*100:.2f}%")
    
    if total_tomato_prob > 0.5:
        print(f"   ⚠️  警告: 模型过度偏向Tomato类别！")
        print(f"   💡 可能原因:")
        print(f"      1. 训练数据中Tomato样本过多（类别不平衡）")
        print(f"      2. 模型训练不充分，只学会了识别Tomato")
        print(f"      3. 模型过拟合到Tomato类别")
    else:
        print(f"   ✓ Tomato概率在正常范围内")
    
    # 检查预测分布是否过于集中
    entropy = -np.sum(pred * np.log(pred + 1e-10))
    max_entropy = np.log(num_classes)
    normalized_entropy = entropy / max_entropy
    
    print(f"\n📊 预测分布分析:")
    print(f"   - 信息熵: {entropy:.4f}")
    print(f"   - 最大熵: {max_entropy:.4f}")
    print(f"   - 归一化熵: {normalized_entropy:.4f}")
    
    if normalized_entropy < 0.1:
        print(f"   ⚠️  警告: 预测分布过于集中（熵值过低）！")
        print(f"   💡 模型可能对所有输入都预测同一个类别")
    elif normalized_entropy > 0.9:
        print(f"   ⚠️  警告: 预测分布过于均匀（熵值过高）！")
        print(f"   💡 模型可能没有学到有效的特征")
    else:
        print(f"   ✓ 预测分布正常")
    
    print("\n" + "=" * 60)

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("用法: python debug_model.py <图片路径>")
        print("示例: python debug_model.py test_image.jpg")
        sys.exit(1)
    
    image_path = sys.argv[1]
    analyze_model_predictions(image_path)

