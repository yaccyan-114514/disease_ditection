#!/bin/bash

# MobilePlantViT API 服务启动脚本

echo "=========================================="
echo "MobilePlantViT API 服务启动"
echo "=========================================="

# 检查 Python 版本
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python 版本: $python_version"

# 检查虚拟环境
if [ ! -d "venv" ]; then
    echo ""
    echo "创建虚拟环境..."
    python3 -m venv venv
fi

# 激活虚拟环境
echo "激活虚拟环境..."
source venv/bin/activate

# 检查依赖
if ! python -c "import flask" 2>/dev/null || ! python -c "import openai" 2>/dev/null; then
    echo ""
    echo "安装依赖..."
    pip install -r requirements_api.txt
    echo "✓ 依赖安装完成"
fi

# 检查模型文件
if [ ! -f "streamlit_app/model/best_model_tuned.weights.h5" ]; then
    echo ""
    echo "⚠ 警告: 模型文件未找到!"
    echo "   请确保 streamlit_app/model/best_model_tuned.weights.h5 存在"
    exit 1
fi

if [ ! -f "streamlit_app/model/class_names.json" ]; then
    echo ""
    echo "⚠ 警告: 类别名称文件未找到!"
    echo "   请确保 streamlit_app/model/class_names.json 存在"
    exit 1
fi

echo ""
echo "✓ 所有检查通过"
# 检查是否有端口参数
PORT=${1:-5050}

echo ""
echo "启动 API 服务..."
echo "服务地址: http://localhost:${PORT}"
echo "健康检查: http://localhost:${PORT}/health"
echo "预测接口: http://localhost:${PORT}/predict"
echo "解释接口: http://localhost:${PORT}/explain (流式输出)"
echo ""
echo "提示:"
echo "  - 可以通过参数指定端口，例如: ./start_api.sh 5050"
echo "  - 识别结果会打印 JSON 到终端（调试用）"
echo "  - Qwen3 解释功能已集成"
echo "按 Ctrl+C 停止服务"
echo "=========================================="
echo ""

# 启动服务
python api_service.py ${PORT}

