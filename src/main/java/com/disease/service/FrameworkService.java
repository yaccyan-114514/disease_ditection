package com.disease.service;

import com.disease.mapper.FrameworkMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FrameworkService {

    private final FrameworkMapper frameworkMapper;

    public FrameworkService(FrameworkMapper frameworkMapper) {
        this.frameworkMapper = frameworkMapper;
    }

    @Transactional(readOnly = true)
    public String getFrameworkStatus() {
        return frameworkMapper.ping();
    }
}

