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

    public ExpertConsultService(ExpertMapper expertMapper,
                                QuestionMapper questionMapper,
                                AnswerMapper answerMapper) {
        this.expertMapper = expertMapper;
        this.questionMapper = questionMapper;
        this.answerMapper = answerMapper;
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
    public Question submitQuestion(Long userId, Long cropId, String text) {
        Expert expert = expertMapper.findRandomActive();
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

        question.setAnswers(answerMapper.findByQuestionId(question.getId()));
        return question;
    }

    public Answer addExpertReply(Long questionId, Long expertId, String content) {
        Answer answer = new Answer();
        answer.setQuestionId(questionId);
        answer.setExpertId(expertId);
        answer.setAnswerText(content);
        answerMapper.insertAnswer(answer);
        return answer;
    }
}

