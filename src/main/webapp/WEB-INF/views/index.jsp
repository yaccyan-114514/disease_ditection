<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>农作物病虫害智能诊断平台</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0;
            min-height: 100vh;
            color: #fff;
        }
        header {
            background: #1f883d;
            color: #fff;
            padding: 16px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            backdrop-filter: blur(6px);
            background: rgba(0,0,0,0.35);
        }
        .container {
            max-width: 1080px;
            margin: 32px auto;
            padding: 0 16px;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            justify-items: center;
        }
        .card {
            background: rgba(255,255,255,0.12);
            border-radius: 14px;
            padding: 16px;
            box-shadow: 0 25px 45px rgba(0,0,0,.25);
            border: 1px solid rgba(255,255,255,0.15);
            color: #f8fafc;
            width: 85%;
            max-width: 240px;
            text-align: left;
        }
        .nav-link {
            display: inline-block;
            margin-top: 16px;
            color: #fff;
            font-weight: 600;
            text-decoration: none;
            border-bottom: 1px solid rgba(255,255,255,0.4);
        }
        .message {
            margin-bottom: 24px;
            padding: 12px 16px;
            border-radius: 12px;
            background: rgba(255,255,255,0.18);
            border: 1px solid rgba(255,255,255,0.25);
            color: #f5f7fb;
        }
        .actions a {
            color: #fff;
            background: rgba(255,255,255,0.25);
            padding: 6px 14px;
            border-radius: 20px;
            text-decoration: none;
            margin-left: 12px;
        }
        .weather-banner {
            background: rgba(0,0,0,0.25);
            border-radius: 20px;
            padding: 24px;
            margin-top: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,0.08);
        }
        .weather-main {
            font-size: 48px;
            font-weight: 600;
            line-height: 1;
        }
        .weather-sub {
            margin-left: 18px;
        }
        .weather-context {
            text-align: right;
            font-size: 14px;
            opacity: .85;
        }
        .weather-panel, .forecast-panel {
            margin-top: 24px;
            padding: 24px;
            border-radius: 20px;
            background: rgba(0,0,0,0.25);
            border: 1px solid rgba(255,255,255,0.12);
            box-shadow: inset 0 0 0 1px rgba(255,255,255,0.06);
        }
        .weather-panel strong, .forecast-panel strong {
            font-size: 20px;
        }
        .weather-panel ul {
            list-style: none;
            padding: 0;
            margin: 18px 0 0;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }
        .weather-panel li {
            background: rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 12px 16px;
        }
        .forecast-list {
            margin-top: 18px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 16px;
        }
        .forecast-item {
            background: rgba(255,255,255,0.08);
            border-radius: 16px;
            padding: 16px;
            line-height: 1.6;
        }
        .card-icon {
            width: 36px;
            height: 36px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body class="dynamic-bg" data-bg="${empty weather ? 'linear-gradient(120deg,#0f172a,#1e293b)' : weather.backgroundStyle}">
<header>
    <div>
        <strong>AI 农业助手</strong>
        <small style="margin-left:8px;">${message}</small>
    </div>
    <div class="actions">
        <c:choose>
            <c:when test="${not empty currentFarmer}">
                <span>${currentFarmer.name}（${currentFarmer.phone}）</span>
                <a href="${pageContext.request.contextPath}/farmer/logout">退出</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/farmer/login">登录</a>
                <a href="${pageContext.request.contextPath}/farmer/register">注册</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<div class="container">
    <div class="message">
        平台提供登录注册、拍照识别、专家问答与农业社区模块，帮助农户快速诊断病虫害并获得农艺指导。
    </div>
    <c:if test="${not empty weather}">
        <div class="weather-banner">
            <div style="display:flex;align-items:center;">
                <div class="weather-main">${weather.temperature}℃</div>
                <div class="weather-sub">
                    <div>${weather.description}</div>
                    <div style="font-size:14px;opacity:.85;">
                        ${weather.province} · ${weather.city}
                    </div>
                </div>
            </div>
            <div class="weather-context">
                风速 ${weather.windspeed} m/s ｜ 风力 ${weather.windpower}<br/>
                湿度 ${weather.humidity}% ｜ ${weather.reportTime}
            </div>
        </div>
        <div class="weather-panel">
            <strong>实时天气</strong>
            <ul>
                <li>省市：${weather.province} · ${weather.city}</li>
                <li>区域编码：${weather.adcode}</li>
                <li>风向：${weather.windDirection}</li>
                <li>风力：${weather.windpower}</li>
                <li>湿度：${weather.humidity}%</li>
                <li>更新时间：${weather.reportTime}</li>
            </ul>
        </div>
        <c:if test="${not empty weather.forecasts}">
            <div class="forecast-panel">
                <strong>未来天气预报</strong>
                <div class="forecast-list">
                    <c:forEach items="${weather.forecasts}" var="forecast">
                        <div class="forecast-item">
                            <div>${forecast.date} · 周${forecast.week}</div>
                            <div>白天：${forecast.dayWeather}，${forecast.dayTemp}℃，${forecast.dayWind} ${forecast.dayPower}</div>
                            <div>夜间：${forecast.nightWeather}，${forecast.nightTemp}℃，${forecast.nightWind} ${forecast.nightPower}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </c:if>
    <div class="grid">
        <div class="card">
            <img class="card-icon" src="${pageContext.request.contextPath}/assets/camera.png" alt="拍照识别">
            <h3>拍照识别</h3>
            <a class="nav-link" href="${pageContext.request.contextPath}/ai">进入 &rarr;</a>
        </div>
        <div class="card">
            <img class="card-icon" src="${pageContext.request.contextPath}/assets/expert.png" alt="专家问答">
            <h3>专家问答</h3>
            <a class="nav-link" href="${pageContext.request.contextPath}/expert/qa">进入 &rarr;</a>
        </div>
        <div class="card">
            <img class="card-icon" src="${pageContext.request.contextPath}/assets/chat.png" alt="农业社区">
            <h3>农业社区</h3>
            <a class="nav-link" href="${pageContext.request.contextPath}/community">进入 &rarr;</a>
        </div>
    </div>
</div>
</body>
<script>
    (function () {
        var bg = document.body.getAttribute('data-bg');
        if (bg) {
            document.body.style.background = bg;
        }
    })();
</script>
</html>

