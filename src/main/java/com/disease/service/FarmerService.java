package com.disease.service;

import com.disease.domain.Farmer;
import com.disease.mapper.FarmerMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FarmerService {

    private final FarmerMapper farmerMapper;

    public FarmerService(FarmerMapper farmerMapper) {
        this.farmerMapper = farmerMapper;
    }

    public Farmer login(String phone, String password) {
        Farmer farmer = farmerMapper.findByPhone(phone);
        if (farmer != null && farmer.getPassword().equals(password)) {
            return farmer;
        }
        return null;
    }

    @Transactional
    public Farmer register(Farmer farmer) {
        Farmer existing = farmerMapper.findByPhone(farmer.getPhone());
        if (existing != null) {
            throw new IllegalArgumentException("手机号已被注册");
        }
        farmer.setStatus("active");
        farmerMapper.insertFarmer(farmer);
        return farmer;
    }

    public Farmer findById(Long id) {
        return farmerMapper.findById(id);
    }

    public int updateFarmer(Farmer farmer) {
        return farmerMapper.updateFarmer(farmer);
    }
}

