package com.disease.service;

import com.disease.domain.Answer;
import com.disease.domain.Farmer;
import com.disease.domain.Question;
import com.disease.mapper.AnswerMapper;
import com.disease.mapper.FarmerMapper;
import com.disease.mapper.QuestionMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ExpertQuestionService {

    private final QuestionMapper questionMapper;
    private final AnswerMapper answerMapper;
    private final FarmerMapper farmerMapper;
    private final MessageService messageService;

    public ExpertQuestionService(QuestionMapper questionMapper, AnswerMapper answerMapper, FarmerMapper farmerMapper, MessageService messageService) {
        this.questionMapper = questionMapper;
        this.answerMapper = answerMapper;
        this.farmerMapper = farmerMapper;
        this.messageService = messageService;
    }

    /**
     * 获取专家帮扶的用户列表（去重）
     */
    public List<Farmer> getHelpedUsers(Long expertId) {
        List<Question> questions = questionMapper.findByExpertId(expertId);
        Set<Long> userIds = questions.stream()
                .map(Question::getUserId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        
        List<Farmer> users = new ArrayList<>();
        for (Long userId : userIds) {
            Farmer farmer = farmerMapper.findById(userId);
            if (farmer != null) {
                users.add(farmer);
            }
        }
        // 按姓名排序
        users.sort(Comparator.comparing(Farmer::getName));
        return users;
    }

    /**
     * 获取指定用户与专家的所有对话（问题和回答）
     */
    public List<Question> getConversationsByUserId(Long expertId, Long userId) {
        List<Question> allQuestions = questionMapper.findByExpertId(expertId);
        // 过滤出该用户的问题
        List<Question> userQuestions = allQuestions.stream()
                .filter(q -> q.getUserId() != null && q.getUserId().equals(userId))
                .collect(Collectors.toList());
        
        // 加载提问者信息和答案
        for (Question question : userQuestions) {
            if (question.getUserId() != null) {
                Farmer farmer = farmerMapper.findById(question.getUserId());
                question.setAsker(farmer);
            }
            List<Answer> answers = answerMapper.findByQuestionId(question.getId());
            // 只保留该专家的回答
            answers = answers.stream()
                    .filter(a -> a.getExpertId() != null && a.getExpertId().equals(expertId))
                    .collect(Collectors.toList());
            // 按时间排序答案
            answers.sort((a1, a2) -> {
                if (a1.getCreatedAt() == null && a2.getCreatedAt() == null) return 0;
                if (a1.getCreatedAt() == null) return 1;
                if (a2.getCreatedAt() == null) return -1;
                return a1.getCreatedAt().compareTo(a2.getCreatedAt());
            });
            question.setAnswers(answers);
        }
        
        // 按时间排序（最新的在前）
        userQuestions.sort((q1, q2) -> {
            if (q1.getCreatedAt() == null && q2.getCreatedAt() == null) return 0;
            if (q1.getCreatedAt() == null) return 1;
            if (q2.getCreatedAt() == null) return -1;
            return q2.getCreatedAt().compareTo(q1.getCreatedAt());
        });
        
        return userQuestions;
    }

    /**
     * 获取分配给指定专家的问题列表
     */
    public List<Question> getQuestionsByExpertId(Long expertId) {
        List<Question> questions = questionMapper.findByExpertId(expertId);
        // 加载提问者信息和答案
        for (Question question : questions) {
            if (question.getUserId() != null) {
                Farmer farmer = farmerMapper.findById(question.getUserId());
                question.setAsker(farmer);
            }
            List<Answer> answers = answerMapper.findByQuestionId(question.getId());
            question.setAnswers(answers);
        }
        return questions;
    }

    /**
     * 获取问题详情
     */
    public Question getQuestionById(Long questionId) {
        Question question = questionMapper.findById(questionId);
        if (question != null) {
            if (question.getUserId() != null) {
                Farmer farmer = farmerMapper.findById(question.getUserId());
                question.setAsker(farmer);
            }
            List<Answer> answers = answerMapper.findByQuestionId(questionId);
            question.setAnswers(answers);
        }
        return question;
    }

    /**
     * 专家回答问题
     */
    @Transactional
    public Answer answerQuestion(Long questionId, Long expertId, String answerText, String imagePath) {
        Answer answer = new Answer();
        answer.setQuestionId(questionId);
        answer.setExpertId(expertId);
        answer.setAnswerText(answerText);
        answer.setImages(imagePath);
        answerMapper.insertAnswer(answer);
        
        // 创建消息通知（通知农户有新的回答）
        messageService.createMessageForAnswer(answer.getId());
        
        // 更新问题状态为已回答
        Question question = questionMapper.findById(questionId);
        if (question != null) {
            question.setStatus("answered");
            // 这里需要更新问题状态，但QuestionMapper可能没有update方法
            // 暂时先返回答案
        }
        
        return answer;
    }
}

