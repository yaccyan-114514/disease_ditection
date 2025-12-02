package com.disease.mapper;

import com.disease.domain.Question;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface QuestionMapper {
    int insertQuestion(Question question);

    List<Question> findLatest(@Param("limit") int limit);
}

