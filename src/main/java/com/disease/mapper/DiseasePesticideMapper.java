package com.disease.mapper;

import com.disease.domain.DiseasePesticide;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DiseasePesticideMapper {
    List<DiseasePesticide> findAll();
    DiseasePesticide findById(@Param("id") Long id);
    List<DiseasePesticide> findByDiseaseId(@Param("diseaseId") Long diseaseId);
    List<DiseasePesticide> findByPesticideId(@Param("pesticideId") Long pesticideId);
    int insert(DiseasePesticide diseasePesticide);
    int update(DiseasePesticide diseasePesticide);
    int delete(@Param("id") Long id);
}
