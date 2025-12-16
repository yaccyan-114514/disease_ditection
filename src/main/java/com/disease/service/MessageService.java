package com.disease.service;

import com.disease.domain.Answer;
import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import com.disease.domain.Message;
import com.disease.domain.Question;
import com.disease.mapper.AnswerMapper;
import com.disease.mapper.ExpertMapper;
import com.disease.mapper.FarmerMapper;
import com.disease.mapper.MessageMapper;
import com.disease.mapper.QuestionMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class MessageService {

    private final MessageMapper messageMapper;
    private final AnswerMapper answerMapper;
    private final QuestionMapper questionMapper;
    private final ExpertMapper expertMapper;
    private final FarmerMapper farmerMapper;

    public MessageService(MessageMapper messageMapper,
                         AnswerMapper answerMapper,
                         QuestionMapper questionMapper,
                         ExpertMapper expertMapper,
                         FarmerMapper farmerMapper) {
        this.messageMapper = messageMapper;
        this.answerMapper = answerMapper;
        this.questionMapper = questionMapper;
        this.expertMapper = expertMapper;
        this.farmerMapper = farmerMapper;
    }

    /**
     * 创建消息（当专家回复问题时）
     */
    @Transactional
    public void createMessageForAnswer(Long answerId) {
        Answer answer = answerMapper.findById(answerId);
        if (answer == null) {
            return;
        }

        Question question = questionMapper.findById(answer.getQuestionId());
        if (question == null) {
            return;
        }

        // 为农户创建消息
        Message message = new Message();
        message.setUserId(question.getUserId());
        message.setUserType("farmer");
        message.setAnswerId(answerId);
        message.setQuestionId(question.getId());
        message.setContent("专家回复了您的问题");
        message.setIsRead(false);
        message.setCreatedAt(LocalDateTime.now());
        messageMapper.insert(message);
    }

    /**
     * 创建消息（当农户提问时，通知专家）
     */
    @Transactional
    public void createMessageForQuestion(Long questionId, Long expertId) {
        Question question = questionMapper.findById(questionId);
        if (question == null) {
            return;
        }

        // 为专家创建消息
        Message message = new Message();
        message.setUserId(expertId);
        message.setUserType("expert");
        message.setQuestionId(questionId);
        message.setContent("有新的问题需要您回答");
        message.setIsRead(false);
        message.setCreatedAt(LocalDateTime.now());
        messageMapper.insert(message);
    }

    /**
     * 获取用户的所有消息
     */
    public List<Message> getMessagesByUser(Long userId, String userType) {
        List<Message> messages = messageMapper.findByUserIdAndType(userId, userType);
        // 填充关联对象
        for (Message message : messages) {
            if (message.getAnswerId() != null) {
                Answer answer = answerMapper.findById(message.getAnswerId());
                if (answer != null) {
                    message.setAnswer(answer);
                    if (answer.getExpertId() != null) {
                        Expert expert = expertMapper.findById(answer.getExpertId());
                        message.setExpert(expert);
                    }
                }
            }
            if (message.getQuestionId() != null) {
                Question question = questionMapper.findById(message.getQuestionId());
                if (question != null) {
                    message.setQuestion(question);
                    if (question.getUserId() != null) {
                        Farmer farmer = farmerMapper.findById(question.getUserId());
                        message.setFarmer(farmer);
                    }
                }
            }
        }
        return messages;
    }

    /**
     * 获取用户的未读消息
     */
    public List<Message> getUnreadMessages(Long userId, String userType) {
        List<Message> messages = messageMapper.findUnreadByUserIdAndType(userId, userType);
        // 填充关联对象
        for (Message message : messages) {
            if (message.getAnswerId() != null) {
                Answer answer = answerMapper.findById(message.getAnswerId());
                if (answer != null) {
                    message.setAnswer(answer);
                    if (answer.getExpertId() != null) {
                        Expert expert = expertMapper.findById(answer.getExpertId());
                        message.setExpert(expert);
                    }
                }
            }
            if (message.getQuestionId() != null) {
                Question question = questionMapper.findById(message.getQuestionId());
                if (question != null) {
                    message.setQuestion(question);
                    if (question.getUserId() != null) {
                        Farmer farmer = farmerMapper.findById(question.getUserId());
                        message.setFarmer(farmer);
                    }
                }
            }
        }
        return messages;
    }

    /**
     * 统计未读消息数量
     */
    public int countUnreadMessages(Long userId, String userType) {
        return messageMapper.countUnreadByUserIdAndType(userId, userType);
    }

    /**
     * 标记消息为已读
     */
    @Transactional
    public void markAsRead(Long messageId) {
        messageMapper.markAsRead(messageId, LocalDateTime.now());
    }

    /**
     * 标记所有消息为已读
     */
    @Transactional
    public void markAllAsRead(Long userId, String userType) {
        messageMapper.markAllAsRead(userId, userType, LocalDateTime.now());
    }
}
