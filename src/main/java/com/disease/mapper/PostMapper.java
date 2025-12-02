package com.disease.mapper;

import com.disease.domain.Post;

import java.util.List;

public interface PostMapper {
    List<Post> findLatest();
}

