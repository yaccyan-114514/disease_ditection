<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>社区投稿管理</title>
    <style>
        * {margin: 0; padding: 0; box-sizing: border-box;}
        body {font-family: "PingFang SC", sans-serif; background: #f6f8fa;}
        .header {background: #1f883d; color: #fff; padding: 16px 24px; display: flex; justify-content: space-between; align-items: center;}
        .header h1 {font-size: 20px;}
        .header a {color: #fff; text-decoration: none; padding: 8px 16px; background: rgba(255,255,255,0.2); border-radius: 6px;}
        .container {max-width: 1200px; margin: 24px auto; padding: 0 24px;}
        table {width: 100%; background: #fff; border-collapse: collapse; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1);}
        th {background: #f6f8fa; padding: 12px; text-align: left; font-weight: 600; border-bottom: 2px solid #e1e4e8;}
        td {padding: 12px; border-bottom: 1px solid #e1e4e8;}
        tr:hover {background: #f6f8fa;}
        .btn {padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 14px; display: inline-block; margin-right: 8px; border: none; cursor: pointer;}
        .btn-view {background: #1f883d; color: #fff;}
        .btn-delete {background: #d1242f; color: #fff;}
        .btn-delete:hover {background: #b91c28;}
        .message {background: #d1fae5; color: #065f46; padding: 12px 16px; border-radius: 6px; margin-bottom: 16px;}
        .content-preview {max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;}
    </style>
</head>
<body>
<div class="header">
    <h1>社区投稿管理</h1>
    <a href="${pageContext.request.contextPath}/admin/dashboard">返回首页</a>
</div>
<div class="container">
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>标题</th>
            <th>内容预览</th>
            <th>作者</th>
            <th>发布时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="post" items="${posts}">
            <tr>
                <td>${post.id}</td>
                <td>${post.title}</td>
                <td class="content-preview">${post.content}</td>
                <td>${post.author.name}</td>
                <td>${post.createdAt}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/posts/${post.id}" class="btn btn-view">查看</a>
                    <form method="post" action="${pageContext.request.contextPath}/admin/posts/${post.id}/delete" style="display: inline;" onsubmit="return confirm('确定要删除这个投稿吗？');">
                        <button type="submit" class="btn btn-delete">删除</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
