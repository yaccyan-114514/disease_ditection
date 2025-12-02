package com.disease.mapper;

import com.disease.domain.Answer;

import java.util.List;

public interface AnswerMapper {
    List<Answer> findByQuestionId(Long questionId);

    int insertAnswer(Answer answer);
}

