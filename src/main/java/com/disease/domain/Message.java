package com.disease.domain;

import java.time.LocalDateTime;

/**
 * 消息通知实体类
 * 用于专家问答模块的消息通知（已读/未读）
 */
public class Message {
    private Long id;
    private Long userId;  // 接收消息的用户ID（农户或专家）
    private String userType;  // 用户类型：farmer 或 expert
    private Long answerId;  // 关联的回答ID
    private Long questionId;  // 关联的问题ID
    private String content;  // 消息内容
    private Boolean isRead;  // 是否已读
    private LocalDateTime createdAt;  // 创建时间
    private LocalDateTime readAt;  // 阅读时间
    
    // 关联对象
    private Answer answer;
    private Question question;
    private Expert expert;  // 发送消息的专家（如果是专家回复）
    private Farmer farmer;  // 发送消息的农户（如果是农户提问）

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

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public Long getAnswerId() {
        return answerId;
    }

    public void setAnswerId(Long answerId) {
        this.answerId = answerId;
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(Boolean isRead) {
        this.isRead = isRead;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getReadAt() {
        return readAt;
    }

    public void setReadAt(LocalDateTime readAt) {
        this.readAt = readAt;
    }

    public Answer getAnswer() {
        return answer;
    }

    public void setAnswer(Answer answer) {
        this.answer = answer;
    }

    public Question getQuestion() {
        return question;
    }

    public void setQuestion(Question question) {
        this.question = question;
    }

    public Expert getExpert() {
        return expert;
    }

    public void setExpert(Expert expert) {
        this.expert = expert;
    }

    public Farmer getFarmer() {
        return farmer;
    }

    public void setFarmer(Farmer farmer) {
        this.farmer = farmer;
    }
}
