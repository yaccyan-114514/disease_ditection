<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理员登录</title>
    <style>
        body {font-family: "PingFang SC", sans-serif; background: #f6f8fa; margin: 0;}
        .panel {max-width: 420px; margin: 80px auto; background: #fff; padding: 32px; border-radius: 12px; box-shadow:0 15px 35px rgba(15,23,42,.12);}
        .panel h2 {margin-top:0; color: #1f883d;}
        label {display:block; margin:12px 0 6px;}
        input {width:100%; padding:10px 12px; border-radius:8px; border:1px solid #d0d7de; box-sizing: border-box;}
        .btn {margin-top:20px; width:100%; background:#1f883d; border:none; color:#fff; padding:12px 0; border-radius:8px; font-size:16px; cursor: pointer;}
        .btn:hover {background:#1a7f37;}
        .error {background:#fdecea; color:#b42318; padding:10px 12px; border-radius:8px; margin-bottom:12px;}
    </style>
</head>
<body>
<div class="panel">
    <h2>管理员登录</h2>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/admin/login">
        <label>用户名</label>
        <input type="text" name="username" placeholder="请输入用户名" required>
        <label>密码</label>
        <input type="password" name="password" placeholder="请输入密码" required>
        <button type="submit" class="btn">登录</button>
    </form>
</div>
</body>
</html>
