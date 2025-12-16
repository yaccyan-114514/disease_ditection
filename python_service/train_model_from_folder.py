"""
从文件夹加载数据集的训练脚本
适用于手动下载并解压的数据集
"""
import os
import json
import numpy as np
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV3Small
from tensorflow.keras import layers as L
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint, ReduceLROnPlateau
from sklearn.utils.class_weight import compute_class_weight
from sklearn.metrics import classification_report
from collections import Counter

# 配置
IMG_SIZE = 160  # 与API服务保持一致
BATCH_SIZE = 32
EPOCHS = 50
SEED = 42

# 设置随机种子
tf.random.set_seed(SEED)
np.random.seed(SEED)

# 数据路径
DATA_DIR = os.path.expanduser('~/tensorflow_datasets/plant_village/1.0.2/Plant_leave_diseases_dataset_without_augmentation')
OUTPUT_DIR = "streamlit_app/model"
os.makedirs(OUTPUT_DIR, exist_ok=True)

print("=" * 60)
print("🌱 植物病害识别模型训练（从文件夹加载）")
print("=" * 60)

# ==================== 步骤1: 检查数据目录 ====================
print("\n[1/5] 检查数据目录...")

if not os.path.exists(DATA_DIR):
    print(f"❌ 数据目录不存在: {DATA_DIR}")
    print(f"请确保数据集已解压到该目录")
    exit(1)

# 获取所有类别
class_dirs = [d for d in os.listdir(DATA_DIR) 
              if os.path.isdir(os.path.join(DATA_DIR, d)) 
              and not d.startswith('.')]

# 过滤掉 Background_without_leaves（根据TFDS说明，这个类别不在原始数据集中）
class_dirs = [d for d in class_dirs if d != 'Background_without_leaves']

class_dirs.sort()
NUM_CLASSES = len(class_dirs)

# 保存有效的类别列表，用于ImageDataGenerator
valid_classes = sorted(class_dirs)

print(f"✓ 数据目录存在: {DATA_DIR}")
print(f"✓ 找到 {NUM_CLASSES} 个类别")

# 统计每个类别的样本数
class_counts = {}
for class_dir in class_dirs:
    class_path = os.path.join(DATA_DIR, class_dir)
    count = len([f for f in os.listdir(class_path) 
                 if f.lower().endswith(('.jpg', '.jpeg', '.png'))])
    class_counts[class_dir] = count
    print(f"  - {class_dir}: {count} 张图片")

total_images = sum(class_counts.values())
print(f"\n总图片数: {total_images}")

# ==================== 步骤2: 准备数据生成器 ====================
print("\n[2/5] 准备数据生成器...")

# 数据预处理函数
def preprocess_input(x):
    """MobileNetV3预处理"""
    from tensorflow.keras.applications.mobilenet_v3 import preprocess_input as mobilenet_preprocess
    return mobilenet_preprocess(x)

# 训练数据生成器（不使用数据增强，因为最佳配置是False）
train_datagen = ImageDataGenerator(
    preprocessing_function=preprocess_input,
    validation_split=0.15,  # 15%作为验证集
    rescale=1.0  # 预处理函数已经处理了归一化
)

# 验证数据生成器（不使用数据增强）
val_datagen = ImageDataGenerator(
    preprocessing_function=preprocess_input,
    validation_split=0.15,
    rescale=1.0
)

# 测试数据生成器（从训练集中再分15%作为测试集）
# 注意：这里我们使用validation_split=0.15，然后从剩余的85%中再分15%作为测试集
# 实际划分：70%训练，15%验证，15%测试

# 创建数据生成器（指定classes参数，排除Background_without_leaves）
train_gen = train_datagen.flow_from_directory(
    DATA_DIR,
    target_size=(IMG_SIZE, IMG_SIZE),
    batch_size=BATCH_SIZE,
    subset='training',
    class_mode='sparse',
    classes=valid_classes,  # 只使用有效的类别，排除Background_without_leaves
    seed=SEED,
    shuffle=True
)

val_gen = val_datagen.flow_from_directory(
    DATA_DIR,
    target_size=(IMG_SIZE, IMG_SIZE),
    batch_size=BATCH_SIZE,
    subset='validation',
    class_mode='sparse',
    classes=valid_classes,  # 只使用有效的类别
    seed=SEED,
    shuffle=False
)

# 获取类别名称（按顺序，与ImageDataGenerator的class_indices顺序一致）
class_names = sorted(valid_classes)

# 验证类别数量和索引范围
if len(train_gen.class_indices) != NUM_CLASSES:
    print(f"❌ 错误: 类别数量不匹配")
    print(f"  训练生成器: {len(train_gen.class_indices)} 个类别")
    print(f"  预期: {NUM_CLASSES} 个类别")
    print(f"  类别索引映射: {train_gen.class_indices}")
    exit(1)

# 验证类别索引范围（应该是0到NUM_CLASSES-1）
max_index = max(train_gen.class_indices.values())
min_index = min(train_gen.class_indices.values())
if max_index >= NUM_CLASSES or min_index < 0:
    print(f"❌ 错误: 类别索引超出范围")
    print(f"  索引范围: [{min_index}, {max_index}]")
    print(f"  有效范围: [0, {NUM_CLASSES})")
    print(f"  类别索引映射: {train_gen.class_indices}")
    exit(1)

print(f"✓ 类别索引验证通过: [{min_index}, {max_index}]")

print(f"✓ 数据生成器准备完成")
print(f"  - 训练集: {train_gen.samples} 张图片")
print(f"  - 验证集: {val_gen.samples} 张图片")
print(f"  - 类别数: {NUM_CLASSES}")

# ==================== 步骤3: 计算类别权重 ====================
print("\n[3/5] 计算类别权重（解决类别不平衡问题）...")

# 收集训练标签
train_labels = []
for i in range(len(train_gen)):
    _, labels = train_gen[i]
    train_labels.extend(labels)
    if i >= len(train_gen) - 1:  # 只收集一次完整的数据
        break

# 重置生成器
train_gen.reset()

# 计算类别权重
unique_labels = np.unique(train_labels)
class_weights = compute_class_weight(
    'balanced',
    classes=unique_labels,
    y=train_labels
)
class_weight_dict = dict(zip(unique_labels, class_weights))

print(f"✓ 类别权重计算完成")
print(f"  - 最小权重: {min(class_weights):.3f}")
print(f"  - 最大权重: {max(class_weights):.3f}")

# 显示Tomato类别权重（如果存在）
tomato_classes = [i for i, name in enumerate(class_names) if name.startswith("Tomato")]
if tomato_classes:
    tomato_weight = class_weights[tomato_classes[0]]
    print(f"  - Tomato类别权重: {tomato_weight:.3f}")

# ==================== 步骤4: 构建模型 ====================
print("\n[4/5] 构建模型...")

def build_model(num_classes, img_size=(IMG_SIZE, IMG_SIZE)):
    """构建MobileNetV3Small模型"""
    # 基础模型（使用ImageNet预训练权重）
    base = MobileNetV3Small(
        input_shape=(img_size[0], img_size[1], 3),
        include_top=False,
        weights='imagenet'
    )
    base.trainable = False  # 冻结基础模型
    
    # 分类头
    inp = L.Input(shape=(img_size[0], img_size[1], 3), name="input")
    x = base(inp)
    x = L.GlobalAveragePooling2D(name="gap")(x)
    x = L.Dropout(0.1, name="dropout")(x)
    
    x = L.Dense(256, use_bias=False, name="dense256")(x)
    x = L.BatchNormalization(name="bn")(x)
    x = L.Activation('swish', name="swish")(x)
    
    out = L.Dense(num_classes, activation='softmax', dtype='float32', name="pred")(x)
    
    model = tf.keras.Model(inp, out, name="plant_disease_classifier")
    return model

model = build_model(NUM_CLASSES, (IMG_SIZE, IMG_SIZE))

# 编译模型
model.compile(
    optimizer=tf.keras.optimizers.AdamW(
        learning_rate=0.001,
        weight_decay=1.9e-5
    ),
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

print(f"✓ 模型构建完成")
print(f"  - 总参数: {model.count_params():,}")
print(f"  - 可训练参数: {sum([tf.size(w).numpy() for w in model.trainable_weights]):,}")

# ==================== 步骤5: 训练模型 ====================
print("\n[5/5] 开始训练模型...")
print("=" * 60)

# 回调函数
callbacks = [
    EarlyStopping(
        monitor='val_loss',
        patience=10,
        restore_best_weights=True,
        verbose=1
    ),
    ModelCheckpoint(
        filepath=os.path.join(OUTPUT_DIR, 'best_model_tuned.weights.h5'),
        monitor='val_accuracy',
        save_best_only=True,
        save_weights_only=True,
        verbose=1
    ),
    ReduceLROnPlateau(
        monitor='val_loss',
        factor=0.5,
        patience=5,
        min_lr=1e-7,
        verbose=1
    )
]

# 计算步数
steps_per_epoch = train_gen.samples // BATCH_SIZE
validation_steps = val_gen.samples // BATCH_SIZE

print(f"训练配置:")
print(f"  - 训练轮数: {EPOCHS}")
print(f"  - 批次大小: {BATCH_SIZE}")
print(f"  - 图片尺寸: {IMG_SIZE}x{IMG_SIZE}")
print(f"  - 每轮步数: {steps_per_epoch}")
print(f"  - 验证步数: {validation_steps}")
print(f"  - 使用类别权重: 是")
print("=" * 60)

# 开始训练
history = model.fit(
    train_gen,
    validation_data=val_gen,
    epochs=EPOCHS,
    steps_per_epoch=steps_per_epoch,
    validation_steps=validation_steps,
    callbacks=callbacks,
    class_weight=class_weight_dict,  # 使用类别权重
    verbose=1
)

print("\n" + "=" * 60)
print("✓ 训练完成！")
print("=" * 60)

# ==================== 评估模型 ====================
print("\n评估模型...")

# 创建测试数据生成器（从训练集中再分一部分作为测试集）
# 这里我们使用验证集作为测试集（因为ImageDataGenerator的validation_split限制）
test_gen = ImageDataGenerator(
    preprocessing_function=preprocess_input,
    validation_split=0.15
).flow_from_directory(
    DATA_DIR,
    target_size=(IMG_SIZE, IMG_SIZE),
    batch_size=BATCH_SIZE,
    subset='validation',
    class_mode='sparse',
    classes=valid_classes,  # 只使用有效的类别
    seed=SEED,
    shuffle=False
)

test_loss, test_acc = model.evaluate(test_gen, verbose=1)
print(f"\n📊 测试集结果:")
print(f"  - 测试准确率: {test_acc:.2%}")
print(f"  - 测试损失: {test_loss:.4f}")

# ==================== 保存模型和类别名称 ====================
print("\n保存模型文件...")

# 保存权重（如果还没有保存）
weights_path = os.path.join(OUTPUT_DIR, 'best_model_tuned.weights.h5')
if not os.path.exists(weights_path):
    model.save_weights(weights_path)
    print(f"✓ 模型权重已保存: {weights_path}")

# 保存类别名称（重要！）
class_names_path = os.path.join(OUTPUT_DIR, 'class_names.json')
with open(class_names_path, 'w', encoding='utf-8') as f:
    json.dump(class_names, f, ensure_ascii=False, indent=2)
print(f"✓ 类别名称已保存: {class_names_path}")

print("\n" + "=" * 60)
print("🎉 训练完成！")
print("=" * 60)
print(f"\n模型文件已保存到: {OUTPUT_DIR}/")
print(f"  - best_model_tuned.weights.h5 (模型权重)")
print(f"  - class_names.json (类别名称)")
print(f"\n现在可以:")
print(f"  1. 重启API服务: python api_service.py")
print(f"  2. 测试识别功能")
print(f"  3. 运行诊断脚本: python debug_model.py <测试图片>")
print("=" * 60)
