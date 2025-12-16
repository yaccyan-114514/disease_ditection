<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>农产品知识库</title>
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
            display: flex;
            height: calc(100vh - 80px);
            position: relative;
            z-index: 1;
        }
        .sidebar {
            width: 200px;
            background: rgba(0,0,0,0.25);
            border-right: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(6px);
            padding: 20px 0;
        }
        .sidebar-item {
            padding: 12px 24px;
            cursor: pointer;
            transition: background 0.2s;
            color: #fff;
            text-decoration: none;
            display: block;
        }
        .sidebar-item:hover {
            background: rgba(255,255,255,0.1);
        }
        .sidebar-item.active {
            background: rgba(255,255,255,0.2);
            font-weight: 600;
        }
        .content {
            flex: 1;
            padding: 24px;
            overflow-y: auto;
            background: rgba(0,0,0,0.15);
        }
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .btn {
            padding: 8px 16px;
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
        .btn-danger {
            background: rgba(220, 53, 69, 0.6);
        }
        .btn-danger:hover {
            background: rgba(220, 53, 69, 0.8);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255,255,255,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        th {
            background: rgba(0,0,0,0.3);
            font-weight: 600;
        }
        tr:hover {
            background: rgba(255,255,255,0.05);
        }
        .message {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            background: rgba(40, 167, 69, 0.3);
            border: 1px solid rgba(40, 167, 69, 0.5);
        }
        .actions a {
            color: #fff;
            background: rgba(255,255,255,0.25);
            padding: 6px 14px;
            border-radius: 20px;
            text-decoration: none;
            margin-left: 12px;
        }
        .text-truncate {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<header>
    <div>
        <strong>农产品知识库</strong>
    </div>
    <div class="actions">
        <c:if test="${not empty currentExpert}">
            <a href="${pageContext.request.contextPath}/expert" style="color: #fff; text-decoration: none; margin-right: 12px;">返回工作台</a>
            <a href="${pageContext.request.contextPath}/expert/profile/edit" style="color: #fff; text-decoration: none; margin-right: 12px;">${currentExpert.name}（${currentExpert.title}）</a>
            <a href="${pageContext.request.contextPath}/farmer/logout">退出</a>
        </c:if>
    </div>
</header>

<div class="container">
    <!-- 左侧分类 -->
    <div class="sidebar">
        <a href="${pageContext.request.contextPath}/expert/knowledge?type=crop" 
           class="sidebar-item ${currentType == 'crop' ? 'active' : ''}">农作物</a>
        <a href="${pageContext.request.contextPath}/expert/knowledge?type=disease" 
           class="sidebar-item ${currentType == 'disease' ? 'active' : ''}">病毒种类</a>
        <a href="${pageContext.request.contextPath}/expert/knowledge?type=pesticide" 
           class="sidebar-item ${currentType == 'pesticide' ? 'active' : ''}">药物</a>
        <a href="${pageContext.request.contextPath}/expert/knowledge?type=treatment" 
           class="sidebar-item ${currentType == 'treatment' ? 'active' : ''}">作物治疗方案</a>
    </div>

    <!-- 右侧工作台 -->
    <div class="content">
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>

        <div class="content-header">
            <h2>
                <c:choose>
                    <c:when test="${currentType == 'crop'}">农作物管理</c:when>
                    <c:when test="${currentType == 'disease'}">病毒种类管理</c:when>
                    <c:when test="${currentType == 'pesticide'}">药物管理</c:when>
                    <c:when test="${currentType == 'treatment'}">作物治疗方案管理</c:when>
                </c:choose>
            </h2>
            <a href="${pageContext.request.contextPath}/expert/knowledge/${currentType}/add" class="btn btn-primary">添加</a>
        </div>

        <c:choose>
            <c:when test="${currentType == 'crop'}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>作物名称</th>
                            <th>种植季节</th>
                            <th>适应区域</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td>${item.id}</td>
                                <td>${item.cropName}</td>
                                <td>${item.plantingSeason}</td>
                                <td>${item.regionAdapt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/expert/knowledge/crop/edit/${item.id}" class="btn">编辑</a>
                                    <form method="post" action="${pageContext.request.contextPath}/expert/knowledge/crop/delete/${item.id}" style="display: inline;" onsubmit="return confirm('确定要删除吗？');">
                                        <button type="submit" class="btn btn-danger">删除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:when test="${currentType == 'disease'}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>名称</th>
                            <th>类型</th>
                            <th>寄主作物</th>
                            <th>危害等级</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td>${item.id}</td>
                                <td>${item.name}</td>
                                <td>${item.type == 'disease' ? '病害' : '虫害'}</td>
                                <td>${item.hostCrop}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.harmLevel == 'low'}">低</c:when>
                                        <c:when test="${item.harmLevel == 'medium'}">中</c:when>
                                        <c:when test="${item.harmLevel == 'high'}">高</c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/expert/knowledge/disease/edit/${item.id}" class="btn">编辑</a>
                                    <form method="post" action="${pageContext.request.contextPath}/expert/knowledge/disease/delete/${item.id}" style="display: inline;" onsubmit="return confirm('确定要删除吗？');">
                                        <button type="submit" class="btn btn-danger">删除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:when test="${currentType == 'pesticide'}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>名称</th>
                            <th>成分</th>
                            <th>毒性等级</th>
                            <th>安全间隔期</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td>${item.id}</td>
                                <td>${item.name}</td>
                                <td class="text-truncate">${item.composition}</td>
                                <td>${item.toxicityLevel}</td>
                                <td>${item.safeInterval}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/expert/knowledge/pesticide/edit/${item.id}" class="btn">编辑</a>
                                    <form method="post" action="${pageContext.request.contextPath}/expert/knowledge/pesticide/delete/${item.id}" style="display: inline;" onsubmit="return confirm('确定要删除吗？');">
                                        <button type="submit" class="btn btn-danger">删除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:when test="${currentType == 'treatment'}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>病害/虫害</th>
                            <th>药物</th>
                            <th>推荐剂量</th>
                            <th>备注</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${items}">
                            <tr>
                                <td>${item.id}</td>
                                <td>${item.disease != null ? item.disease.name : '未知'}</td>
                                <td>${item.pesticide != null ? item.pesticide.name : '未知'}</td>
                                <td>${item.recommendedDose}</td>
                                <td class="text-truncate">${item.notes}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/expert/knowledge/treatment/edit/${item.id}" class="btn">编辑</a>
                                    <form method="post" action="${pageContext.request.contextPath}/expert/knowledge/treatment/delete/${item.id}" style="display: inline;" onsubmit="return confirm('确定要删除吗？');">
                                        <button type="submit" class="btn btn-danger">删除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
        </c:choose>
    </div>
</div>
</body>
</html>
