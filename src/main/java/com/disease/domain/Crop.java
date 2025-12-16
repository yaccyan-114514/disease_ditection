package com.disease.domain;

import java.time.LocalDateTime;

public class Crop {
    private Long id;
    private String cropName;
    private String plantingSeason;
    private String regionAdapt;
    private LocalDateTime createdAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCropName() {
        return cropName;
    }

    public void setCropName(String cropName) {
        this.cropName = cropName;
    }

    public String getPlantingSeason() {
        return plantingSeason;
    }

    public void setPlantingSeason(String plantingSeason) {
        this.plantingSeason = plantingSeason;
    }

    public String getRegionAdapt() {
        return regionAdapt;
    }

    public void setRegionAdapt(String regionAdapt) {
        this.regionAdapt = regionAdapt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
