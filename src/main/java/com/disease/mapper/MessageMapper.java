package com.disease.mapper;

import com.disease.domain.Message;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MessageMapper {
    /**
     * 插入消息
     */
    void insert(Message message);

    /**
     * 根据ID查找消息
     */
    Message findById(Long id);

    /**
     * 根据用户ID和类型查找所有消息
     */
    List<Message> findByUserIdAndType(@Param("userId") Long userId, @Param("userType") String userType);

    /**
     * 根据用户ID和类型查找未读消息
     */
    List<Message> findUnreadByUserIdAndType(@Param("userId") Long userId, @Param("userType") String userType);

    /**
     * 统计未读消息数量
     */
    int countUnreadByUserIdAndType(@Param("userId") Long userId, @Param("userType") String userType);

    /**
     * 标记消息为已读
     */
    void markAsRead(@Param("id") Long id, @Param("readAt") java.time.LocalDateTime readAt);

    /**
     * 标记所有消息为已读
     */
    void markAllAsRead(@Param("userId") Long userId, @Param("userType") String userType, @Param("readAt") java.time.LocalDateTime readAt);

    /**
     * 根据回答ID查找消息
     */
    Message findByAnswerId(Long answerId);

    /**
     * 删除消息
     */
    void delete(Long id);
}
