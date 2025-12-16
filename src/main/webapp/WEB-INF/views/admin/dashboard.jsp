<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理员后台</title>
    <style>
        * {margin: 0; padding: 0; box-sizing: border-box;}
        body {
            font-family: "PingFang SC", sans-serif;
            background: #f6f8fa;
            background-image: url('${pageContext.request.contextPath}/assets/backgroud.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
        }
        .header {background: #1f883d; color: #fff; padding: 16px 24px; display: flex; justify-content: space-between; align-items: center;}
        .header h1 {font-size: 20px;}
        .header a {color: #fff; text-decoration: none; padding: 8px 16px; background: rgba(255,255,255,0.2); border-radius: 6px;}
        .container {max-width: 1200px; margin: 24px auto; padding: 0 24px;}
        .menu {display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-top: 24px;}
        .menu-item {
            background: rgba(255, 255, 255, 0.95);
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-decoration: none;
            color: #333;
            display: block;
            backdrop-filter: blur(5px);
        }
        .menu-item:hover {box-shadow: 0 4px 12px rgba(0,0,0,0.15); transform: translateY(-2px); transition: all 0.3s ease;}
        .menu-item h3 {color: #1f883d; margin-bottom: 8px;}
        .menu-item p {color: #666; font-size: 14px;}
        .message {background: #d1fae5; color: #065f46; padding: 12px 16px; border-radius: 6px; margin-bottom: 16px;}
    </style>
</head>
<body>
<div class="header">
    <h1>管理员后台 - ${admin.name}</h1>
    <div style="display: flex; gap: 12px; align-items: center;">
        <a href="${pageContext.request.contextPath}/admin/profile/edit" style="color: #fff; text-decoration: none; padding: 8px 16px; background: rgba(255,255,255,0.2); border-radius: 6px;">编辑个人信息</a>
        <a href="${pageContext.request.contextPath}/admin/logout">退出登录</a>
    </div>
</div>
<div class="container">
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>
    <h2>功能菜单</h2>
    <div class="menu">
        <a href="${pageContext.request.contextPath}/admin/farmers" class="menu-item">
            <h3>农户管理</h3>
            <p>查看、编辑、删除农户账号信息</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/experts" class="menu-item">
            <h3>专家管理</h3>
            <p>查看、创建、编辑、删除专家账号信息</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/posts" class="menu-item">
            <h3>社区投稿管理</h3>
            <p>查看、删除农户社区的投稿</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/comments" class="menu-item">
            <h3>评论管理</h3>
            <p>查看、删除社区评论</p>
        </a>
    </div>
</div>
</body>
</html>
