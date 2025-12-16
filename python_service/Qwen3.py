"""
Qwen3 API 调用模块
用于将植物病虫害识别结果转换为人类理解的语言
"""
import os
import json
from openai import OpenAI
from typing import Generator, Dict, Any


class Qwen3Client:
    """Qwen3 API 客户端"""
    
    def __init__(self, api_key: str = None, base_url: str = None, model: str = None):
        """
        初始化 Qwen3 客户端
        
        Args:
            api_key: API Key，如果为 None 则使用默认值或环境变量 DASHSCOPE_API_KEY
            base_url: API Base URL，如果为 None 则使用默认值（北京地区）
            model: 模型名称，如果为 None 则使用默认值
        """
        # 优先使用环境变量 DASHSCOPE_API_KEY（与官方示例一致）
        self.api_key = api_key or os.getenv("DASHSCOPE_API_KEY") or os.getenv("QWEN_API_KEY", "sk-f0fef76e5fb54b77a4642a3cd5c06d40")
        # 使用北京地区的 base_url（与官方示例一致）
        self.base_url = base_url or os.getenv("QWEN_BASE_URL", "https://dashscope.aliyuncs.com/compatible-mode/v1")
        self.model = model or os.getenv("QWEN_MODEL", "qwen-plus")
        
        print(f"[Qwen3] 初始化客户端:")
        print(f"  API Key: {self.api_key[:10]}...{self.api_key[-4:] if len(self.api_key) > 14 else '***'}")
        print(f"  Base URL: {self.base_url}")
        print(f"  Model: {self.model}")
        
        try:
            self.client = OpenAI(
                api_key=self.api_key,
                base_url=self.base_url,
            )
            print(f"[Qwen3] ✓ 客户端初始化成功")
        except Exception as e:
            print(f"[Qwen3] ✗ 客户端初始化失败: {e}")
            raise
    
    def explain_disease_result(self, result_json: Dict[str, Any], max_length: int = 300) -> Generator[str, None, None]:
        """
        将识别结果转换为人类理解的语言（流式输出）
        
        Args:
            result_json: MobilePlantViT 的识别结果 JSON
            max_length: 最大字数限制
            
        Yields:
            str: SSE 格式的数据行
        """
        # 构建 Qwen3 的提示词
        prompt = f"""你是一位专业的农业专家。请根据以下植物病虫害识别结果，用通俗易懂的中文为用户解释：

识别结果：
{json.dumps(result_json, ensure_ascii=False, indent=2)}

请提供：
1. 简要说明识别到的作物和病害情况
2. 这种病害的主要症状和危害
3. 防治建议（包括农业防治、化学防治等）
4. 注意事项

请用友好、专业的语气，让普通农户也能理解。字数在{max_length}字以内"""
        
        try:
            print(f"[Qwen3] 开始调用 API，模型: {self.model}")
            print(f"[Qwen3] 提示词长度: {len(prompt)} 字符")
            
            stream = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "system", "content": "你是一位专业的农业专家，擅长用通俗易懂的语言解释植物病虫害问题。"},
                    {"role": "user", "content": prompt}
                ],
                stream=True
            )
            
            print(f"[Qwen3] ✓ API 调用成功，开始接收流式数据")
            chunk_count = 0
            
            for chunk in stream:
                if chunk.choices and len(chunk.choices) > 0:
                    if chunk.choices[0].delta.content:
                        content = chunk.choices[0].delta.content
                        chunk_count += 1
                        yield f"data: {json.dumps({'content': content}, ensure_ascii=False)}\n\n"
            
            print(f"[Qwen3] ✓ 流式数据接收完成，共 {chunk_count} 个数据块")
            yield "data: [DONE]\n\n"
            
        except Exception as e:
            import traceback
            error_detail = traceback.format_exc()
            error_msg = f"Qwen3 API 调用失败: {str(e)}"
            print(f"[Qwen3] ✗ 错误详情:")
            print(f"[Qwen3] {error_msg}")
            print(f"[Qwen3] 完整错误信息:")
            print(error_detail)
            yield f"data: {json.dumps({'error': error_msg}, ensure_ascii=False)}\n\n"
    
    def explain_disease_result_sync(self, result_json: Dict[str, Any], max_length: int = 300) -> str:
        """
        将识别结果转换为人类理解的语言（同步版本，返回完整文本）
        
        Args:
            result_json: MobilePlantViT 的识别结果 JSON
            max_length: 最大字数限制
            
        Returns:
            str: 完整的解释文本
        """
        # 构建 Qwen3 的提示词
        prompt = f"""你是一位专业的农业专家。请根据以下植物病虫害识别结果，用通俗易懂的中文为用户解释：

识别结果：
{json.dumps(result_json, ensure_ascii=False, indent=2)}

请提供：
1. 简要说明识别到的作物和病害情况
2. 这种病害的主要症状和危害
3. 防治建议（包括农业防治、化学防治等）
4. 注意事项

请用友好、专业的语气，让普通农户也能理解。字数在{max_length}字以内"""
        
        try:
            print(f"[Qwen3] 开始调用 API（同步），模型: {self.model}")
            completion = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "system", "content": "你是一位专业的农业专家，擅长用通俗易懂的语言解释植物病虫害问题。"},
                    {"role": "user", "content": prompt}
                ],
                stream=true
            )
            
            result = completion.choices[0].message.content
            print(f"[Qwen3] ✓ API 调用成功，返回长度: {len(result)} 字符")
            return result
            
        except Exception as e:
            import traceback
            error_detail = traceback.format_exc()
            error_msg = f"Qwen3 API 调用失败: {str(e)}"
            print(f"[Qwen3] ✗ 错误详情:")
            print(f"[Qwen3] {error_msg}")
            print(f"[Qwen3] 完整错误信息:")
            print(error_detail)
            raise Exception(error_msg)


# 全局单例实例（可选）
_qwen3_client = None

def get_qwen3_client() -> Qwen3Client:
    """获取 Qwen3 客户端单例"""
    global _qwen3_client
    if _qwen3_client is None:
        _qwen3_client = Qwen3Client()
    return _qwen3_client

