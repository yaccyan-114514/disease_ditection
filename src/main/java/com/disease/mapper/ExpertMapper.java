package com.disease.mapper;

import com.disease.domain.Expert;

public interface ExpertMapper {
    Expert findRandomActive();
    Expert findById(Long id);
}

