<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>专家问答</title>
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
            max-width: 1000px;
            margin: 32px auto;
            padding: 0 16px;
            position: relative;
            z-index: 1;
        }
        .chat-area {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 120px);
            background: rgba(0,0,0,0.15);
            border-radius: 16px;
            overflow: hidden;
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
        .expert-info {
            font-size: 14px;
            opacity: 0.8;
            margin-top: 4px;
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
            align-self: flex-end;
        }
        .message.expert {
            align-self: flex-start;
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
            background: rgba(40, 167, 69, 0.3);
            border-top-right-radius: 4px;
        }
        .message.expert .message-content {
            background: rgba(255,255,255,0.15);
            border-top-left-radius: 4px;
        }
        .message-time {
            font-size: 11px;
            opacity: 0.6;
            margin-top: 4px;
            padding: 0 8px;
        }
        .question-id {
            font-size: 11px;
            opacity: 0.6;
            margin-top: 4px;
        }
        .chat-input {
            padding: 16px 24px;
            border-top: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(6px);
            background: rgba(0,0,0,0.2);
        }
        .chat-input-form {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .chat-input textarea {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-family: inherit;
            font-size: 14px;
            resize: vertical;
            min-height: 80px;
        }
        .chat-input textarea::placeholder {
            color: rgba(255,255,255,0.5);
        }
        .input-actions {
            display: flex;
            gap: 8px;
            align-items: center;
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
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            background: rgba(255,255,255,0.25);
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn:hover {
            background: rgba(255,255,255,0.35);
        }
        .empty-chat {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
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
        .image-preview {
            margin-top: 8px;
        }
        .image-preview img {
            max-width: 200px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            cursor: pointer;
        }
    </style>
</head>
<body>
<header>
    <div>
        <strong>专家问答</strong>
        <c:if test="${unreadCount > 0}">
            <span style="margin-left: 12px; background: rgba(220, 53, 69, 0.8); color: #fff; border-radius: 10px; padding: 2px 8px; font-size: 12px; font-weight: 600;">${unreadCount} 条未读消息</span>
        </c:if>
    </div>
    <div class="actions">
        <c:if test="${not empty currentFarmer}">
            <span>${currentFarmer.name}</span>
            <c:if test="${unreadCount > 0}">
                <form method="post" action="${pageContext.request.contextPath}/message/read/all" style="display: inline;">
                    <button type="submit" style="background: rgba(40, 167, 69, 0.6); color: #fff; border: none; padding: 6px 14px; border-radius: 20px; cursor: pointer; font-size: 12px;">全部标记为已读</button>
                </form>
            </c:if>
            <a href="${pageContext.request.contextPath}/farmer/home">返回首页</a>
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

    <div class="chat-area">
        <div class="chat-header">
            <h3>
                <c:choose>
                    <c:when test="${not empty assignedExpert}">
                        ${assignedExpert.name}（${assignedExpert.title}）
                    </c:when>
                    <c:otherwise>
                        专家问答
                    </c:otherwise>
                </c:choose>
            </h3>
            <c:if test="${not empty assignedExpert}">
                <div class="expert-info">
                    ${assignedExpert.organization} | ${assignedExpert.specialty}
                </div>
            </c:if>
        </div>
        
        <div class="chat-messages">
            <c:choose>
                <c:when test="${not empty conversations && fn:length(conversations) > 0}">
                    <c:forEach var="question" items="${conversations}">
                        <!-- 农户的问题 -->
                        <div class="message farmer">
                            <div class="message-header">我</div>
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
                            <c:set var="isUnread" value="false"/>
                            <c:set var="messageId" value=""/>
                            <c:forEach var="msg" items="${messages}">
                                <c:if test="${msg.answerId == answer.id && msg.isRead == false}">
                                    <c:set var="isUnread" value="true"/>
                                    <c:set var="messageId" value="${msg.id}"/>
                                </c:if>
                            </c:forEach>
                            <div class="message expert ${isUnread ? 'unread-message' : ''}" style="${isUnread ? 'border-left: 3px solid rgba(220, 53, 69, 0.8); padding-left: 8px;' : ''}">
                                <div class="message-header">
                                    <c:choose>
                                        <c:when test="${not empty answer.expert}">
                                            ${answer.expert.name}
                                        </c:when>
                                        <c:otherwise>
                                            专家
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${isUnread}">
                                        <span style="margin-left: 8px; background: rgba(220, 53, 69, 0.8); color: #fff; border-radius: 10px; padding: 2px 6px; font-size: 10px; font-weight: 600;">新消息</span>
                                    </c:if>
                                </div>
                                <div class="message-content">
                                    ${answer.answerText}
                                    <c:if test="${not empty answer.images}">
                                        <div class="image-preview">
                                            <img src="${pageContext.request.contextPath}${answer.images}" 
                                                 alt="回答图片" 
                                                 onclick="window.open('${pageContext.request.contextPath}${answer.images}', '_blank')">
                                        </div>
                                    </c:if>
                                </div>
                                <div class="message-time">
                                    ${fn:replace(fn:substring(answer.createdAt.toString(), 0, 16), 'T', ' ')}
                                    <c:if test="${isUnread && not empty messageId}">
                                        <form method="post" action="${pageContext.request.contextPath}/message/read" style="display: inline; margin-left: 8px;">
                                            <input type="hidden" name="messageId" value="${messageId}">
                                            <button type="submit" style="background: rgba(40, 167, 69, 0.6); color: #fff; border: none; padding: 2px 8px; border-radius: 4px; cursor: pointer; font-size: 10px;">标记已读</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-chat">
                        <p>暂无对话记录，请提交您的问题</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="chat-input">
            <form method="post" action="${pageContext.request.contextPath}/expert/qa" 
                  enctype="multipart/form-data" class="chat-input-form">
                <textarea name="questionText" placeholder="输入您的问题..." required></textarea>
                <div class="input-actions">
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
                    <button type="submit" class="btn">发送</button>
                </div>
            </form>
        </div>
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
