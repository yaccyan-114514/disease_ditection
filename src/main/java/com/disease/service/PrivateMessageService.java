package com.disease.service;

import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import com.disease.domain.PrivateMessage;
import com.disease.mapper.ExpertMapper;
import com.disease.mapper.FarmerMapper;
import com.disease.mapper.PrivateMessageMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class PrivateMessageService {

    private final PrivateMessageMapper privateMessageMapper;
    private final FarmerMapper farmerMapper;
    private final ExpertMapper expertMapper;

    public PrivateMessageService(PrivateMessageMapper privateMessageMapper,
                                FarmerMapper farmerMapper,
                                ExpertMapper expertMapper) {
        this.privateMessageMapper = privateMessageMapper;
        this.farmerMapper = farmerMapper;
        this.expertMapper = expertMapper;
    }

    /**
     * 发送私信
     */
    @Transactional
    public PrivateMessage sendMessage(Long senderId, String senderType,
                                     Long receiverId, String receiverType,
                                     String content) {
        PrivateMessage message = new PrivateMessage();
        message.setSenderId(senderId);
        message.setSenderType(senderType);
        message.setReceiverId(receiverId);
        message.setReceiverType(receiverType);
        message.setContent(content);
        message.setIsRead(false);
        message.setCreatedAt(LocalDateTime.now());
        privateMessageMapper.insert(message);
        return message;
    }

    /**
     * 获取两个用户之间的对话
     */
    public List<PrivateMessage> getConversation(Long userId1, String userType1,
                                                Long userId2, String userType2) {
        List<PrivateMessage> messages = privateMessageMapper.findConversation(
            userId1, userType1, userId2, userType2);
        
        // 填充关联对象
        for (PrivateMessage message : messages) {
            if ("farmer".equals(message.getSenderType())) {
                Farmer farmer = farmerMapper.findById(message.getSenderId());
                message.setSenderFarmer(farmer);
            } else if ("expert".equals(message.getSenderType())) {
                Expert expert = expertMapper.findById(message.getSenderId());
                message.setSenderExpert(expert);
            }
            
            if ("farmer".equals(message.getReceiverType())) {
                Farmer farmer = farmerMapper.findById(message.getReceiverId());
                message.setReceiverFarmer(farmer);
            } else if ("expert".equals(message.getReceiverType())) {
                Expert expert = expertMapper.findById(message.getReceiverId());
                message.setReceiverExpert(expert);
            }
        }
        
        return messages;
    }

    /**
     * 获取用户的所有对话列表
     */
    public List<PrivateMessage> getConversationList(Long userId, String userType) {
        List<PrivateMessage> conversations = privateMessageMapper.findConversationList(userId, userType);
        
        // 填充关联对象
        for (PrivateMessage message : conversations) {
            // 判断对方是发送者还是接收者
            boolean isSender = message.getSenderId().equals(userId) && message.getSenderType().equals(userType);
            
            if (isSender) {
                // 对方是接收者
                if ("farmer".equals(message.getReceiverType())) {
                    Farmer farmer = farmerMapper.findById(message.getReceiverId());
                    message.setReceiverFarmer(farmer);
                } else if ("expert".equals(message.getReceiverType())) {
                    Expert expert = expertMapper.findById(message.getReceiverId());
                    message.setReceiverExpert(expert);
                }
            } else {
                // 对方是发送者
                if ("farmer".equals(message.getSenderType())) {
                    Farmer farmer = farmerMapper.findById(message.getSenderId());
                    message.setSenderFarmer(farmer);
                } else if ("expert".equals(message.getSenderType())) {
                    Expert expert = expertMapper.findById(message.getSenderId());
                    message.setSenderExpert(expert);
                }
            }
        }
        
        return conversations;
    }

    /**
     * 统计未读私信数量
     */
    public int countUnreadMessages(Long receiverId, String receiverType) {
        return privateMessageMapper.countUnreadByReceiver(receiverId, receiverType);
    }

    /**
     * 统计与特定用户的未读私信数量
     */
    public int countUnreadMessagesWithUser(Long senderId, String senderType,
                                          Long receiverId, String receiverType) {
        return privateMessageMapper.countUnreadBySenderAndReceiver(
            senderId, senderType, receiverId, receiverType);
    }

    /**
     * 标记私信为已读
     */
    @Transactional
    public void markAsRead(Long messageId) {
        privateMessageMapper.markAsRead(messageId, LocalDateTime.now());
    }

    /**
     * 标记与特定用户的所有私信为已读
     */
    @Transactional
    public void markConversationAsRead(Long senderId, String senderType,
                                      Long receiverId, String receiverType) {
        privateMessageMapper.markConversationAsRead(
            senderId, senderType, receiverId, receiverType, LocalDateTime.now());
    }
}
