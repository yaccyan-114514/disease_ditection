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
            max-width: 1080px;
            margin: 32px auto;
            padding: 0 16px;
            position: relative;
            z-index: 1;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            justify-items: center;
            margin-top: 60px;
        }
        .card {
            background: #ffffff;
            border-radius: 14px;
            padding: 16px;
            box-shadow: 0 25px 45px rgba(0,0,0,.25);
            border: 1px solid rgba(255,255,255,0.15);
            color: #333333;
            width: 85%;
            max-width: 240px;
            text-align: left;
        }
        .nav-link {
            display: inline-block;
            margin-top: 16px;
            color: #333333;
            font-weight: 600;
            text-decoration: none;
            border-bottom: 1px solid rgba(0,0,0,0.4);
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
        .weather-sub-location {
            display: flex;
            align-items: center;
            justify-content: flex-start;
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
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }
        .weather-panel li {
            background: #ffffff;
            border-radius: 12px;
            padding: 12px 16px;
            color: #333333;
            display: flex;
            align-items: center;
        }
        .forecast-list {
            margin-top: 18px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }
        .forecast-item {
            background: rgba(255,255,255,0.08);
            border-radius: 16px;
            padding: 16px;
            line-height: 1.6;
            min-width: 280px;
        }
        .forecast-item > div:not(:first-child) {
            display: flex;
            align-items: center;
            flex-wrap: nowrap;
            margin-top: 8px;
        }
        .card-icon {
            width: 36px;
            height: 36px;
            margin-left: 10px;
            vertical-align: middle;
        }
        .card h3 {
            display: flex;
            align-items: center;
            margin-bottom: 0;
        }
        .weather-icon {
            width: 40px;
            height: 40px;
            margin-left: 8px;
            vertical-align: middle;
            display: inline-block;
        }
        .weather-icon-center {
            width: 50px;
            height: 50px;
            margin-left: 12px;
            vertical-align: middle;
            display: inline-block;
        }
        .weather-icon-small {
            width: 30px;
            height: 30px;
            margin-left: 6px;
            vertical-align: middle;
            display: inline-block;
        }
        .forecast-weather-icon {
            width: 32px;
            height: 32px;
            margin-left: 6px;
            vertical-align: middle;
            display: inline-block;
        }
    </style>
</head>
<body>
<header>
    <div>
        <strong>AI 农业助手</strong>
    </div>
    <div class="actions">
        <c:choose>
            <c:when test="${not empty currentFarmer}">
                <a href="${pageContext.request.contextPath}/farmer/profile/edit" style="color: #fff; text-decoration: none; margin-right: 12px;">${currentFarmer.name}（${currentFarmer.phone}）</a>
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
        <c:set var="weatherDesc" value="${weather.description}"/>
        <c:choose>
            <c:when test="${fn:contains(weatherDesc, '雷') || fn:contains(weatherDesc, '风暴')}">
                <c:set var="weatherIcon" value="storm.gif"/>
            </c:when>
            <c:when test="${fn:contains(weatherDesc, '雨')}">
                <c:set var="weatherIcon" value="rain.gif"/>
            </c:when>
            <c:when test="${fn:contains(weatherDesc, '雪')}">
                <c:set var="weatherIcon" value="snow.gif"/>
            </c:when>
            <c:when test="${fn:contains(weatherDesc, '雾') || fn:contains(weatherDesc, '霾')}">
                <c:set var="weatherIcon" value="fog.gif"/>
            </c:when>
            <c:when test="${fn:contains(weatherDesc, '多云') || fn:contains(weatherDesc, '阴')}">
                <c:set var="weatherIcon" value="cloudy.gif"/>
            </c:when>
            <c:when test="${fn:contains(weatherDesc, '风')}">
                <c:set var="weatherIcon" value="wind.gif"/>
            </c:when>
            <c:otherwise>
                <c:set var="weatherIcon" value="sunny.gif"/>
            </c:otherwise>
        </c:choose>
        <div class="weather-banner">
            <div style="display:flex;align-items:center;">
                <div class="weather-main">${weather.temperature}℃</div>
                <div class="weather-sub">
                    <div>${weather.description}</div>
                    <div class="weather-sub-location" style="font-size:14px;opacity:.85;">
                        ${weather.province} · ${weather.city}
                        <img class="weather-icon-center" src="${pageContext.request.contextPath}/assets/${weatherIcon}" alt="天气图标">
                    </div>
                </div>
            </div>
            <div class="weather-context">
                风速 ${weather.windspeed} m/s ｜ 风力 ${weather.windpower}
                <img class="weather-icon-small" src="${pageContext.request.contextPath}/assets/wind.gif" alt="风图标"><br/>
                ${weather.reportTime}
            </div>
        </div>
        <c:if test="${not empty weather.forecasts}">
            <div class="forecast-panel">
                <strong>未来天气预报</strong>
                <div class="forecast-list">
                    <c:forEach items="${weather.forecasts}" var="forecast" varStatus="status">
                        <c:if test="${status.index < 3}">
                        <c:set var="dayWeather" value="${forecast.dayWeather}"/>
                        <c:choose>
                            <c:when test="${fn:contains(dayWeather, '雷') || fn:contains(dayWeather, '风暴')}">
                                <c:set var="dayIcon" value="storm.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(dayWeather, '雨')}">
                                <c:set var="dayIcon" value="rain.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(dayWeather, '雪')}">
                                <c:set var="dayIcon" value="snow.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(dayWeather, '雾') || fn:contains(dayWeather, '霾')}">
                                <c:set var="dayIcon" value="fog.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(dayWeather, '多云') || fn:contains(dayWeather, '阴')}">
                                <c:set var="dayIcon" value="cloudy.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(dayWeather, '风')}">
                                <c:set var="dayIcon" value="wind.gif"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="dayIcon" value="sunny.gif"/>
                            </c:otherwise>
                        </c:choose>
                        <c:set var="nightWeather" value="${forecast.nightWeather}"/>
                        <c:choose>
                            <c:when test="${fn:contains(nightWeather, '雷') || fn:contains(nightWeather, '风暴')}">
                                <c:set var="nightIcon" value="storm.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(nightWeather, '雨')}">
                                <c:set var="nightIcon" value="rain.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(nightWeather, '雪')}">
                                <c:set var="nightIcon" value="snow.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(nightWeather, '雾') || fn:contains(nightWeather, '霾')}">
                                <c:set var="nightIcon" value="fog.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(nightWeather, '多云') || fn:contains(nightWeather, '阴')}">
                                <c:set var="nightIcon" value="cloudy.gif"/>
                            </c:when>
                            <c:when test="${fn:contains(nightWeather, '风')}">
                                <c:set var="nightIcon" value="wind.gif"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="nightIcon" value="sunny.gif"/>
                            </c:otherwise>
                        </c:choose>
                        <div class="forecast-item">
                            <div>${forecast.date}</div>
                            <div>白天：${forecast.dayWeather}，${forecast.dayTemp}℃，${forecast.dayWind} ${forecast.dayPower}
                                <img class="forecast-weather-icon" src="${pageContext.request.contextPath}/assets/${dayIcon}" alt="白天天气">
                            </div>
                            <div>夜间：${forecast.nightWeather}，${forecast.nightTemp}℃，${forecast.nightWind} ${forecast.nightPower}
                                <img class="forecast-weather-icon" src="${pageContext.request.contextPath}/assets/${nightIcon}" alt="夜间天气">
                            </div>
                        </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </c:if>
    <div class="grid">
        <div class="card">
            <h3>拍照识别<img class="card-icon" src="${pageContext.request.contextPath}/assets/camera.png?v=2" alt="拍照识别"></h3>
            <a class="nav-link" href="${pageContext.request.contextPath}/ai">进入 &rarr;</a>
        </div>
        <div class="card">
            <h3>专家问答<img class="card-icon" src="${pageContext.request.contextPath}/assets/expert.png?v=2" alt="专家问答"></h3>
            <a class="nav-link" href="${pageContext.request.contextPath}/expert/qa">进入 &rarr;</a>
        </div>
        <div class="card">
            <h3>农业社区<img class="card-icon" src="${pageContext.request.contextPath}/assets/comment.png" alt="农业社区"></h3>
            <a class="nav-link" href="${pageContext.request.contextPath}/farmer/community">进入 &rarr;</a>
        </div>
    </div>
</div>
</body>
</html>

