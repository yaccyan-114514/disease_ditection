<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${disease.id == null ? '添加' : '编辑'}病毒种类</title>
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
            max-width: 1000px;
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
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
    </style>
</head>
<body>
<header>
    <div>
        <strong>${disease.id == null ? '添加' : '编辑'}病毒种类</strong>
    </div>
    <div class="actions">
        <c:if test="${not empty currentExpert}">
            <a href="${pageContext.request.contextPath}/expert/knowledge?type=disease">返回</a>
            <a href="${pageContext.request.contextPath}/expert/profile/edit" style="color: #fff; text-decoration: none; margin-right: 12px;">${currentExpert.name}（${currentExpert.title}）</a>
            <a href="${pageContext.request.contextPath}/farmer/logout">退出</a>
        </c:if>
    </div>
</header>

<div class="container">
    <div class="form-panel">
        <form method="post" action="${pageContext.request.contextPath}/expert/knowledge/disease/save">
            <input type="hidden" name="id" value="${disease.id}">
            
            <div class="form-row">
                <div class="form-group">
                    <label>名称 *</label>
                    <input type="text" name="name" value="${disease.name}" required placeholder="请输入名称">
                </div>
                
                <div class="form-group">
                    <label>类型 *</label>
                    <select name="type" required>
                        <option value="disease" ${disease.type == 'disease' ? 'selected' : ''}>病害</option>
                        <option value="pest" ${disease.type == 'pest' ? 'selected' : ''}>虫害</option>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label>寄主作物</label>
                <input type="text" name="hostCrop" value="${disease.hostCrop}" placeholder="请输入寄主作物">
            </div>
            
            <div class="form-group">
                <label>症状描述</label>
                <textarea name="symptoms" placeholder="请输入症状描述">${disease.symptoms}</textarea>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>危害等级</label>
                    <select name="harmLevel">
                        <option value="">请选择</option>
                        <option value="low" ${disease.harmLevel == 'low' ? 'selected' : ''}>低</option>
                        <option value="medium" ${disease.harmLevel == 'medium' ? 'selected' : ''}>中</option>
                        <option value="high" ${disease.harmLevel == 'high' ? 'selected' : ''}>高</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>发生季节</label>
                    <input type="text" name="occurrenceSeason" value="${disease.occurrenceSeason}" placeholder="例如：春季、夏季">
                </div>
            </div>
            
            <div class="form-group">
                <label>气候条件</label>
                <textarea name="climateConditions" placeholder="请输入气候条件">${disease.climateConditions}</textarea>
            </div>
            
            <div class="form-group">
                <label>土壤条件</label>
                <textarea name="soilConditions" placeholder="请输入土壤条件">${disease.soilConditions}</textarea>
            </div>
            
            <div class="form-group">
                <label>风险因素</label>
                <textarea name="riskFactors" placeholder="请输入风险因素">${disease.riskFactors}</textarea>
            </div>
            
            <div class="form-group">
                <label>诊断要点</label>
                <textarea name="diagnosisKeypoints" placeholder="请输入诊断要点">${disease.diagnosisKeypoints}</textarea>
            </div>
            
            <div class="form-group">
                <label>预防方法</label>
                <textarea name="preventionMethods" placeholder="请输入预防方法">${disease.preventionMethods}</textarea>
            </div>
            
            <div class="form-group">
                <label>防治方法</label>
                <textarea name="controlMethods" placeholder="请输入防治方法">${disease.controlMethods}</textarea>
            </div>
            
            <div class="form-group">
                <label>农业防治</label>
                <textarea name="agriculturalControl" placeholder="请输入农业防治方法">${disease.agriculturalControl}</textarea>
            </div>
            
            <div class="form-group">
                <label>生物防治</label>
                <textarea name="biologicalControl" placeholder="请输入生物防治方法">${disease.biologicalControl}</textarea>
            </div>
            
            <div class="form-group">
                <label>区域</label>
                <input type="text" name="region" value="${disease.region}" placeholder="请输入发生区域">
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">保存</button>
                <a href="${pageContext.request.contextPath}/expert/knowledge?type=disease" class="btn">取消</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
