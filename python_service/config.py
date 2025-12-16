"""
配置文件 - 可以通过环境变量覆盖
"""
import os

# API 服务配置
API_HOST = os.getenv('API_HOST', '0.0.0.0')
API_PORT = int(os.getenv('API_PORT', os.getenv('PORT', '5050')))

# 模型配置
IMG_SIZE = (160, 160)

# 最佳超参数（与训练时一致）
BEST = {
    "use_data_augmentation": False,
    "dense_units": 256,
    "dropout": 0.1,
    "activation": "swish"
}

