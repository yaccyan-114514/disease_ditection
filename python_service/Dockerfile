# Python API 服务 Dockerfile
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements_api.txt .

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements_api.txt

# 复制应用代码
COPY . .

# 创建上传目录
RUN mkdir -p /app/uploads

# 暴露端口
EXPOSE 5050

# 设置环境变量
ENV PORT=5050
ENV PYTHONUNBUFFERED=1

# 启动服务
CMD ["python", "api_service.py", "5050"]
