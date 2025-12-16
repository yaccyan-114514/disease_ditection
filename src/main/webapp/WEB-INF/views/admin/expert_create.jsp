<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>新建专家</title>
    <style>
        * {margin: 0; padding: 0; box-sizing: border-box;}
        body {font-family: "PingFang SC", sans-serif; background: #f6f8fa;}
        .header {background: #1f883d; color: #fff; padding: 16px 24px; display: flex; justify-content: space-between; align-items: center;}
        .header h1 {font-size: 20px;}
        .header a {color: #fff; text-decoration: none; padding: 8px 16px; background: rgba(255,255,255,0.2); border-radius: 6px;}
        .container {max-width: 800px; margin: 24px auto; padding: 0 24px;}
        .card {background: #fff; padding: 24px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);}
        .field {margin-bottom: 16px;}
        .field label {display: block; font-weight: 600; margin-bottom: 4px; color: #333;}
        .field input, .field select, .field textarea {width: 100%; padding: 8px 12px; border: 1px solid #d0d7de; border-radius: 6px; font-size: 14px; font-family: inherit;}
        .field textarea {min-height: 100px; resize: vertical;}
        .actions {margin-top: 24px;}
        .btn {padding: 8px 16px; border-radius: 4px; text-decoration: none; font-size: 14px; display: inline-block; margin-right: 8px; border: none; cursor: pointer;}
        .btn-submit {background: #1f883d; color: #fff;}
        .btn-cancel {background: #6b7280; color: #fff;}
    </style>
</head>
<body>
<div class="header">
    <h1>新建专家</h1>
    <a href="${pageContext.request.contextPath}/admin/experts">返回列表</a>
</div>
<div class="container">
    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/admin/experts/new">
            <div class="field">
                <label>姓名 *</label>
                <input type="text" name="name" required>
            </div>
            <div class="field">
                <label>性别</label>
                <select name="gender">
                    <option value="male">男</option>
                    <option value="female">女</option>
                </select>
            </div>
            <div class="field">
                <label>手机号 *</label>
                <input type="text" name="phone" required>
            </div>
            <div class="field">
                <label>邮箱</label>
                <input type="email" name="email">
            </div>
            <div class="field">
                <label>密码 *</label>
                <input type="text" name="password" required>
            </div>
            <div class="field">
                <label>机构</label>
                <input type="text" name="organization">
            </div>
            <div class="field">
                <label>职称</label>
                <input type="text" name="title">
            </div>
            <div class="field">
                <label>专业领域</label>
                <input type="text" name="specialty">
            </div>
            <div class="field">
                <label>简介</label>
                <textarea name="bio"></textarea>
            </div>
            <div class="field">
                <label>状态</label>
                <select name="status">
                    <option value="active" selected>正常</option>
                    <option value="disabled">禁用</option>
                </select>
            </div>
            <div class="actions">
                <button type="submit" class="btn btn-submit">创建</button>
                <a href="${pageContext.request.contextPath}/admin/experts" class="btn btn-cancel">取消</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
