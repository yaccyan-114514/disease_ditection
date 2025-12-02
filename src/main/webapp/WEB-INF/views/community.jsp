<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>农业社区</title>
    <style>
        body {font-family:"PingFang SC",sans-serif;background:#f6f8fa;margin:0;}
        .container {max-width:1000px;margin:32px auto;padding:0 16px;}
        .post {background:#fff;border-radius:16px;padding:20px 24px;margin-bottom:20px;box-shadow:0 20px 45px rgba(15,23,42,.08);}
        .post h3 {margin:0;}
        .meta {color:#6b7280;font-size:14px;margin-bottom:12px;}
        .comments {margin-top:16px;border-top:1px solid #e5e7eb;padding-top:12px;}
        .comment {background:#f4f6fb;border-radius:12px;padding:12px 14px;margin-bottom:10px;}
    </style>
</head>
<body>
<div class="container">
    <h2>农业社区动态</h2>
    <c:forEach items="${posts}" var="post">
        <div class="post">
            <h3>${post.title}</h3>
            <div class="meta">
                作者：<c:out value="${post.author.name}"/> ｜ 发布时间：${post.createdAt}
            </div>
            <p>${post.content}</p>
            <c:if test="${not empty post.comments}">
                <div class="comments">
                    <strong>评论</strong>
                    <c:forEach items="${post.comments}" var="comment">
                        <div class="comment">
                            <div class="meta">
                                ${comment.author.name} ｜ ${comment.createdAt}
                            </div>
                            <p>${comment.content}</p>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </c:forEach>
</div>
</body>
</html>

