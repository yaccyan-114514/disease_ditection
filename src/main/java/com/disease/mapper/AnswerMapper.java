package com.disease.mapper;

import com.disease.domain.Answer;

import java.util.List;

public interface AnswerMapper {
    List<Answer> findByQuestionId(Long questionId);

    Answer findById(Long id);

    int insertAnswer(Answer answer);
}

