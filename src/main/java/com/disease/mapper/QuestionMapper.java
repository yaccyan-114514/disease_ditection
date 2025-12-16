package com.disease.mapper;

import com.disease.domain.Question;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface QuestionMapper {
    int insertQuestion(Question question);

    List<Question> findLatest(@Param("limit") int limit);
    
    List<Question> findByExpertId(@Param("expertId") Long expertId);
    
    List<Question> findByUserId(@Param("userId") Long userId);
    
    Question findById(@Param("id") Long id);
}

