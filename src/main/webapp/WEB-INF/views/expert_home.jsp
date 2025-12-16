<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>专家工作台</title>
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
        .chat-container {
            display: flex;
            height: calc(100vh - 80px);
            position: relative;
            z-index: 1;
        }
        .user-list {
            width: 280px;
            background: rgba(0,0,0,0.25);
            border-right: 1px solid rgba(255,255,255,0.1);
            overflow-y: auto;
            backdrop-filter: blur(6px);
        }
        .user-list-header {
            padding: 16px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            font-weight: 600;
            font-size: 16px;
        }
        .user-item {
            padding: 16px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            cursor: pointer;
            transition: background 0.2s;
        }
        .user-item:hover {
            background: rgba(255,255,255,0.1);
        }
        .user-item.active {
            background: rgba(255,255,255,0.15);
        }
        .user-name {
            font-weight: 600;
            margin-bottom: 4px;
        }
        .user-phone {
            font-size: 12px;
            opacity: 0.7;
        }
        .chat-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: rgba(0,0,0,0.15);
        }
        .chat-header {
            padding: 16px 24px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(6px);
            background: rgba(0,0,0,0.2);
        }
        .chat-header h3 {
            margin: 0;
            font-size: 18px;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .message {
            display: flex;
            flex-direction: column;
            max-width: 70%;
        }
        .message.farmer {
            align-self: flex-start;
        }
        .message.expert {
            align-self: flex-end;
        }
        .message-header {
            font-size: 12px;
            opacity: 0.7;
            margin-bottom: 4px;
            padding: 0 8px;
        }
        .message-content {
            padding: 12px 16px;
            border-radius: 12px;
            line-height: 1.6;
            word-wrap: break-word;
        }
        .message.farmer .message-content {
            background: rgba(255,255,255,0.15);
            border-top-left-radius: 4px;
        }
        .message.expert .message-content {
            background: rgba(40, 167, 69, 0.3);
            border-top-right-radius: 4px;
        }
        .message-time {
            font-size: 11px;
            opacity: 0.6;
            margin-top: 4px;
            padding: 0 8px;
        }
        .chat-input {
            padding: 16px 24px;
            border-top: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(6px);
            background: rgba(0,0,0,0.2);
        }
        .chat-input-form {
            display: flex;
            gap: 12px;
        }
        .chat-input textarea {
            flex: 1;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-family: inherit;
            font-size: 14px;
            resize: none;
            min-height: 60px;
        }
        .chat-input textarea::placeholder {
            color: rgba(255,255,255,0.5);
        }
        .chat-input button {
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            background: rgba(255,255,255,0.25);
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .chat-input button:hover {
            background: rgba(255,255,255,0.35);
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
        .empty-chat {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
            opacity: 0.7;
        }
        .empty-user-list {
            padding: 40px 20px;
            text-align: center;
            opacity: 0.7;
        }
        .actions a {
            color: #fff;
            background: rgba(255,255,255,0.25);
            padding: 6px 14px;
            border-radius: 20px;
            text-decoration: none;
            margin-left: 12px;
        }
        .question-id {
            font-size: 11px;
            opacity: 0.6;
            margin-top: 4px;
        }
    </style>
</head>
<body>
<header>
    <div>
        <strong>专家工作台</strong>
        <a href="${pageContext.request.contextPath}/expert/knowledge" style="color: #fff; text-decoration: none; margin-left: 24px; padding: 6px 14px; background: rgba(255,255,255,0.25); border-radius: 20px;">农产品知识库</a>
    </div>
    <div class="actions">
        <c:if test="${not empty currentExpert}">
            <a href="${pageContext.request.contextPath}/expert/profile/edit" style="color: #fff; text-decoration: none; margin-right: 12px;">${currentExpert.name}（${currentExpert.title}）</a>
            <a href="${pageContext.request.contextPath}/farmer/logout">退出</a>
        </c:if>
    </div>
</header>

<div class="chat-container">
    <!-- 左侧用户列表 -->
    <div class="user-list">
        <div class="user-list-header">帮扶用户</div>
        <c:choose>
            <c:when test="${not empty helpedUsers && fn:length(helpedUsers) > 0}">
                <c:forEach var="user" items="${helpedUsers}">
                    <div class="user-item ${selectedUser != null && selectedUser.id == user.id ? 'active' : ''}" 
                         onclick="location.href='${pageContext.request.contextPath}/expert?userId=${user.id}'">
                        <div class="user-name">${user.name}</div>
                        <div class="user-phone">${user.phone}</div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-user-list">
                    <p>暂无帮扶用户</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 右侧对话区域 -->
    <div class="chat-area">
        <c:choose>
            <c:when test="${not empty selectedUser}">
                <div class="chat-header">
                    <h3>${selectedUser.name}（${selectedUser.phone}）</h3>
                </div>
                <div class="chat-messages">
                    <c:choose>
                        <c:when test="${not empty conversations && fn:length(conversations) > 0}">
                            <c:forEach var="question" items="${conversations}">
                                <!-- 农民的问题 -->
                                <div class="message farmer">
                                    <div class="message-header">${question.asker.name}</div>
                                    <div class="message-content">
                                        ${question.questionText}
                                        <div class="question-id">问题 #${question.id}</div>
                                    </div>
                                    <div class="message-time">
                                        ${fn:replace(fn:substring(question.createdAt.toString(), 0, 16), 'T', ' ')}
                                    </div>
                                </div>
                                
                                <!-- 专家的回答 -->
                                <c:forEach var="answer" items="${question.answers}">
                                    <div class="message expert">
                                        <div class="message-header">${currentExpert.name}</div>
                                        <div class="message-content">
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
                                        <div class="message-time">
                                            ${fn:replace(fn:substring(answer.createdAt.toString(), 0, 16), 'T', ' ')}
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-chat">
                                <p>暂无对话记录</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="chat-input">
                    <c:if test="${not empty conversations && fn:length(conversations) > 0}">
                        <c:set var="pendingQuestion" value="${null}" />
                        <c:forEach var="q" items="${conversations}">
                            <c:if test="${q.status == 'pending' && pendingQuestion == null}">
                                <c:set var="pendingQuestion" value="${q}" />
                            </c:if>
                        </c:forEach>
                        <c:if test="${pendingQuestion == null && fn:length(conversations) > 0}">
                            <c:set var="pendingQuestion" value="${conversations[0]}" />
                        </c:if>
                        <c:if test="${pendingQuestion != null}">
                            <form method="post" action="${pageContext.request.contextPath}/expert/answer" 
                                  enctype="multipart/form-data" class="chat-input-form">
                                <input type="hidden" name="questionId" value="${pendingQuestion.id}">
                                <textarea name="answerText" placeholder="输入回答..." required></textarea>
                                <div style="display: flex; gap: 8px; align-items: center;">
                                    <div class="file-upload-wrapper">
                                        <input type="file" name="image" accept="image/*" id="imageInput">
                                        <label for="imageInput" class="file-upload-button">
                                            <img src="${pageContext.request.contextPath}/assets/pictures.png" alt="上传图片">
                                        </label>
                                        <span class="file-name" id="fileName"></span>
                                    </div>
                                    <button type="submit">发送</button>
                                </div>
                                <div id="imagePreview" style="margin-top: 8px; display: none;">
                                    <img id="previewImg" src="" alt="预览" style="max-width: 200px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.3);">
                                    <button type="button" onclick="clearImage()" style="margin-left: 8px; padding: 4px 8px; background: rgba(220,53,69,0.3); color: #fff; border: none; border-radius: 4px; cursor: pointer;">删除</button>
                                </div>
                            </form>
                        </c:if>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="chat-area">
                    <div class="empty-chat">
                        <p>请从左侧选择用户开始对话</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // 自动滚动到底部
    window.addEventListener('load', function() {
        const chatMessages = document.querySelector('.chat-messages');
        if (chatMessages) {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
    });

    // 图片预览功能
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
</body>
</html>
