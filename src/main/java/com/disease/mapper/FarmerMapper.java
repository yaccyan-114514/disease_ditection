package com.disease.mapper;

import com.disease.domain.Farmer;
import org.apache.ibatis.annotations.Param;

public interface FarmerMapper {
    Farmer findByPhone(@Param("phone") String phone);

    int insertFarmer(Farmer farmer);

    Farmer findById(@Param("id") Long id);
}

