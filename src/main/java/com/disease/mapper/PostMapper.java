package com.disease.mapper;

import com.disease.domain.Post;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PostMapper {
    List<Post> findLatest();
    
    int insertPost(Post post);
    
    List<Post> findAll();
    
    Post findById(@Param("id") Long id);
    
    int deletePost(@Param("id") Long id);
}

