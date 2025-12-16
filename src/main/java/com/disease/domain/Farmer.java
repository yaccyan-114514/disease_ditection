package com.disease.domain;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Farmer {
    private Long id;
    private String name;
    private String gender;
    private String phone;
    private String idCard;
    private String password;
    private String region;
    private String address;
    private BigDecimal farmSize;
    private String mainCrops;
    private Long expertId;
    private LocalDateTime createdAt;
    private String status;

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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public BigDecimal getFarmSize() {
        return farmSize;
    }

    public void setFarmSize(BigDecimal farmSize) {
        this.farmSize = farmSize;
    }

    public String getMainCrops() {
        return mainCrops;
    }

    public void setMainCrops(String mainCrops) {
        this.mainCrops = mainCrops;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getExpertId() {
        return expertId;
    }

    public void setExpertId(Long expertId) {
        this.expertId = expertId;
    }
}

