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
            padding: 24px;
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
            margin-bottom: 24px;
            border-radius: 8px;
        }
        .container {
            max-width: 700px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            padding: 32px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            backdrop-filter: blur(5px);
            color: #333;
            position: relative;
            z-index: 1;
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
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
            color: #333;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #1f883d;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
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
        <strong>编辑个人信息</strong>
    </div>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/farmer/home">返回</a>
    </div>
</header>
<div class="container">
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>
    
    <form method="post" action="${pageContext.request.contextPath}/farmer/profile/update">
        <input type="hidden" name="id" value="${farmer.id}">
        
        <div class="form-row">
            <div class="form-group">
                <label>姓名 <span style="color: red;">*</span></label>
                <input type="text" name="name" value="${farmer.name}" required>
            </div>
            
            <div class="form-group">
                <label>性别</label>
                <select name="gender">
                    <option value="">请选择</option>
                    <option value="male" ${farmer.gender == 'male' ? 'selected' : ''}>男</option>
                    <option value="female" ${farmer.gender == 'female' ? 'selected' : ''}>女</option>
                </select>
            </div>
        </div>
        
        <div class="form-group">
            <label>手机号 <span style="color: red;">*</span></label>
            <input type="tel" name="phone" value="${farmer.phone}" required>
        </div>
        
        <div class="form-group">
            <label>身份证号</label>
            <input type="text" name="idCard" value="${farmer.idCard}">
        </div>
        
        <div class="form-group">
            <label>所在地区</label>
            <input type="text" name="region" value="${farmer.region}" placeholder="例如：江苏省南京市">
        </div>
        
        <div class="form-group">
            <label>详细地址</label>
            <input type="text" name="address" value="${farmer.address}">
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label>农场面积（亩）</label>
                <input type="number" name="farmSize" value="${farmer.farmSize}" step="0.01" min="0">
            </div>
            
            <div class="form-group">
                <label>主要作物</label>
                <input type="text" name="mainCrops" value="${farmer.mainCrops}" placeholder="例如：水稻、小麦">
            </div>
        </div>
        
        <div class="form-group">
            <label>新密码</label>
            <input type="password" name="password" placeholder="留空则不修改密码">
            <div class="help-text">如不需要修改密码，请留空</div>
        </div>
        
        <div class="form-actions">
            <button type="submit" class="btn btn-primary">保存</button>
            <a href="${pageContext.request.contextPath}/farmer/home" class="btn btn-secondary">取消</a>
        </div>
    </form>
</div>
</body>
</html>
