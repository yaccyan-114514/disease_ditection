#!/bin/bash

# Docker 启动脚本

echo "=========================================="
echo "  疾病检测系统 Docker 启动脚本"
echo "=========================================="
echo ""

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ 错误: 未找到 Docker，请先安装 Docker"
    echo "访问: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# 检查 Docker Compose 是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "❌ 错误: 未找到 Docker Compose，请先安装 Docker Compose"
    exit 1
fi

echo "✓ Docker 环境检查通过"
echo ""

# 检查模型文件是否存在
if [ ! -f "python_service/streamlit_app/model/best_model_tuned.weights.h5" ]; then
    echo "⚠️  警告: 未找到模型文件 best_model_tuned.weights.h5"
    echo "   请确保模型文件存在于: python_service/streamlit_app/model/"
    echo ""
    read -p "是否继续启动？（模型文件缺失可能导致 AI 功能无法使用）[y/N]: " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "已取消启动"
        exit 1
    fi
fi

# 检查数据库初始化文件
if [ ! -f "disease_detection.sql" ]; then
    echo "❌ 错误: 未找到数据库初始化文件 disease_detection.sql"
    exit 1
fi

echo "✓ 文件检查通过"
echo ""

# 询问是否构建镜像
read -p "是否需要重新构建镜像？[y/N]: " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "正在构建镜像..."
    docker-compose build
    echo ""
fi

# 启动服务
echo "正在启动服务..."
docker-compose up -d

# 等待服务启动
echo ""
echo "等待服务启动（这可能需要 30-60 秒）..."
sleep 5

# 检查服务状态
echo ""
echo "服务状态："
docker-compose ps

echo ""
echo "=========================================="
echo "  启动完成！"
echo "=========================================="
echo ""
echo "访问地址："
echo "  - Java Web 应用: http://localhost:8080"
echo "  - Python API 服务: http://localhost:5050/health"
echo ""
echo "常用命令："
echo "  - 查看日志: docker-compose logs -f"
echo "  - 停止服务: docker-compose stop"
echo "  - 重启服务: docker-compose restart"
echo "  - 查看状态: docker-compose ps"
echo ""
echo "详细文档请查看: DOCKER_README.txt"
echo "=========================================="
