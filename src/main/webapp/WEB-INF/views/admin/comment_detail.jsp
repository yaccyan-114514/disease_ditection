<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>评论详情</title>
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
        .field .value {color: #666; line-height: 1.6;}
        .actions {margin-top: 24px;}
        .btn {padding: 8px 16px; border-radius: 4px; text-decoration: none; font-size: 14px; display: inline-block; margin-right: 8px; border: none; cursor: pointer;}
        .btn-delete {background: #d1242f; color: #fff;}
        .btn-back {background: #6b7280; color: #fff;}
    </style>
</head>
<body>
<div class="header">
    <h1>评论详情</h1>
    <a href="${pageContext.request.contextPath}/admin/comments">返回列表</a>
</div>
<div class="container">
    <div class="card">
        <div class="field">
            <label>ID</label>
            <div class="value">${comment.id}</div>
        </div>
        <div class="field">
            <label>内容</label>
            <div class="value">${comment.content}</div>
        </div>
        <div class="field">
            <label>作者</label>
            <div class="value">${comment.author.name} (${comment.author.phone})</div>
        </div>
        <div class="field">
            <label>投稿ID</label>
            <div class="value">${comment.postId}</div>
        </div>
        <div class="field">
            <label>发布时间</label>
            <div class="value">${comment.createdAt}</div>
        </div>
        <div class="actions">
            <form method="post" action="${pageContext.request.contextPath}/admin/comments/${comment.id}/delete" style="display: inline;" onsubmit="return confirm('确定要删除这个评论吗？');">
                <button type="submit" class="btn btn-delete">删除</button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/comments" class="btn btn-back">返回列表</a>
        </div>
    </div>
</div>
</body>
</html>
