package com.disease.service;

import com.disease.domain.Comment;
import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import com.disease.domain.Post;
import com.disease.mapper.CommentMapper;
import com.disease.mapper.ExpertMapper;
import com.disease.mapper.FarmerMapper;
import com.disease.mapper.PostMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AdminManagementService {

    private final FarmerMapper farmerMapper;
    private final ExpertMapper expertMapper;
    private final PostMapper postMapper;
    private final CommentMapper commentMapper;

    public AdminManagementService(FarmerMapper farmerMapper, ExpertMapper expertMapper,
                                  PostMapper postMapper, CommentMapper commentMapper) {
        this.farmerMapper = farmerMapper;
        this.expertMapper = expertMapper;
        this.postMapper = postMapper;
        this.commentMapper = commentMapper;
    }

    // 农户管理
    public List<Farmer> getAllFarmers() {
        return farmerMapper.findAll();
    }

    public Farmer getFarmerById(Long id) {
        return farmerMapper.findById(id);
    }

    @Transactional
    public void updateFarmer(Farmer farmer) {
        farmerMapper.updateFarmer(farmer);
    }

    @Transactional
    public void deleteFarmer(Long id) {
        farmerMapper.deleteFarmer(id);
    }

    // 专家管理
    public List<Expert> getAllExperts() {
        return expertMapper.findAll();
    }

    public Expert getExpertById(Long id) {
        return expertMapper.findById(id);
    }

    @Transactional
    public void createExpert(Expert expert) {
        if (expert.getStatus() == null) {
            expert.setStatus("active");
        }
        expertMapper.insertExpert(expert);
    }

    @Transactional
    public void updateExpert(Expert expert) {
        expertMapper.updateExpert(expert);
    }

    @Transactional
    public void deleteExpert(Long id) {
        expertMapper.deleteExpert(id);
    }

    // 社区投稿管理
    public List<Post> getAllPosts() {
        return postMapper.findAll();
    }

    public Post getPostById(Long id) {
        return postMapper.findById(id);
    }

    @Transactional
    public void deletePost(Long id) {
        postMapper.deletePost(id);
    }

    // 评论管理
    public List<Comment> getAllComments() {
        return commentMapper.findAll();
    }

    public Comment getCommentById(Long id) {
        return commentMapper.findById(id);
    }

    @Transactional
    public void deleteComment(Long id) {
        commentMapper.deleteComment(id);
    }
}
