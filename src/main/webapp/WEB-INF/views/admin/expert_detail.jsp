<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>专家详情</title>
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
        .field .value {color: #666;}
        .actions {margin-top: 24px;}
        .btn {padding: 8px 16px; border-radius: 4px; text-decoration: none; font-size: 14px; display: inline-block; margin-right: 8px;}
        .btn-edit {background: #1f883d; color: #fff;}
        .btn-back {background: #6b7280; color: #fff;}
    </style>
</head>
<body>
<div class="header">
    <h1>专家详情</h1>
    <a href="${pageContext.request.contextPath}/admin/experts">返回列表</a>
</div>
<div class="container">
    <div class="card">
        <div class="field">
            <label>ID</label>
            <div class="value">${expert.id}</div>
        </div>
        <div class="field">
            <label>姓名</label>
            <div class="value">${expert.name}</div>
        </div>
        <div class="field">
            <label>性别</label>
            <div class="value">${expert.gender == 'male' ? '男' : '女'}</div>
        </div>
        <div class="field">
            <label>手机号</label>
            <div class="value">${expert.phone}</div>
        </div>
        <div class="field">
            <label>邮箱</label>
            <div class="value">${expert.email}</div>
        </div>
        <div class="field">
            <label>机构</label>
            <div class="value">${expert.organization}</div>
        </div>
        <div class="field">
            <label>职称</label>
            <div class="value">${expert.title}</div>
        </div>
        <div class="field">
            <label>专业领域</label>
            <div class="value">${expert.specialty}</div>
        </div>
        <div class="field">
            <label>简介</label>
            <div class="value">${expert.bio}</div>
        </div>
        <div class="field">
            <label>状态</label>
            <div class="value">${expert.status == 'active' ? '正常' : '禁用'}</div>
        </div>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/admin/experts/${expert.id}/edit" class="btn btn-edit">编辑</a>
            <a href="${pageContext.request.contextPath}/admin/experts" class="btn btn-back">返回列表</a>
        </div>
    </div>
</div>
</body>
</html>
