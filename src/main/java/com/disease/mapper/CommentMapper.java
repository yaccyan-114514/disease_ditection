package com.disease.mapper;

import com.disease.domain.Comment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CommentMapper {
    List<Comment> findByPostIds(@Param("postIds") List<Long> postIds);
    
    int insertComment(Comment comment);
    
    List<Comment> findAll();
    
    Comment findById(@Param("id") Long id);
    
    int deleteComment(@Param("id") Long id);
}

