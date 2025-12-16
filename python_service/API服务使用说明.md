# Python API 服务使用说明

## 📋 start_api.sh 脚本的作用

`start_api.sh` 是一个**启动脚本**，用于：
1. ✅ 检查Python环境和依赖
2. ✅ 创建/激活虚拟环境（如果需要）
3. ✅ 检查模型文件是否存在
4. ✅ 启动Flask API服务（默认端口5050）

**这个脚本非常有用！** 它简化了启动流程。

## 🚀 如何启动API服务

### 方法1：使用启动脚本（推荐）

```bash
cd python_service
chmod +x start_api.sh  # 首次运行需要添加执行权限
./start_api.sh
```

或者指定端口：
```bash
./start_api.sh 5050
```

### 方法2：直接运行Python脚本

```bash
cd python_service
python api_service.py
```

或者指定端口：
```bash
python api_service.py 5050
```

## 🔗 服务调用流程

### 完整调用链

```
用户上传图片 (网页)
    ↓
Java后端 (AIController)
    ↓
AIRecognitionService
    ↓
Python API服务 (http://localhost:5050/predict)
    ↓
MobileNetV3模型识别
    ↓
返回识别结果
    ↓
显示在网页上
```

### 配置检查

确保以下配置正确：

1. **Java配置** (`src/main/resources/application.properties`):
   ```properties
   ai.service.url=http://localhost:5050
   ai.service.enabled=true
   ```

2. **Python API服务端口**: 默认5050（与Java配置一致）

## 📝 使用步骤

### 步骤1：启动Python API服务

```bash
cd python_service
./start_api.sh
```

**成功启动后，你会看到：**
```
============================================================
MobilePlantViT API 服务
============================================================
模型权重路径: .../best_model_tuned.weights.h5
类别名称路径: .../class_names.json
输入图片尺寸: (160, 160)
服务端口: 5050
============================================================
✓ 模型预加载成功

启动 Flask 服务...
API 地址: http://localhost:5050
健康检查: http://localhost:5050/health
预测接口: http://localhost:5050/predict
```

### 步骤2：启动Java应用

```bash
# 在项目根目录
mvn clean package
mvn tomcat7:run
```

或者使用IDE运行。

### 步骤3：在网页上使用

1. 访问：`http://localhost:8080/disease_ditection/ai`
2. 上传图片
3. 点击"开始识别"
4. 查看识别结果

## 🔍 验证服务是否正常运行

### 检查Python API服务

```bash
# 健康检查
curl http://localhost:5050/health

# 应该返回：
# {
#   "status": "ok",
#   "model_loaded": true,
#   "num_classes": 38
# }
```

### 检查Java配置

查看 `application.properties` 中的配置：
```properties
ai.service.url=http://localhost:5050
ai.service.enabled=true
```

## ⚠️ 常见问题

### 问题1：连接被拒绝 (Connection refused)

**原因**: Python API服务没有启动

**解决**:
```bash
cd python_service
./start_api.sh
```

### 问题2：模型文件未找到

**错误信息**: `模型权重文件未找到`

**解决**:
1. 确保 `streamlit_app/model/best_model_tuned.weights.h5` 存在
2. 如果不存在，需要先训练模型：
   ```bash
   python train_model_from_folder.py
   ```

### 问题3：端口冲突

**错误信息**: `Address already in use`

**解决**:
1. 更改端口：
   ```bash
   ./start_api.sh 5051
   ```
2. 修改Java配置：
   ```properties
   ai.service.url=http://localhost:5051
   ```

### 问题4：识别结果总是Tomato

**原因**: 模型训练不充分或类别不平衡

**解决**: 重新训练模型（使用类别权重）：
```bash
python train_model_from_folder.py
```

## 📊 API接口说明

### 1. 健康检查
```
GET http://localhost:5050/health
```

### 2. 图片识别
```
POST http://localhost:5050/predict
Content-Type: multipart/form-data

参数:
- image: 图片文件

返回:
{
  "success": true,
  "result": {
    "disease": "Tomato - Late blight",
    "crop": "Tomato",
    "disease_name": "Late blight",
    "confidence": 0.9938,
    "all_predictions": [...]
  }
}
```

### 3. AI解释（流式）
```
POST http://localhost:5050/explain
Content-Type: application/json

{
  "result_json": {
    "success": true,
    "result": {...}
  }
}
```

## 🎯 快速开始

### 一键启动（推荐）

```bash
# 终端1：启动Python API服务
cd python_service
./start_api.sh

# 终端2：启动Java应用
cd /Users/wodediannao/Desktop/java_Projects/disease_ditection
mvn tomcat7:run
```

### 验证

1. 打开浏览器访问：`http://localhost:8080/disease_ditection/ai`
2. 上传一张植物叶片图片
3. 点击"开始识别"
4. 查看识别结果

## 📝 注意事项

1. **端口必须一致**: Java配置的端口必须与Python API服务端口一致（默认5050）
2. **模型文件必须存在**: 确保 `best_model_tuned.weights.h5` 和 `class_names.json` 存在
3. **服务顺序**: 先启动Python API服务，再启动Java应用
4. **网络连接**: 确保localhost:5050可访问

## 🔧 调试技巧

### 查看Python API日志

启动脚本会显示详细的日志，包括：
- 模型加载状态
- 识别请求和结果
- 错误信息

### 查看Java应用日志

在IDE控制台或日志文件中查看：
- AI服务调用日志
- 错误信息

### 测试API接口

使用curl测试：
```bash
# 测试健康检查
curl http://localhost:5050/health

# 测试识别（需要准备一张图片）
curl -X POST -F "image=@test_image.jpg" http://localhost:5050/predict
```

## ✅ 总结

- **start_api.sh**: 启动Python API服务的便捷脚本，**非常有用**
- **调用流程**: 网页 → Java后端 → Python API → 模型识别 → 返回结果
- **端口配置**: 确保Java和Python使用相同的端口（默认5050）
- **模型文件**: 确保模型权重和类别名称文件存在

现在你可以：
1. 运行 `./start_api.sh` 启动Python API服务
2. 启动Java应用
3. 在网页上上传图片进行识别
