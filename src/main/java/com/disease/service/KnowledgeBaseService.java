package com.disease.service;

import com.disease.domain.*;
import com.disease.mapper.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class KnowledgeBaseService {
    
    private final CropMapper cropMapper;
    private final DiseaseMapper diseaseMapper;
    private final PesticideMapper pesticideMapper;
    private final DiseasePesticideMapper diseasePesticideMapper;

    public KnowledgeBaseService(CropMapper cropMapper, DiseaseMapper diseaseMapper,
                               PesticideMapper pesticideMapper, DiseasePesticideMapper diseasePesticideMapper) {
        this.cropMapper = cropMapper;
        this.diseaseMapper = diseaseMapper;
        this.pesticideMapper = pesticideMapper;
        this.diseasePesticideMapper = diseasePesticideMapper;
    }

    // ========== Crop 相关方法 ==========
    public List<Crop> getAllCrops() {
        return cropMapper.findAll();
    }

    public Crop getCropById(Long id) {
        return cropMapper.findById(id);
    }

    @Transactional
    public void saveCrop(Crop crop) {
        if (crop.getId() == null) {
            cropMapper.insert(crop);
        } else {
            cropMapper.update(crop);
        }
    }

    @Transactional
    public void deleteCrop(Long id) {
        cropMapper.delete(id);
    }

    // ========== Disease 相关方法 ==========
    public List<Disease> getAllDiseases() {
        return diseaseMapper.findAll();
    }

    public Disease getDiseaseById(Long id) {
        return diseaseMapper.findById(id);
    }

    @Transactional
    public void saveDisease(Disease disease) {
        if (disease.getId() == null) {
            diseaseMapper.insert(disease);
        } else {
            diseaseMapper.update(disease);
        }
    }

    @Transactional
    public void deleteDisease(Long id) {
        diseaseMapper.delete(id);
    }

    // ========== Pesticide 相关方法 ==========
    public List<Pesticide> getAllPesticides() {
        return pesticideMapper.findAll();
    }

    public Pesticide getPesticideById(Long id) {
        return pesticideMapper.findById(id);
    }

    @Transactional
    public void savePesticide(Pesticide pesticide) {
        if (pesticide.getId() == null) {
            pesticideMapper.insert(pesticide);
        } else {
            pesticideMapper.update(pesticide);
        }
    }

    @Transactional
    public void deletePesticide(Long id) {
        pesticideMapper.delete(id);
    }

    // ========== DiseasePesticide 相关方法 ==========
    public List<DiseasePesticide> getAllDiseasePesticides() {
        List<DiseasePesticide> list = diseasePesticideMapper.findAll();
        // 填充关联对象
        for (DiseasePesticide dp : list) {
            if (dp.getDiseaseId() != null) {
                dp.setDisease(diseaseMapper.findById(dp.getDiseaseId()));
            }
            if (dp.getPesticideId() != null) {
                dp.setPesticide(pesticideMapper.findById(dp.getPesticideId()));
            }
        }
        return list;
    }

    public DiseasePesticide getDiseasePesticideById(Long id) {
        DiseasePesticide dp = diseasePesticideMapper.findById(id);
        if (dp != null) {
            if (dp.getDiseaseId() != null) {
                dp.setDisease(diseaseMapper.findById(dp.getDiseaseId()));
            }
            if (dp.getPesticideId() != null) {
                dp.setPesticide(pesticideMapper.findById(dp.getPesticideId()));
            }
        }
        return dp;
    }

    @Transactional
    public void saveDiseasePesticide(DiseasePesticide diseasePesticide) {
        if (diseasePesticide.getId() == null) {
            diseasePesticideMapper.insert(diseasePesticide);
        } else {
            diseasePesticideMapper.update(diseasePesticide);
        }
    }

    @Transactional
    public void deleteDiseasePesticide(Long id) {
        diseasePesticideMapper.delete(id);
    }

    // 获取所有疾病和农药，用于下拉选择
    public List<Disease> getAllDiseasesForSelect() {
        return diseaseMapper.findAll();
    }

    public List<Pesticide> getAllPesticidesForSelect() {
        return pesticideMapper.findAll();
    }
}
