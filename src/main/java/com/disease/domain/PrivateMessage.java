package com.disease.domain;

import java.time.LocalDateTime;

/**
 * 私信实体类
 * 用于用户之间的私信交流
 */
public class PrivateMessage {
    private Long id;
    private Long senderId;  // 发送者ID
    private String senderType;  // 发送者类型：farmer 或 expert
    private Long receiverId;  // 接收者ID
    private String receiverType;  // 接收者类型：farmer 或 expert
    private String content;  // 消息内容
    private Boolean isRead;  // 是否已读
    private LocalDateTime createdAt;  // 创建时间
    private LocalDateTime readAt;  // 阅读时间
    
    // 关联对象
    private Farmer senderFarmer;  // 发送者（如果是农户）
    private Expert senderExpert;  // 发送者（如果是专家）
    private Farmer receiverFarmer;  // 接收者（如果是农户）
    private Expert receiverExpert;  // 接收者（如果是专家）

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getSenderId() {
        return senderId;
    }

    public void setSenderId(Long senderId) {
        this.senderId = senderId;
    }

    public String getSenderType() {
        return senderType;
    }

    public void setSenderType(String senderType) {
        this.senderType = senderType;
    }

    public Long getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(Long receiverId) {
        this.receiverId = receiverId;
    }

    public String getReceiverType() {
        return receiverType;
    }

    public void setReceiverType(String receiverType) {
        this.receiverType = receiverType;
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

    public Farmer getSenderFarmer() {
        return senderFarmer;
    }

    public void setSenderFarmer(Farmer senderFarmer) {
        this.senderFarmer = senderFarmer;
    }

    public Expert getSenderExpert() {
        return senderExpert;
    }

    public void setSenderExpert(Expert senderExpert) {
        this.senderExpert = senderExpert;
    }

    public Farmer getReceiverFarmer() {
        return receiverFarmer;
    }

    public void setReceiverFarmer(Farmer receiverFarmer) {
        this.receiverFarmer = receiverFarmer;
    }

    public Expert getReceiverExpert() {
        return receiverExpert;
    }

    public void setReceiverExpert(Expert receiverExpert) {
        this.receiverExpert = receiverExpert;
    }
}
