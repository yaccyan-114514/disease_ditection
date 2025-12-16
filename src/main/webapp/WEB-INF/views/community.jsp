<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>农业社区</title>
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
            max-width: 900px;
            margin: 32px auto;
            padding: 0 16px;
            position: relative;
            z-index: 1;
        }
        .post-form {
            background: rgba(255,255,255,0.12);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 25px 45px rgba(0,0,0,.25);
            border: 1px solid rgba(255,255,255,0.15);
        }
        .post-form h3 {
            margin-top: 0;
            margin-bottom: 16px;
        }
        .post-form input[type="text"],
        .post-form textarea {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-family: inherit;
            font-size: 14px;
            margin-bottom: 12px;
            box-sizing: border-box;
        }
        .post-form input[type="text"]::placeholder,
        .post-form textarea::placeholder {
            color: rgba(255,255,255,0.5);
        }
        .post-form textarea {
            min-height: 100px;
            resize: vertical;
        }
        .file-upload-wrapper {
            position: relative;
            display: inline-block;
            margin-bottom: 12px;
        }
        .file-upload-wrapper input[type="file"] {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }
        .file-upload-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            padding: 0;
        }
        .file-upload-button:hover {
            background: rgba(255,255,255,0.25);
            border-color: rgba(255,255,255,0.5);
        }
        .file-upload-button img {
            width: 24px;
            height: 24px;
            opacity: 0.9;
        }
        .file-name {
            font-size: 12px;
            opacity: 0.7;
            margin-left: 8px;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .btn {
            padding: 10px 24px;
            border-radius: 8px;
            border: none;
            background: rgba(255,255,255,0.25);
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn:hover {
            background: rgba(255,255,255,0.35);
        }
        .post {
            background: rgba(255,255,255,0.12);
            border-radius: 16px;
            padding: 20px 24px;
            margin-bottom: 20px;
            box-shadow: 0 25px 45px rgba(0,0,0,.25);
            border: 1px solid rgba(255,255,255,0.15);
        }
        .post-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 12px;
        }
        .post-title {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
        }
        .post-meta {
            font-size: 14px;
            opacity: 0.8;
            margin-bottom: 12px;
        }
        .post-content {
            line-height: 1.6;
            margin-bottom: 16px;
        }
        .post-image {
            margin-top: 12px;
        }
        .post-image img {
            max-width: 100%;
            border-radius: 8px;
            cursor: pointer;
        }
        .comments-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.2);
        }
        .comments-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 16px;
        }
        .comment {
            background: rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 12px;
        }
        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .comment-author {
            font-weight: 600;
            font-size: 14px;
        }
        .comment-time {
            font-size: 12px;
            opacity: 0.7;
        }
        .comment-content {
            line-height: 1.5;
        }
        .comment-form {
            margin-top: 16px;
            display: flex;
            gap: 8px;
        }
        .comment-form input {
            flex: 1;
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-family: inherit;
            font-size: 14px;
        }
        .comment-form input::placeholder {
            color: rgba(255,255,255,0.5);
        }
        .comment-form button {
            padding: 10px 20px;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            opacity: 0.7;
        }
        .actions a {
            color: #fff;
            background: rgba(255,255,255,0.25);
            padding: 6px 14px;
            border-radius: 20px;
            text-decoration: none;
            margin-left: 12px;
        }
        .error, .message {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
        }
        .error {
            background: rgba(220, 53, 69, 0.3);
            border: 1px solid rgba(220, 53, 69, 0.5);
        }
        .message {
            background: rgba(40, 167, 69, 0.3);
            border: 1px solid rgba(40, 167, 69, 0.5);
        }
        .image-preview {
            margin-top: 8px;
        }
        .image-preview img {
            max-width: 200px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            cursor: pointer;
        }
    </style>
</head>
<body>
<header>
    <div>
        <strong>农业社区</strong>
    </div>
    <div class="actions">
        <c:if test="${not empty currentFarmer}">
            <span>${currentFarmer.name}</span>
            <a href="${pageContext.request.contextPath}/farmer/home">返回首页</a>
            <a href="${pageContext.request.contextPath}/farmer/logout">退出</a>
        </c:if>
    </div>
</header>

<div class="container">
    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>

    <!-- 发帖表单 -->
    <div class="post-form">
        <h3>发布动态</h3>
        <form method="post" action="${pageContext.request.contextPath}/farmer/community/post" 
              enctype="multipart/form-data">
            <input type="text" name="title" placeholder="标题" required>
            <textarea name="content" placeholder="分享您的农业经验、问题或心得..." required></textarea>
            <div>
                <div class="file-upload-wrapper">
                    <input type="file" name="image" accept="image/*" id="postImageInput">
                    <label for="postImageInput" class="file-upload-button">
                        <img src="${pageContext.request.contextPath}/assets/pictures.png" alt="上传图片">
                    </label>
                    <span class="file-name" id="postFileName"></span>
                </div>
                <div id="postImagePreview" style="display: none; margin-top: 8px;">
                    <img id="postPreviewImg" src="" alt="预览" style="max-width: 200px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.3);">
                    <button type="button" onclick="clearPostImage()" style="margin-left: 8px; padding: 4px 8px; background: rgba(220,53,69,0.3); color: #fff; border: none; border-radius: 4px; cursor: pointer;">删除</button>
                </div>
            </div>
            <button type="submit" class="btn">发布</button>
        </form>
    </div>

    <!-- 帖子列表 -->
    <c:choose>
        <c:when test="${not empty posts && fn:length(posts) > 0}">
            <c:forEach var="post" items="${posts}">
                <div class="post">
                    <div class="post-header">
                        <h3 class="post-title">${post.title}</h3>
                    </div>
                    <div class="post-meta">
                        <c:if test="${not empty post.author}">
                            <a href="${pageContext.request.contextPath}/private-message/chat?otherUserId=${post.author.id}&otherUserType=farmer" 
                               style="color: rgba(40, 167, 69, 0.9); text-decoration: none; font-weight: 600; cursor: pointer;"
                               onmouseover="this.style.textDecoration='underline'" 
                               onmouseout="this.style.textDecoration='none'">
                                ${post.author.name}
                            </a>
                            <c:if test="${not empty post.author.region}">
                                | ${post.author.region}
                            </c:if>
                        </c:if>
                        <c:if test="${not empty post.createdAt}">
                            | ${fn:replace(fn:substring(post.createdAt.toString(), 0, 16), 'T', ' ')}
                        </c:if>
                    </div>
                    <div class="post-content">
                        ${post.content}
                    </div>
                    <c:if test="${not empty post.images}">
                        <div class="post-image" id="post-images-${post.id}">
                            <!-- 图片将通过 JavaScript 动态加载 -->
                        </div>
                        <script>
                            (function() {
                                try {
                                    const imagesJson = '${post.images}';
                                    const imageContainer = document.getElementById('post-images-${post.id}');
                                    if (imagesJson && imageContainer) {
                                        const images = JSON.parse(imagesJson);
                                        if (Array.isArray(images) && images.length > 0) {
                                            images.forEach(function(imagePath) {
                                                if (imagePath) {
                                                    const img = document.createElement('img');
                                                    img.src = '${pageContext.request.contextPath}' + imagePath;
                                                    img.alt = '帖子图片';
                                                    img.style.cursor = 'pointer';
                                                    img.onclick = function() {
                                                        window.open('${pageContext.request.contextPath}' + imagePath, '_blank');
                                                    };
                                                    imageContainer.appendChild(img);
                                                }
                                            });
                                        }
                                    }
                                } catch (e) {
                                    console.error('解析图片 JSON 失败:', e);
                                }
                            })();
                        </script>
                    </c:if>
                    
                    <!-- 评论区域 -->
                    <div class="comments-section">
                        <div class="comments-title">评论 (${fn:length(post.comments)})</div>
                        
                        <!-- 已有评论 -->
                        <c:forEach var="comment" items="${post.comments}">
                            <div class="comment">
                                <div class="comment-header">
                                    <span class="comment-author">
                                        <c:if test="${not empty comment.author}">
                                            <a href="${pageContext.request.contextPath}/private-message/chat?otherUserId=${comment.author.id}&otherUserType=farmer" 
                                               style="color: rgba(40, 167, 69, 0.9); text-decoration: none; font-weight: 600; cursor: pointer;"
                                               onmouseover="this.style.textDecoration='underline'" 
                                               onmouseout="this.style.textDecoration='none'">
                                                ${comment.author.name}
                                            </a>
                                        </c:if>
                                    </span>
                                    <span class="comment-time">
                                        ${fn:replace(fn:substring(comment.createdAt.toString(), 0, 16), 'T', ' ')}
                                    </span>
                                </div>
                                <div class="comment-content">
                                    ${comment.content}
                                </div>
                            </div>
                        </c:forEach>
                        
                        <!-- 评论表单 -->
                        <form method="post" action="${pageContext.request.contextPath}/farmer/community/comment" 
                              class="comment-form">
                            <input type="hidden" name="postId" value="${post.id}">
                            <input type="text" name="content" placeholder="写下你的评论..." required>
                            <button type="submit" class="btn">评论</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <p>暂无动态，快来发布第一条吧！</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // 发帖图片预览
    document.getElementById('postImageInput')?.addEventListener('change', function(e) {
        const file = e.target.files[0];
        const fileName = document.getElementById('postFileName');
        if (file) {
            if (fileName) {
                fileName.textContent = file.name;
            }
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('postImagePreview');
                const previewImg = document.getElementById('postPreviewImg');
                if (preview && previewImg) {
                    previewImg.src = e.target.result;
                    preview.style.display = 'block';
                }
            };
            reader.readAsDataURL(file);
        } else {
            if (fileName) {
                fileName.textContent = '';
            }
        }
    });

    function clearPostImage() {
        const input = document.getElementById('postImageInput');
        const preview = document.getElementById('postImagePreview');
        const fileName = document.getElementById('postFileName');
        if (input) input.value = '';
        if (preview) preview.style.display = 'none';
        if (fileName) fileName.textContent = '';
    }
</script>
</body>
</html>
