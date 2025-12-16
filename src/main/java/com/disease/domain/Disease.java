package com.disease.domain;

public class Disease {
    private Long id;
    private String name;
    private String type; // disease or pest
    private String hostCrop;
    private String symptoms;
    private String harmLevel; // low, medium, high
    private String occurrenceSeason;
    private String climateConditions;
    private String soilConditions;
    private String riskFactors;
    private String diagnosisKeypoints;
    private String similarDiseases; // JSON string
    private String preventionMethods;
    private String controlMethods;
    private String chemicalControl; // JSON string
    private String biologicalControl;
    private String agriculturalControl;
    private Boolean isGreenControl;
    private String images; // JSON string
    private String region;
    private String quarantineLevel; // 1, 2, 3
    private String reportSource;
    private Long createdBy;

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getHostCrop() {
        return hostCrop;
    }

    public void setHostCrop(String hostCrop) {
        this.hostCrop = hostCrop;
    }

    public String getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
    }

    public String getHarmLevel() {
        return harmLevel;
    }

    public void setHarmLevel(String harmLevel) {
        this.harmLevel = harmLevel;
    }

    public String getOccurrenceSeason() {
        return occurrenceSeason;
    }

    public void setOccurrenceSeason(String occurrenceSeason) {
        this.occurrenceSeason = occurrenceSeason;
    }

    public String getClimateConditions() {
        return climateConditions;
    }

    public void setClimateConditions(String climateConditions) {
        this.climateConditions = climateConditions;
    }

    public String getSoilConditions() {
        return soilConditions;
    }

    public void setSoilConditions(String soilConditions) {
        this.soilConditions = soilConditions;
    }

    public String getRiskFactors() {
        return riskFactors;
    }

    public void setRiskFactors(String riskFactors) {
        this.riskFactors = riskFactors;
    }

    public String getDiagnosisKeypoints() {
        return diagnosisKeypoints;
    }

    public void setDiagnosisKeypoints(String diagnosisKeypoints) {
        this.diagnosisKeypoints = diagnosisKeypoints;
    }

    public String getSimilarDiseases() {
        return similarDiseases;
    }

    public void setSimilarDiseases(String similarDiseases) {
        this.similarDiseases = similarDiseases;
    }

    public String getPreventionMethods() {
        return preventionMethods;
    }

    public void setPreventionMethods(String preventionMethods) {
        this.preventionMethods = preventionMethods;
    }

    public String getControlMethods() {
        return controlMethods;
    }

    public void setControlMethods(String controlMethods) {
        this.controlMethods = controlMethods;
    }

    public String getChemicalControl() {
        return chemicalControl;
    }

    public void setChemicalControl(String chemicalControl) {
        this.chemicalControl = chemicalControl;
    }

    public String getBiologicalControl() {
        return biologicalControl;
    }

    public void setBiologicalControl(String biologicalControl) {
        this.biologicalControl = biologicalControl;
    }

    public String getAgriculturalControl() {
        return agriculturalControl;
    }

    public void setAgriculturalControl(String agriculturalControl) {
        this.agriculturalControl = agriculturalControl;
    }

    public Boolean getIsGreenControl() {
        return isGreenControl;
    }

    public void setIsGreenControl(Boolean isGreenControl) {
        this.isGreenControl = isGreenControl;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getQuarantineLevel() {
        return quarantineLevel;
    }

    public void setQuarantineLevel(String quarantineLevel) {
        this.quarantineLevel = quarantineLevel;
    }

    public String getReportSource() {
        return reportSource;
    }

    public void setReportSource(String reportSource) {
        this.reportSource = reportSource;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }
}
