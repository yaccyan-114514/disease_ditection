package com.disease.service;

import com.disease.domain.Answer;
import com.disease.domain.Expert;
import com.disease.domain.Question;
import com.disease.mapper.AnswerMapper;
import com.disease.mapper.ExpertMapper;
import com.disease.mapper.QuestionMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ExpertConsultService {

    private final ExpertMapper expertMapper;
    private final QuestionMapper questionMapper;
    private final AnswerMapper answerMapper;
    private final MessageService messageService;

    public ExpertConsultService(ExpertMapper expertMapper,
                                QuestionMapper questionMapper,
                                AnswerMapper answerMapper,
                                MessageService messageService) {
        this.expertMapper = expertMapper;
        this.questionMapper = questionMapper;
        this.answerMapper = answerMapper;
        this.messageService = messageService;
    }

    public List<Question> latestQuestions(int limit) {
        List<Question> questions = questionMapper.findLatest(limit);
        for (Question question : questions) {
            List<Answer> answers = answerMapper.findByQuestionId(question.getId());
            question.setAnswers(answers);
        }
        return questions;
    }

    @Transactional
    public Question submitQuestion(Long userId, Long cropId, String text, Long assignedExpertId) {
        Expert expert;
        if (assignedExpertId != null) {
            expert = expertMapper.findById(assignedExpertId);
            if (expert == null || !"active".equals(expert.getStatus())) {
                expert = expertMapper.findRandomActive();
            }
        } else {
            expert = expertMapper.findRandomActive();
        }
        
        Question question = new Question();
        question.setUserId(userId);
        question.setCropId(cropId);
        question.setQuestionText(text);
        question.setStatus("pending");
        questionMapper.insertQuestion(question);

        Answer answer = new Answer();
        answer.setQuestionId(question.getId());
        answer.setExpertId(expert.getId());
        answer.setAnswerText(String.format("专家 %s (%s) 已收到您的问题，稍后将为您详细解答。", expert.getName(), expert.getSpecialty()));
        answerMapper.insertAnswer(answer);

        // 创建消息通知（通知专家有新问题）
        messageService.createMessageForQuestion(question.getId(), expert.getId());

        question.setAnswers(answerMapper.findByQuestionId(question.getId()));
        return question;
    }
    
    /**
     * 获取指定农户与分配专家的所有对话
     */
    public List<Question> getConversationsByFarmerId(Long farmerId) {
        List<Question> questions = questionMapper.findByUserId(farmerId);
        for (Question question : questions) {
            List<Answer> answers = answerMapper.findByQuestionId(question.getId());
            question.setAnswers(answers);
        }
        // 按时间排序（最新的在前）
        questions.sort((q1, q2) -> {
            if (q1.getCreatedAt() == null && q2.getCreatedAt() == null) return 0;
            if (q1.getCreatedAt() == null) return 1;
            if (q2.getCreatedAt() == null) return -1;
            return q2.getCreatedAt().compareTo(q1.getCreatedAt());
        });
        return questions;
    }

    public Answer addExpertReply(Long questionId, Long expertId, String content) {
        Answer answer = new Answer();
        answer.setQuestionId(questionId);
        answer.setExpertId(expertId);
        answer.setAnswerText(content);
        answerMapper.insertAnswer(answer);
        
        // 创建消息通知（通知农户有新的回答）
        messageService.createMessageForAnswer(answer.getId());
        
        return answer;
    }
}

