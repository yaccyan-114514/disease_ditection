<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${treatment.id == null ? '添加' : '编辑'}治疗方案</title>
    <style>
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
        }
        .container {
            max-width: 800px;
            margin: 32px auto;
            padding: 0 16px;
            position: relative;
            z-index: 1;
        }
        .form-panel {
            background: rgba(0,0,0,0.25);
            border-radius: 20px;
            padding: 32px;
            backdrop-filter: blur(6px);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }
        input, textarea, select {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-family: inherit;
            font-size: 14px;
            box-sizing: border-box;
        }
        textarea {
            min-height: 100px;
            resize: vertical;
        }
        input::placeholder, textarea::placeholder {
            color: rgba(255,255,255,0.5);
        }
        option {
            background: #333;
            color: #fff;
        }
        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            background: rgba(255,255,255,0.25);
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn:hover {
            background: rgba(255,255,255,0.35);
        }
        .btn-primary {
            background: rgba(40, 167, 69, 0.6);
        }
        .btn-primary:hover {
            background: rgba(40, 167, 69, 0.8);
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
        <strong>${treatment.id == null ? '添加' : '编辑'}治疗方案</strong>
    </div>
    <div class="actions">
        <c:if test="${not empty currentExpert}">
            <a href="${pageContext.request.contextPath}/expert/knowledge?type=treatment">返回</a>
            <a href="${pageContext.request.contextPath}/expert/profile/edit" style="color: #fff; text-decoration: none; margin-right: 12px;">${currentExpert.name}（${currentExpert.title}）</a>
            <a href="${pageContext.request.contextPath}/farmer/logout">退出</a>
        </c:if>
    </div>
</header>

<div class="container">
    <div class="form-panel">
        <form method="post" action="${pageContext.request.contextPath}/expert/knowledge/treatment/save">
            <input type="hidden" name="id" value="${treatment.id}">
            
            <div class="form-group">
                <label>病害/虫害 *</label>
                <select name="diseaseId" required>
                    <option value="">请选择</option>
                    <c:forEach var="disease" items="${diseases}">
                        <option value="${disease.id}" ${treatment.diseaseId == disease.id ? 'selected' : ''}>${disease.name}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group">
                <label>药物 *</label>
                <select name="pesticideId" required>
                    <option value="">请选择</option>
                    <c:forEach var="pesticide" items="${pesticides}">
                        <option value="${pesticide.id}" ${treatment.pesticideId == pesticide.id ? 'selected' : ''}>${pesticide.name}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group">
                <label>推荐剂量</label>
                <input type="text" name="recommendedDose" value="${treatment.recommendedDose}" placeholder="例如：1:800倍液">
            </div>
            
            <div class="form-group">
                <label>备注</label>
                <textarea name="notes" placeholder="请输入备注信息">${treatment.notes}</textarea>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/expert/knowledge?type=treatment" class="btn">取消</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
