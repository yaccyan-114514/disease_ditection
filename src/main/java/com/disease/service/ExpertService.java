package com.disease.service;

import com.disease.domain.Expert;
import com.disease.mapper.ExpertMapper;
import org.springframework.stereotype.Service;

@Service
public class ExpertService {

    private final ExpertMapper expertMapper;

    public ExpertService(ExpertMapper expertMapper) {
        this.expertMapper = expertMapper;
    }

    public Expert login(String phone, String password) {
        Expert expert = expertMapper.findByPhone(phone);
        if (expert != null && expert.getPassword().equals(password) && "active".equals(expert.getStatus())) {
            return expert;
        }
        return null;
    }

    public Expert findById(Long id) {
        return expertMapper.findById(id);
    }

    public int updateExpert(Expert expert) {
        return expertMapper.updateExpert(expert);
    }
}

