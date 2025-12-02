<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>农户注册</title>
    <style>
        body {font-family: "PingFang SC", sans-serif; background: #f6f8fa; margin: 0;}
        .panel {max-width: 520px; margin: 40px auto; background: #fff; padding: 32px; border-radius: 12px; box-shadow:0 15px 35px rgba(15,23,42,.12);}
        .panel h2 {margin-top:0;}
        label {display:block; margin:12px 0 6px;}
        input {width:100%; padding:10px 12px; border-radius:8px; border:1px solid #d0d7de;}
        .row {display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;}
        .btn {margin-top:20px; width:100%; background:#1f883d; border:none; color:#fff; padding:12px 0; border-radius:8px; font-size:16px;}
        .error {background:#fdecea; color:#b42318; padding:10px 12px; border-radius:8px; margin-bottom:12px;}
        .link {margin-top:12px; text-align:center;}
        a {color:#1f883d; text-decoration:none;}
    </style>
</head>
<body>
<div class="panel">
    <h2>农户注册</h2>
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/farmer/register">
        <div class="row">
            <div>
                <label>姓名</label>
                <input type="text" name="name" required>
            </div>
            <div>
                <label>性别</label>
                <input type="text" name="gender" placeholder="male/female">
            </div>
        </div>
        <label>手机号</label>
        <input type="text" name="phone" required>
        <label>身份证号</label>
        <input type="text" name="idCard">
        <label>密码</label>
        <input type="password" name="password" required>
        <label>所在地区</label>
        <input type="text" name="region">
        <label>详细地址</label>
        <input type="text" name="address">
        <label>主要种植作物</label>
        <input type="text" name="mainCrops">
        <label>农场面积 (亩)</label>
        <input type="number" step="0.01" name="farmSize">
        <button type="submit" class="btn">提交注册</button>
    </form>
    <div class="link">
        已有账号？<a href="${pageContext.request.contextPath}/farmer/login">去登录</a>
    </div>
</div>
</body>
</html>

