"""
Flask API 服务 - 为 Java SSM 项目提供植物病虫害识别接口
基于 MobilePlantViT 模型
"""
import os
import json
import numpy as np
from flask import Flask, request, jsonify, Response, stream_with_context
from flask_cors import CORS
from PIL import Image
import tensorflow as tf
from tensorflow.keras import layers as L
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input
from tensorflow.keras.applications import MobileNetV3Small
from Qwen3 import get_qwen3_client

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})  # 允许跨域请求，支持所有来源

# --------------------------
# 配置
# --------------------------
BEST = {
    "use_data_augmentation": False,
    "dense_units": 256,
    "dropout": 0.1,
    "activation": "swish"
}

IMG_SIZE = (160, 160)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
WEIGHTS_PATH = os.path.join(SCRIPT_DIR, "streamlit_app", "model", "best_model_tuned.weights.h5")
CLASS_NAMES_PATH = os.path.join(SCRIPT_DIR, "streamlit_app", "model", "class_names.json")

# 全局变量存储模型和类别名称
model = None
class_names = None


# --------------------------
# 工具函数
# --------------------------
def load_class_names(path: str):
    """加载类别名称"""
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            names = json.load(f)
        if isinstance(names, list) and all(isinstance(x, str) for x in names):
            return names
        raise ValueError("class_names.json must be a JSON list of strings.")
    print("警告: class_names.json 未找到")
    return None


def build_inference_model(num_classes: int, img_size=IMG_SIZE) -> tf.keras.Model:
    """
    构建推理模型，与训练时的架构一致
    """
    base = MobileNetV3Small(
        input_shape=(img_size[0], img_size[1], 3),
        include_top=False,
        weights=None  # 权重将从 .weights.h5 加载
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
    """预处理图片：调整大小 + MobileNetV3 预处理"""
    img = pil_img.convert("RGB").resize(img_size)
    arr = np.asarray(img, dtype=np.float32)
    arr = preprocess_input(arr)  # 映射到 [-1, 1]
    return np.expand_dims(arr, axis=0)


def load_model_and_labels():
    """加载模型和类别名称"""
    global model, class_names
    
    if model is not None:
        return model, class_names
    
    print("正在加载模型...")
    class_names = load_class_names(CLASS_NAMES_PATH)
    
    if class_names is None:
        print("警告: 无法加载类别名称，使用默认值")
        num_classes = 38  # PlantVillage 数据集默认类别数
    else:
        num_classes = len(class_names)
    
    model = build_inference_model(num_classes=num_classes, img_size=IMG_SIZE)
    
    if not os.path.exists(WEIGHTS_PATH):
        raise FileNotFoundError(f"模型权重文件未找到: {WEIGHTS_PATH}")
    
    model.load_weights(WEIGHTS_PATH)
    print(f"✓ 模型加载成功，类别数: {num_classes}")
    
    return model, class_names


def parse_class_name(class_name: str):
    """解析类别名称：Crop__Disease -> (crop, disease)"""
    if "__" in class_name:
        parts = class_name.split("__", 1)
        crop = parts[0].replace("_", " ")
        disease = parts[1].replace("_", " ")
        return crop, disease
    return class_name, ""


# --------------------------
# API 路由
# --------------------------
@app.route('/health', methods=['GET'])
def health():
    """健康检查接口"""
    try:
        if model is None:
            load_model_and_labels()
        return jsonify({
            'status': 'ok',
            'model_loaded': model is not None,
            'num_classes': len(class_names) if class_names else 0
        })
    except Exception as e:
        return jsonify({
            'status': 'error',
            'error': str(e)
        }), 500


@app.route('/explain', methods=['POST'])
def explain():
    """
    使用 Qwen3 将识别结果转换为人类理解的语言（流式输出）
    
    请求:
    - result_json: MobilePlantViT 的识别结果 JSON
    
    返回:
    Server-Sent Events (SSE) 流式响应
    """
    try:
        data = request.get_json()
        if not data or 'result_json' not in data:
            return jsonify({
                'success': False,
                'error': '缺少 result_json 参数'
            }), 400
        
        result_json = data['result_json']
        print(f"[api_service] 收到解释请求，result_json 类型: {type(result_json)}")
        print(f"[api_service] result_json 内容预览: {str(result_json)[:200]}...")
        
        # 获取 Qwen3 客户端并调用解释接口（流式）
        try:
            qwen_client = get_qwen3_client()
            print(f"[api_service] ✓ Qwen3 客户端获取成功")
        except Exception as e:
            error_msg = f"获取 Qwen3 客户端失败: {str(e)}"
            print(f"[api_service] ✗ {error_msg}")
            import traceback
            traceback.print_exc()
            return jsonify({
                'success': False,
                'error': error_msg
            }), 500
        
        def generate():
            try:
                print(f"[api_service] 开始调用 Qwen3 解释接口...")
                # 调用 Qwen3 解释接口，返回流式生成器
                for data_line in qwen_client.explain_disease_result(result_json, max_length=300):
                    yield data_line
                print(f"[api_service] ✓ Qwen3 解释完成")
            except Exception as e:
                import traceback
                error_detail = traceback.format_exc()
                error_msg = f"Qwen3 解释失败: {str(e)}"
                print(f"[api_service] ✗ 错误详情:")
                print(f"[api_service] {error_msg}")
                print(f"[api_service] 完整错误信息:")
                print(error_detail)
                yield f"data: {json.dumps({'error': error_msg}, ensure_ascii=False)}\n\n"
        
        return Response(
            stream_with_context(generate()),
            mimetype='text/event-stream',
            headers={
                'Cache-Control': 'no-cache',
                'X-Accel-Buffering': 'no'
            }
        )
        
    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'error': f'解释失败: {str(e)}'
        }), 500


@app.route('/predict', methods=['POST'])
def predict():
    """
    病虫害识别接口
    
    请求:
    - image: 图片文件 (multipart/form-data)
    
    返回:
    {
        "success": true,
        "result": {
            "disease": "Tomato - Late blight",
            "crop": "Tomato",
            "disease_name": "Late blight",
            "confidence": 0.9938,
            "all_predictions": [
                {"crop": "Tomato", "disease": "Late blight", "confidence": 0.9938},
                ...
            ]
        }
    }
    """
    try:
        # 确保模型已加载
        if model is None:
            load_model_and_labels()
        
        if 'image' not in request.files:
            return jsonify({
                'success': False,
                'error': '未上传图片文件'
            }), 400
        
        file = request.files['image']
        
        if file.filename == '':
            return jsonify({
                'success': False,
                'error': '文件名为空'
            }), 400
        
        # 打开并预处理图片
        image = Image.open(file.stream)
        x = preprocess_image_pil(image, IMG_SIZE)
        
        # 预测
        pred = model.predict(x, verbose=0)[0]
        idx = int(np.argmax(pred))
        confidence = float(np.max(pred))
        
        # 添加置信度阈值检查（如果置信度太低，可能是无效输入）
        MIN_CONFIDENCE_THRESHOLD = 0.3  # 最低置信度阈值
        if confidence < MIN_CONFIDENCE_THRESHOLD:
            return jsonify({
                'success': False,
                'error': f'识别置信度过低 ({confidence*100:.1f}%)，可能不是有效的植物叶片图片。请上传清晰的植物叶片照片。'
            }), 400
        
        # 检查预测分布是否异常（如果所有类别的概率都很低，可能是无效输入）
        entropy = -np.sum(pred * np.log(pred + 1e-10))
        max_entropy = np.log(len(class_names) if class_names else 38)
        normalized_entropy = entropy / max_entropy
        
        # 如果熵值过低（预测过于集中）且置信度不高，可能是模型问题
        if normalized_entropy < 0.1 and confidence < 0.5:
            print(f"[WARNING] 预测分布异常: 熵={normalized_entropy:.3f}, 置信度={confidence:.3f}")
        
        # 解析类别名称
        if class_names and idx < len(class_names):
            class_name = class_names[idx]
            crop, disease = parse_class_name(class_name)
        else:
            crop = f"Class {idx}"
            disease = ""
            class_name = crop
        
        # 构建所有预测结果（Top 5）
        all_predictions = []
        top_indices = np.argsort(pred)[::-1][:5]  # 取前5个
        for i in top_indices:
            if class_names and i < len(class_names):
                cname = class_names[i]
                c, d = parse_class_name(cname)
            else:
                c = f"Class {i}"
                d = ""
            all_predictions.append({
                "crop": c,
                "disease": d,
                "confidence": float(pred[i])
            })
        
        # 构建结果 JSON
        result_json = {
            'success': True,
            'result': {
                'disease': f"{crop} - {disease}" if disease else crop,
                'crop': crop,
                'disease_name': disease,
                'confidence': confidence,
                'all_predictions': all_predictions
            }
        }
        
        # 打印 JSON 输出到终端（调试用）
        print("\n" + "=" * 60)
        print("MobilePlantViT 识别结果 (JSON):")
        print("=" * 60)
        print(json.dumps(result_json, ensure_ascii=False, indent=2))
        print("=" * 60 + "\n")
        
        return jsonify(result_json)
        
    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'error': f'预测失败: {str(e)}'
        }), 500


if __name__ == '__main__':
    import os
    import sys
    
    # 从环境变量或命令行参数获取端口号
    port = 5050 # 默认端口
    if 'PORT' in os.environ:
        port = int(os.environ['PORT'])
    elif len(sys.argv) > 1:
        try:
            port = int(sys.argv[1])
        except ValueError:
            print(f"警告: 无效的端口号 '{sys.argv[1]}'，使用默认端口 5050")
            port = 5050
    
    print("=" * 60)
    print("MobilePlantViT API 服务")
    print("=" * 60)
    print(f"模型权重路径: {WEIGHTS_PATH}")
    print(f"类别名称路径: {CLASS_NAMES_PATH}")
    print(f"输入图片尺寸: {IMG_SIZE}")
    print(f"服务端口: {port}")
    print("=" * 60)
    
    # 启动时预加载模型
    try:
        load_model_and_labels()
        print("✓ 模型预加载成功")
    except Exception as e:
        print(f"✗ 模型预加载失败: {e}")
        print("将在首次请求时尝试加载")
    
    print("\n启动 Flask 服务...")
    print(f"API 地址: http://localhost:{port}")
    print(f"健康检查: http://localhost:{port}/health")
    print(f"预测接口: http://localhost:{port}/predict")
    print("\n提示: 可以通过环境变量 PORT 或命令行参数指定端口")
    print("   例如: PORT=5050 python api_service.py")
    print("   或者: python api_service.py 5050")
    print("=" * 60)
    
    app.run(host='0.0.0.0', port=port, debug=False, threaded=True)

