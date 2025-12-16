<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑个人信息</title>
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
            padding: 24px;
        }
        .header {
            background: #1f883d;
            color: #fff;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            border-radius: 8px;
        }
        .header h1 {font-size: 20px;}
        .header a {
            color: #fff;
            text-decoration: none;
            padding: 8px 16px;
            background: rgba(255,255,255,0.2);
            border-radius: 6px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            padding: 32px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            backdrop-filter: blur(5px);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #1f883d;
        }
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }
        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #1f883d;
            color: #fff;
        }
        .btn-primary:hover {
            background: #1a6f32;
        }
        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .message {
            background: #d1fae5;
            color: #065f46;
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
        }
        .error {
            background: #fee2e2;
            color: #991b1b;
        }
        .help-text {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>编辑个人信息</h1>
    <a href="${pageContext.request.contextPath}/admin/dashboard">返回</a>
</div>
<div class="container">
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>
    
    <form method="post" action="${pageContext.request.contextPath}/admin/profile/update">
        <input type="hidden" name="id" value="${admin.id}">
        
        <div class="form-group">
            <label>用户名</label>
            <input type="text" value="${admin.username}" disabled>
            <div class="help-text">用户名不可修改</div>
        </div>
        
        <div class="form-group">
            <label>姓名 <span style="color: red;">*</span></label>
            <input type="text" name="name" value="${admin.name}" required>
        </div>
        
        <div class="form-group">
            <label>手机号 <span style="color: red;">*</span></label>
            <input type="tel" name="phone" value="${admin.phone}" required>
        </div>
        
        <div class="form-group">
            <label>邮箱</label>
            <input type="email" name="email" value="${admin.email}">
        </div>
        
        <div class="form-group">
            <label>新密码</label>
            <input type="password" name="password" placeholder="留空则不修改密码">
            <div class="help-text">如不需要修改密码，请留空</div>
        </div>
        
        <div class="form-actions">
            <button type="submit" class="btn btn-primary">保存</button>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">取消</a>
        </div>
    </form>
</div>
</body>
</html>
