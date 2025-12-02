package com.disease.service;

import com.disease.domain.Comment;
import com.disease.domain.Post;
import com.disease.mapper.CommentMapper;
import com.disease.mapper.PostMapper;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CommunityService {

    private final PostMapper postMapper;
    private final CommentMapper commentMapper;

    public CommunityService(PostMapper postMapper, CommentMapper commentMapper) {
        this.postMapper = postMapper;
        this.commentMapper = commentMapper;
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
}

