package com.disease.domain;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Post {
    private Long id;
    private Long userId;
    private String title;
    private String content;
    private String images;
    private LocalDateTime createdAt;
    private Farmer author;
    private List<Comment> comments;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Farmer getAuthor() {
        return author;
    }

    public void setAuthor(Farmer author) {
        this.author = author;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }
    
    /**
     * 获取图片列表（从 JSON 字符串解析）
     */
    public List<String> getImageList() {
        if (images == null || images.trim().isEmpty()) {
            return new ArrayList<>();
        }
        try {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(images, new TypeReference<List<String>>() {});
        } catch (Exception e) {
            // 如果解析失败，尝试作为单个字符串处理（兼容旧数据）
            return new ArrayList<>();
        }
    }
    
    /**
     * 获取第一张图片（用于显示）
     */
    public String getFirstImage() {
        List<String> imageList = getImageList();
        return imageList.isEmpty() ? null : imageList.get(0);
    }
}

