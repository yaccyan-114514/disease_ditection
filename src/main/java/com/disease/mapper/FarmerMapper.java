package com.disease.mapper;

import com.disease.domain.Farmer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FarmerMapper {
    Farmer findByPhone(@Param("phone") String phone);

    int insertFarmer(Farmer farmer);

    Farmer findById(@Param("id") Long id);
    
    List<Farmer> findAll();
    
    int updateFarmer(Farmer farmer);
    
    int deleteFarmer(@Param("id") Long id);
}

