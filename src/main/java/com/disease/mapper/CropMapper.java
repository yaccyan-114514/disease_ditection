package com.disease.mapper;

import com.disease.domain.Crop;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CropMapper {
    List<Crop> findAll();
    Crop findById(@Param("id") Long id);
    int insert(Crop crop);
    int update(Crop crop);
    int delete(@Param("id") Long id);
}
