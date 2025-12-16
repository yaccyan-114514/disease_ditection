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
            max-width: 800px;
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
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
            color: #333;
            font-family: inherit;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #1f883d;
        }
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
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
        <a href="${pageContext.request.contextPath}/expert">返回</a>
    </div>
</header>
<div class="container">
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>
    
    <form method="post" action="${pageContext.request.contextPath}/expert/profile/update">
        <input type="hidden" name="id" value="${expert.id}">
        
        <div class="form-row">
            <div class="form-group">
                <label>姓名 <span style="color: red;">*</span></label>
                <input type="text" name="name" value="${expert.name}" required>
            </div>
            
            <div class="form-group">
                <label>性别</label>
                <select name="gender">
                    <option value="">请选择</option>
                    <option value="male" ${expert.gender == 'male' ? 'selected' : ''}>男</option>
                    <option value="female" ${expert.gender == 'female' ? 'selected' : ''}>女</option>
                </select>
            </div>
        </div>
        
        <div class="form-group">
            <label>手机号 <span style="color: red;">*</span></label>
            <input type="tel" name="phone" value="${expert.phone}" required>
        </div>
        
        <div class="form-group">
            <label>邮箱</label>
            <input type="email" name="email" value="${expert.email}">
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label>所属机构</label>
                <input type="text" name="organization" value="${expert.organization}">
            </div>
            
            <div class="form-group">
                <label>职称</label>
                <input type="text" name="title" value="${expert.title}">
            </div>
        </div>
        
        <div class="form-group">
            <label>专业领域</label>
            <input type="text" name="specialty" value="${expert.specialty}" placeholder="例如：水稻病虫害防治、植物病理学">
        </div>
        
        <div class="form-group">
            <label>个人简介</label>
            <textarea name="bio" placeholder="请输入您的个人简介">${expert.bio}</textarea>
        </div>
        
        <div class="form-group">
            <label>新密码</label>
            <input type="password" name="password" placeholder="留空则不修改密码">
            <div class="help-text">如不需要修改密码，请留空</div>
        </div>
        
        <div class="form-actions">
            <button type="submit" class="btn btn-primary">保存</button>
            <a href="${pageContext.request.contextPath}/expert" class="btn btn-secondary">取消</a>
        </div>
    </form>
</div>
</body>
</html>
