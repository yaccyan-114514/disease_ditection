package com.disease.service;

import com.disease.domain.Comment;
import com.disease.domain.Post;
import com.disease.mapper.CommentMapper;
import com.disease.mapper.PostMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CommunityService {

    private final PostMapper postMapper;
    private final CommentMapper commentMapper;
    private final ObjectMapper objectMapper;

    public CommunityService(PostMapper postMapper, CommentMapper commentMapper) {
        this.postMapper = postMapper;
        this.commentMapper = commentMapper;
        this.objectMapper = new ObjectMapper();
    }

    public List<Post> latestPosts() {
        List<Post> posts = postMapper.findLatest();
        if (posts.isEmpty()) {
            return posts;
        }
        List<Long> postIds = posts.stream().map(Post::getId).collect(Collectors.toList());
        List<Comment> comments = commentMapper.findByPostIds(postIds);
        Map<Long, List<Comment>> commentGroup = comments.stream()
                .collect(Collectors.groupingBy(Comment::getPostId));
        for (Post post : posts) {
            post.setComments(commentGroup.getOrDefault(post.getId(), Collections.emptyList()));
        }
        return posts;
    }

    @Transactional
    public Post createPost(Long userId, String title, String content, String images) {
        Post post = new Post();
        post.setUserId(userId);
        post.setTitle(title);
        post.setContent(content);
        // 将图片路径转换为 JSON 数组格式
        try {
            if (images != null && !images.trim().isEmpty()) {
                List<String> imageList = new ArrayList<>();
                imageList.add(images);
                post.setImages(objectMapper.writeValueAsString(imageList));
            } else {
                post.setImages(null);
            }
        } catch (Exception e) {
            throw new RuntimeException("转换图片路径为 JSON 失败", e);
        }
        postMapper.insertPost(post);
        return post;
    }

    @Transactional
    public Comment addComment(Long postId, Long userId, String content) {
        Comment comment = new Comment();
        comment.setPostId(postId);
        comment.setUserId(userId);
        comment.setContent(content);
        commentMapper.insertComment(comment);
        return comment;
    }
}

