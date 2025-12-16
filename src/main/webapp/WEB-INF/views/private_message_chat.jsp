<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>私信对话</title>
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
        .message.sent {
            align-self: flex-end;
        }
        .message.received {
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
        .message.sent .message-content {
            background: rgba(40, 167, 69, 0.3);
            border-top-right-radius: 4px;
        }
        .message.received .message-content {
            background: rgba(255,255,255,0.15);
            border-top-left-radius: 4px;
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
            resize: vertical;
            min-height: 80px;
        }
        .chat-input textarea::placeholder {
            color: rgba(255,255,255,0.5);
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
    </style>
</head>
<body>
<header>
    <div>
        <strong>
            <c:choose>
                <c:when test="${otherUserType == 'farmer'}">
                    ${otherUser.name}
                </c:when>
                <c:otherwise>
                    ${otherUser.name}（${otherUser.title}）
                </c:otherwise>
            </c:choose>
        </strong>
    </div>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/private-message/list">返回列表</a>
        <c:if test="${not empty currentFarmer}">
            <a href="${pageContext.request.contextPath}/farmer/home">返回首页</a>
            <a href="${pageContext.request.contextPath}/farmer/logout">退出</a>
        </c:if>
        <c:if test="${not empty currentExpert}">
            <a href="${pageContext.request.contextPath}/expert">返回工作台</a>
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
                    <c:when test="${otherUserType == 'farmer'}">
                        ${otherUser.name}
                    </c:when>
                    <c:otherwise>
                        ${otherUser.name}（${otherUser.title}）
                    </c:otherwise>
                </c:choose>
            </h3>
        </div>
        
        <div class="chat-messages">
            <c:choose>
                <c:when test="${not empty messages && fn:length(messages) > 0}">
                    <c:forEach var="msg" items="${messages}">
                        <c:set var="isSent" value="${msg.senderId == (currentFarmer != null ? currentFarmer.id : currentExpert.id)}"/>
                        <div class="message ${isSent ? 'sent' : 'received'}">
                            <div class="message-header">
                                <c:choose>
                                    <c:when test="${isSent}">
                                        我
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${otherUserType == 'farmer'}">
                                                ${otherUser.name}
                                            </c:when>
                                            <c:otherwise>
                                                ${otherUser.name}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="message-content">${msg.content}</div>
                            <div class="message-time">
                                ${fn:replace(fn:substring(msg.createdAt.toString(), 0, 16), 'T', ' ')}
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; opacity: 0.7; padding: 40px;">
                        <p>暂无消息，开始对话吧！</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="chat-input">
            <form method="post" action="${pageContext.request.contextPath}/private-message/send" class="chat-input-form">
                <input type="hidden" name="receiverId" value="${otherUser.id}">
                <input type="hidden" name="receiverType" value="${otherUserType}">
                <textarea name="content" placeholder="输入消息..." required></textarea>
                <button type="submit" class="btn">发送</button>
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
</script>
</body>
</html>
