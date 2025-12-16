<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>私信列表</title>
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
        .conversation-list {
            background: rgba(0,0,0,0.25);
            border-radius: 16px;
            padding: 24px;
            backdrop-filter: blur(6px);
        }
        .conversation-item {
            background: rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .conversation-item:hover {
            background: rgba(255,255,255,0.15);
        }
        .conversation-item.unread {
            background: rgba(40, 167, 69, 0.2);
            border-left: 3px solid rgba(40, 167, 69, 0.8);
        }
        .conversation-info {
            flex: 1;
        }
        .conversation-name {
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 4px;
        }
        .conversation-preview {
            font-size: 14px;
            opacity: 0.8;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            max-width: 500px;
        }
        .conversation-meta {
            text-align: right;
            margin-left: 16px;
        }
        .conversation-time {
            font-size: 12px;
            opacity: 0.7;
            margin-bottom: 4px;
        }
        .unread-badge {
            display: inline-block;
            background: rgba(220, 53, 69, 0.8);
            color: #fff;
            border-radius: 10px;
            padding: 2px 8px;
            font-size: 12px;
            font-weight: 600;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
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
    </style>
</head>
<body>
<header>
    <div>
        <strong>私信列表</strong>
        <c:if test="${unreadCount > 0}">
            <span class="unread-badge" style="margin-left: 12px;">${unreadCount} 条未读</span>
        </c:if>
    </div>
    <div class="actions">
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
    <div class="conversation-list">
        <c:choose>
            <c:when test="${not empty conversations && fn:length(conversations) > 0}">
                <c:forEach var="conv" items="${conversations}">
                    <c:set var="otherUser" value="${conv.senderId == (currentFarmer != null ? currentFarmer.id : currentExpert.id) ? (conv.receiverType == 'farmer' ? conv.receiverFarmer : conv.receiverExpert) : (conv.senderType == 'farmer' ? conv.senderFarmer : conv.senderExpert)}"/>
                    <c:set var="otherUserId" value="${conv.senderId == (currentFarmer != null ? currentFarmer.id : currentExpert.id) ? conv.receiverId : conv.senderId}"/>
                    <c:set var="otherUserType" value="${conv.senderId == (currentFarmer != null ? currentFarmer.id : currentExpert.id) ? conv.receiverType : conv.senderType}"/>
                    <c:set var="isUnread" value="${conv.isRead == false && conv.receiverId == (currentFarmer != null ? currentFarmer.id : currentExpert.id)}"/>
                    
                    <a href="${pageContext.request.contextPath}/private-message/chat?otherUserId=${otherUserId}&otherUserType=${otherUserType}" 
                       style="text-decoration: none; color: inherit;">
                        <div class="conversation-item ${isUnread ? 'unread' : ''}">
                            <div class="conversation-info">
                                <div class="conversation-name">
                                    <c:choose>
                                        <c:when test="${otherUserType == 'farmer'}">
                                            ${otherUser.name}
                                        </c:when>
                                        <c:otherwise>
                                            ${otherUser.name}（${otherUser.title}）
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="conversation-preview">${conv.content}</div>
                            </div>
                            <div class="conversation-meta">
                                <div class="conversation-time">
                                    ${fn:replace(fn:substring(conv.createdAt.toString(), 0, 16), 'T', ' ')}
                                </div>
                                <c:if test="${isUnread}">
                                    <span class="unread-badge">未读</span>
                                </c:if>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>暂无私信</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
