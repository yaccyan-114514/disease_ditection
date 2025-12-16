package com.disease.domain;

import java.time.LocalDateTime;

public class Pesticide {
    private Long id;
    private String name;
    private String composition;
    private String toxicityLevel;
    private String safeInterval;
    private String dilutionRatio;
    private String usageMethod;
    private String approvalNumber;
    private LocalDateTime createdAt;

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

    public String getComposition() {
        return composition;
    }

    public void setComposition(String composition) {
        this.composition = composition;
    }

    public String getToxicityLevel() {
        return toxicityLevel;
    }

    public void setToxicityLevel(String toxicityLevel) {
        this.toxicityLevel = toxicityLevel;
    }

    public String getSafeInterval() {
        return safeInterval;
    }

    public void setSafeInterval(String safeInterval) {
        this.safeInterval = safeInterval;
    }

    public String getDilutionRatio() {
        return dilutionRatio;
    }

    public void setDilutionRatio(String dilutionRatio) {
        this.dilutionRatio = dilutionRatio;
    }

    public String getUsageMethod() {
        return usageMethod;
    }

    public void setUsageMethod(String usageMethod) {
        this.usageMethod = usageMethod;
    }

    public String getApprovalNumber() {
        return approvalNumber;
    }

    public void setApprovalNumber(String approvalNumber) {
        this.approvalNumber = approvalNumber;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
