<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>专家问答</title>
    <style>
        body {font-family:"PingFang SC",sans-serif;background:#f6f8fa;margin:0;}
        .layout {display:grid;grid-template-columns: 1fr 1.2fr;gap:24px;max-width:1200px;margin:32px auto;padding:0 16px;}
        .panel {background:#fff;border-radius:16px;box-shadow:0 16px 40px rgba(15,23,42,.08);padding:24px;}
        textarea {width:100%;border-radius:12px;border:1px solid #d0d7de;padding:12px;min-height:140px;}
        button {margin-top:12px;background:#1f883d;color:#fff;border:none;padding:12px 28px;border-radius:8px;font-size:16px;}
        .question {border-bottom:1px solid #e6e9ed;padding:16px 0;}
        .question:last-child {border-bottom:none;}
        .answer {background:#f4f8ff;border-radius:10px;padding:10px 14px;margin-top:10px;}
        .error {background:#fdecea;color:#b42318;padding:12px;border-radius:10px;margin-bottom:16px;}
        .message {background:#e9f5ee;color:#1f5c2f;padding:12px;border-radius:10px;margin-bottom:16px;}
    </style>
</head>
<body>
<div class="layout">
    <div class="panel">
        <h2>提交新的问题</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/expert/question">
            <label>作物 ID（可选）</label>
            <input type="number" name="cropId" style="width:100%;border-radius:10px;border:1px solid #d0d7de;padding:10px;">
            <label style="margin-top:12px;">问题描述</label>
            <textarea name="questionText" placeholder="描述病虫害症状、田间环境等信息" required></textarea>
            <button type="submit">提交并匹配专家</button>
        </form>
    </div>
    <div class="panel">
        <h2>最新答复</h2>
        <c:forEach items="${questions}" var="question">
            <div class="question">
                <strong>农户 #${question.userId}</strong>
                <p>${question.questionText}</p>
                <c:forEach items="${question.answers}" var="answer">
                    <div class="answer">
                        <strong>${answer.expert.name}</strong>
                        <span style="color:#4b5563;">（${answer.expert.title}｜${answer.expert.specialty}）</span>
                        <p>${answer.answerText}</p>
                    </div>
                </c:forEach>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>

