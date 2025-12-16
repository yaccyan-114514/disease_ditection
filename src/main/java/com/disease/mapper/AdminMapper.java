package com.disease.mapper;

import com.disease.domain.Admin;
import org.apache.ibatis.annotations.Param;

public interface AdminMapper {
    Admin findByUsername(@Param("username") String username);
    
    Admin findByPhone(@Param("phone") String phone);
    
    Admin findById(@Param("id") Long id);
    
    int updateAdmin(Admin admin);
}
