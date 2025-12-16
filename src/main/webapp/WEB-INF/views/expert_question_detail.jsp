<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>问题详情 - 专家工作台</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0;
            min-height: 100vh;
            color: #fff;
            background-image: url('${pageContext.request.contextPath}/assets/backgroud.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            position: relative;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            z-index: -1;
        }
        header {
            color: #fff;
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            backdrop-filter: blur(6px);
            background: rgba(0,0,0,0.35);
            position: relative;
            z-index: 1;
        }
        .container {
            max-width: 900px;
            margin: 32px auto;
            padding: 0 16px;
            position: relative;
            z-index: 1;
        }
        .card {
            background: rgba(255,255,255,0.12);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 25px 45px rgba(0,0,0,.25);
            border: 1px solid rgba(255,255,255,0.15);
        }
        .question-section {
            margin-bottom: 24px;
        }
        .question-section h3 {
            margin-top: 0;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 12px;
        }
        .question-meta {
            font-size: 14px;
            opacity: 0.8;
            margin-bottom: 16px;
        }
        .question-text {
            line-height: 1.8;
            font-size: 16px;
            margin: 16px 0;
        }
        .answer-section {
            margin-top: 32px;
        }
        .answer-item {
            background: rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 16px;
        }
        .answer-meta {
            font-size: 12px;
            opacity: 0.7;
            margin-bottom: 8px;
        }
        .answer-text {
            line-height: 1.6;
        }
        .answer-form {
            margin-top: 24px;
        }
        textarea {
            width: 100%;
            min-height: 150px;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-family: inherit;
            font-size: 14px;
            resize: vertical;
        }
        textarea::placeholder {
            color: rgba(255,255,255,0.5);
        }
        .btn {
            display: inline-block;
            padding: 10px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            margin-top: 12px;
        }
        .btn-primary {
            background: rgba(255,255,255,0.25);
            color: #fff;
        }
        .btn-primary:hover {
            background: rgba(255,255,255,0.35);
        }
        .btn-secondary {
            background: rgba(255,255,255,0.15);
            color: #fff;
        }
        .actions a {
            color: #fff;
            background: rgba(255,255,255,0.25);
            padding: 6px 14px;
            border-radius: 20px;
            text-decoration: none;
            margin-left: 12px;
        }
        .error, .message {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
        }
        .error {
            background: rgba(220, 53, 69, 0.3);
            border: 1px solid rgba(220, 53, 69, 0.5);
        }
        .message {
            background: rgba(40, 167, 69, 0.3);
            border: 1px solid rgba(40, 167, 69, 0.5);
        }
        .file-upload-wrapper {
            position: relative;
            display: inline-block;
        }
        .file-upload-wrapper input[type="file"] {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }
        .file-upload-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            padding: 0;
        }
        .file-upload-button:hover {
            background: rgba(255,255,255,0.25);
            border-color: rgba(255,255,255,0.5);
        }
        .file-upload-button img {
            width: 24px;
            height: 24px;
            opacity: 0.9;
        }
        .file-name {
            font-size: 12px;
            opacity: 0.7;
            margin-left: 8px;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<header>
    <div>
        <strong>问题详情</strong>
    </div>
    <div class="actions">
        <c:if test="${not empty currentExpert}">
            <span>${currentExpert.name}</span>
            <a href="${pageContext.request.contextPath}/expert">返回列表</a>
            <a href="${pageContext.request.contextPath}/farmer/logout">退出</a>
        </c:if>
    </div>
</header>

<div class="container">
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>

    <c:if test="${not empty question}">
        <div class="card question-section">
            <h3>问题 #${question.id}</h3>
            <div class="question-meta">
                <c:if test="${not empty question.asker}">
                    <strong>提问者：</strong>${question.asker.name}（${question.asker.phone}）
                    <c:if test="${not empty question.asker.region}">
                        | ${question.asker.region}
                    </c:if>
                </c:if>
                <c:if test="${not empty question.createdAt}">
                    | <strong>提问时间：</strong>${fn:replace(fn:substring(question.createdAt.toString(), 0, 16), 'T', ' ')}
                </c:if>
            </div>
            <div class="question-text">
                ${question.questionText}
            </div>
        </div>

        <div class="card answer-section">
            <h3>我的回答</h3>
            <c:choose>
                <c:when test="${not empty question.answers && fn:length(question.answers) > 0}">
                    <c:forEach var="answer" items="${question.answers}">
                        <div class="answer-item">
                            <div class="answer-meta">
                                ${fn:replace(fn:substring(answer.createdAt.toString(), 0, 16), 'T', ' ')}
                            </div>
                            <div class="answer-text">
                                ${answer.answerText}
                                <c:if test="${not empty answer.images}">
                                    <div style="margin-top: 8px;">
                                        <img src="${pageContext.request.contextPath}${answer.images}" 
                                             alt="回答图片" 
                                             style="max-width: 100%; border-radius: 8px; cursor: pointer;"
                                             onclick="window.open('${pageContext.request.contextPath}${answer.images}', '_blank')">
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="opacity: 0.7;">暂无回答</p>
                </c:otherwise>
            </c:choose>

            <form method="post" action="${pageContext.request.contextPath}/expert/answer" 
                  enctype="multipart/form-data" class="answer-form">
                <input type="hidden" name="questionId" value="${question.id}">
                <textarea name="answerText" placeholder="请输入您的回答..." required></textarea>
                <div style="margin-top: 12px; display: flex; align-items: center; gap: 8px;">
                    <div class="file-upload-wrapper">
                        <input type="file" name="image" accept="image/*" id="imageInput">
                        <label for="imageInput" class="file-upload-button">
                            <img src="${pageContext.request.contextPath}/assets/pictures.png" alt="上传图片">
                        </label>
                        <span class="file-name" id="fileName"></span>
                    </div>
                    <div id="imagePreview" style="display: none; flex: 1;">
                        <img id="previewImg" src="" alt="预览" style="max-width: 200px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.3);">
                        <button type="button" onclick="clearImage()" style="margin-left: 8px; padding: 4px 8px; background: rgba(220,53,69,0.3); color: #fff; border: none; border-radius: 4px; cursor: pointer;">删除</button>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">提交回答</button>
            </form>
            <script>
                document.getElementById('imageInput')?.addEventListener('change', function(e) {
                    const file = e.target.files[0];
                    const fileName = document.getElementById('fileName');
                    if (file) {
                        // 显示文件名
                        if (fileName) {
                            fileName.textContent = file.name;
                        }
                        // 显示预览
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const preview = document.getElementById('imagePreview');
                            const previewImg = document.getElementById('previewImg');
                            if (preview && previewImg) {
                                previewImg.src = e.target.result;
                                preview.style.display = 'block';
                            }
                        };
                        reader.readAsDataURL(file);
                    } else {
                        if (fileName) {
                            fileName.textContent = '';
                        }
                    }
                });
                function clearImage() {
                    const input = document.getElementById('imageInput');
                    const preview = document.getElementById('imagePreview');
                    const fileName = document.getElementById('fileName');
                    if (input) input.value = '';
                    if (preview) preview.style.display = 'none';
                    if (fileName) fileName.textContent = '';
                }
            </script>
        </div>
    </c:if>

    <div style="text-align: center; margin-top: 24px;">
        <a href="${pageContext.request.contextPath}/expert" class="btn btn-secondary">返回问题列表</a>
    </div>
</div>
</body>
</html>

