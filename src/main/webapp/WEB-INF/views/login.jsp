<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户登录</title>
    <style>
        body {font-family: "PingFang SC", sans-serif; background: #f6f8fa; margin: 0;}
        .panel {max-width: 420px; margin: 80px auto; background: #fff; padding: 32px; border-radius: 12px; box-shadow:0 15px 35px rgba(15,23,42,.12);}
        .panel h2 {margin-top:0;}
        label {display:block; margin:12px 0 6px;}
        input {width:100%; padding:10px 12px; border-radius:8px; border:1px solid #d0d7de;}
        .btn {margin-top:20px; width:100%; background:#1f883d; border:none; color:#fff; padding:12px 0; border-radius:8px; font-size:16px;}
        .error {background:#fdecea; color:#b42318; padding:10px 12px; border-radius:8px; margin-bottom:12px;}
        .link {margin-top:12px; text-align:center;}
        a {color:#1f883d; text-decoration:none;}
    </style>
</head>
<body>
<div class="panel">
    <h2>用户登录</h2>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/login">
        <label>手机号/用户名</label>
        <input type="text" name="phone" placeholder="请输入手机号或用户名（管理员）" required>
        <label>密码</label>
        <input type="password" name="password" placeholder="请输入密码" required>
        <button type="submit" class="btn">登录</button>
    </form>
    <div class="link">
        还没有账号？<a href="${pageContext.request.contextPath}/farmer/register">立即注册</a>
    </div>
</div>
</body>
</html>

