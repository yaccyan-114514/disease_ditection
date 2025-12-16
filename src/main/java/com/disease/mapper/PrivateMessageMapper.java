package com.disease.mapper;

import com.disease.domain.PrivateMessage;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PrivateMessageMapper {
    /**
     * 插入私信
     */
    void insert(PrivateMessage message);

    /**
     * 根据ID查找私信
     */
    PrivateMessage findById(Long id);

    /**
     * 获取两个用户之间的对话列表
     */
    List<PrivateMessage> findConversation(@Param("userId1") Long userId1, @Param("userType1") String userType1,
                                         @Param("userId2") Long userId2, @Param("userType2") String userType2);

    /**
     * 获取用户的所有对话列表（按对话对象分组，返回最新一条消息）
     */
    List<PrivateMessage> findConversationList(@Param("userId") Long userId, @Param("userType") String userType);

    /**
     * 统计未读私信数量
     */
    int countUnreadByReceiver(@Param("receiverId") Long receiverId, @Param("receiverType") String receiverType);

    /**
     * 统计与特定用户的未读私信数量
     */
    int countUnreadBySenderAndReceiver(@Param("senderId") Long senderId, @Param("senderType") String senderType,
                                       @Param("receiverId") Long receiverId, @Param("receiverType") String receiverType);

    /**
     * 标记私信为已读
     */
    void markAsRead(@Param("id") Long id, @Param("readAt") java.time.LocalDateTime readAt);

    /**
     * 标记与特定用户的所有私信为已读
     */
    void markConversationAsRead(@Param("senderId") Long senderId, @Param("senderType") String senderType,
                                 @Param("receiverId") Long receiverId, @Param("receiverType") String receiverType,
                                 @Param("readAt") java.time.LocalDateTime readAt);

    /**
     * 删除私信
     */
    void delete(Long id);
}
