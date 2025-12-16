package com.disease.mapper;

import com.disease.domain.Expert;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ExpertMapper {
    Expert findRandomActive();
    Expert findById(Long id);
    Expert findByPhone(String phone);
    
    List<Expert> findAll();
    
    int insertExpert(Expert expert);
    
    int updateExpert(Expert expert);
    
    int deleteExpert(@Param("id") Long id);
}

