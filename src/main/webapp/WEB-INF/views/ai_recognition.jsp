<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>拍照识别农作物病虫害</title>
    <style>
        body {font-family:"PingFang SC",sans-serif;background:#f6f8fa;margin:0;}
        .container {max-width: 860px;margin:40px auto;background:#fff;padding:32px;border-radius:16px;box-shadow:0 24px 60px rgba(15,23,42,.08);}
        h2 {margin-top:0;}
        form {border:1px dashed #d0d7de;padding:20px;border-radius:12px;text-align:center;}
        input[type=file] {margin:16px 0;}
        button {background:#1f883d;color:#fff;border:none;padding:12px 28px;border-radius:8px;font-size:16px;}
        .result {margin-top:24px;padding:20px;border-radius:12px;background:#e9f5ee;border:1px solid #a9d7ba;}
        img.preview {max-width:280px;border-radius:12px;margin-top:12px;}
        .error {background:#fdecea;color:#b42318;padding:12px;border-radius:10px;margin-bottom:16px;}
    </style>
</head>
<body>
<div class="container">
    <h2>拍照识别农作物病虫害</h2>
    <p>上传现场照片，AI 模块会给出疑似病虫害名称与建议。本示例使用内置模型进行快速体验。</p>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/ai/recognize" enctype="multipart/form-data">
        <label>选择作物（可选）</label>
        <input type="number" name="cropId" placeholder="输入 crop_id">
        <div>
            <input type="file" name="image" accept="image/*" required>
        </div>
        <button type="submit">开始识别</button>
    </form>
    <c:if test="${not empty record}">
        <div class="result">
            <h3>识别结果</h3>
            <p><strong>疑似病虫害：</strong> ${record.aiResult}</p>
            <p><strong>AI 建议：</strong> 结合数据库知识，建议参考相应防控措施并保存该记录。</p>
            <c:if test="${not empty imagePath}">
                <img class="preview" src="${imagePath}" alt="上传图片">
            </c:if>
        </div>
    </c:if>
</div>
</body>
</html>

