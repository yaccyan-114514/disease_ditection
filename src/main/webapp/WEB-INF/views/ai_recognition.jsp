<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>拍照识别农作物病虫害</title>
    <style>
        body {
            font-family: "PingFang SC", sans-serif;
            background: url('${pageContext.request.contextPath}/assets/backgroud.jpg') no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 860px;
            margin: 0 auto;
            background: #fff;
            padding: 32px;
            border-radius: 16px;
            box-shadow: 0 24px 60px rgba(15,23,42,.08);
        }
        h2 {
            margin-top: 0;
        }
        form {
            border: 1px dashed #d0d7de;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
        }
        input[type=file] {
            margin: 16px 0;
        }
        button {
            background: #1f883d;
            color: #fff;
            border: none;
            padding: 12px 28px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background: #1a7a35;
        }
        button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        .result {
            margin-top: 24px;
            padding: 20px;
            border-radius: 12px;
            background: #e9f5ee;
            border: 1px solid #a9d7ba;
        }
        img.preview {
            max-width: 280px;
            border-radius: 12px;
            margin-top: 12px;
        }
        .error {
            background: #fdecea;
            color: #b42318;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 16px;
        }
        .explain-section {
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border: 1px solid #e1e4e8;
        }
        .explain-section h3 {
            margin-top: 0;
            color: #24292e;
        }
        .explain-content {
            min-height: 100px;
            padding: 15px;
            background: #fff;
            border-radius: 8px;
            border: 1px solid #e1e4e8;
            white-space: pre-wrap;
            word-wrap: break-word;
            line-height: 1.6;
            font-size: 14px;
            color: #24292e;
        }
        .explain-content.loading {
            color: #586069;
            font-style: italic;
        }
        .btn-explain {
            background: #0366d6;
            margin-top: 10px;
        }
        .btn-explain:hover {
            background: #0256c2;
        }
        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid #0366d6;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 8px;
            vertical-align: middle;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>拍照识别农作物病虫害</h2>
    <p>请上传现场照片</p>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/ai/recognize" enctype="multipart/form-data" id="uploadForm">
        <div>
            <input type="file" name="image" accept="image/*" required id="imageInput">
        </div>
        <button type="submit" id="submitBtn">开始识别</button>
    </form>
    
    <c:if test="${not empty record}">
        <div class="result">
            <h3>识别结果</h3>
            <p><strong>疑似病虫害：</strong> ${record.aiResult}</p>
            <p><strong>AI 建议：</strong> 结合数据库知识，建议参考相应防控措施并保存该记录。</p>
            <c:if test="${not empty imagePath}">
                <img class="preview" src="${pageContext.request.contextPath}${imagePath}" alt="上传图片">
            </c:if>
            
            <!-- Qwen3 解释区域 -->
            <div class="explain-section">
                <h3>💡 AI 专业解释</h3>
                <button type="button" class="btn-explain" id="explainBtn" onclick="startExplanation()">
                    获取专业解释
                </button>
                <div id="explainContent" class="explain-content" style="display: none;"></div>
            </div>
        </div>
    </c:if>
</div>

<script>
    // 流式接收 Server-Sent Events
    function startExplanation() {
        const explainBtn = document.getElementById('explainBtn');
        const explainContent = document.getElementById('explainContent');
        
        // 禁用按钮
        explainBtn.disabled = true;
        explainBtn.innerHTML = '<span class="loading-spinner"></span>正在生成解释...';
        
        // 显示内容区域
        explainContent.style.display = 'block';
        explainContent.textContent = '';
        explainContent.className = 'explain-content loading';
        
        // 使用 fetch API 读取流式响应
        fetch('${pageContext.request.contextPath}/ai/explain', {
            method: 'GET',
            headers: {
                'Accept': 'text/event-stream'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('HTTP error! status: ' + response.status);
            }
            
            const reader = response.body.getReader();
            const decoder = new TextDecoder();
            
            function readStream() {
                reader.read().then(({ done, value }) => {
                    if (done) {
                        explainBtn.disabled = false;
                        explainBtn.textContent = '重新生成解释';
                        explainContent.className = 'explain-content';
                        return;
                    }
                    
                    const chunk = decoder.decode(value, { stream: true });
                    const lines = chunk.split('\n');
                    
                    for (const line of lines) {
                        if (line.startsWith('data: ')) {
                            const dataStr = line.substring(6);
                            if (dataStr === '[DONE]') {
                                explainBtn.disabled = false;
                                explainBtn.textContent = '重新生成解释';
                                explainContent.className = 'explain-content';
                                return;
                            }
                            
                            try {
                                const data = JSON.parse(dataStr);
                                
                                if (data.error) {
                                    explainContent.textContent = '错误: ' + data.error;
                                    explainContent.className = 'explain-content';
                                    explainBtn.disabled = false;
                                    explainBtn.textContent = '重试';
                                    return;
                                }
                                
                                if (data.content) {
                                    explainContent.className = 'explain-content';
                                    explainContent.textContent += data.content;
                                    // 自动滚动到底部
                                    explainContent.scrollTop = explainContent.scrollHeight;
                                }
                            } catch (e) {
                                console.error('解析 SSE 数据失败:', e, dataStr);
                            }
                        }
                    }
                    
                    readStream();
                }).catch(error => {
                    console.error('读取流失败:', error);
                    explainContent.textContent = '读取错误: ' + error.message;
                    explainContent.className = 'explain-content';
                    explainBtn.disabled = false;
                    explainBtn.textContent = '重试';
                });
            }
            
            readStream();
        })
        .catch(error => {
            console.error('请求失败:', error);
            explainContent.textContent = '请求失败: ' + error.message;
            explainContent.className = 'explain-content';
            explainBtn.disabled = false;
            explainBtn.textContent = '重试';
        });
    }
    
    // 表单提交时禁用按钮
    document.getElementById('uploadForm').addEventListener('submit', function() {
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = '识别中...';
    });
</script>
</body>
</html>
