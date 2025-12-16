package com.disease.mapper;

import com.disease.domain.Disease;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DiseaseMapper {
    List<Disease> findAll();
    Disease findById(@Param("id") Long id);
    int insert(Disease disease);
    int update(Disease disease);
    int delete(@Param("id") Long id);
}
