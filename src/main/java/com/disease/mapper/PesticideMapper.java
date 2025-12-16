package com.disease.mapper;

import com.disease.domain.Pesticide;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PesticideMapper {
    List<Pesticide> findAll();
    Pesticide findById(@Param("id") Long id);
    int insert(Pesticide pesticide);
    int update(Pesticide pesticide);
    int delete(@Param("id") Long id);
}
