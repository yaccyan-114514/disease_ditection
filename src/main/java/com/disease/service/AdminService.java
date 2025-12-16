package com.disease.service;

import com.disease.domain.Admin;
import com.disease.mapper.AdminMapper;
import org.springframework.stereotype.Service;

@Service
public class AdminService {

    private final AdminMapper adminMapper;

    public AdminService(AdminMapper adminMapper) {
        this.adminMapper = adminMapper;
    }

    public Admin login(String usernameOrPhone, String password) {
        // 先尝试通过用户名查找
        Admin admin = adminMapper.findByUsername(usernameOrPhone);
        // 如果找不到，再尝试通过手机号查找
        if (admin == null) {
            admin = adminMapper.findByPhone(usernameOrPhone);
        }
        if (admin != null && admin.getPassword().equals(password)) {
            return admin;
        }
        return null;
    }

    public Admin findById(Long id) {
        return adminMapper.findById(id);
    }

    public int updateAdmin(Admin admin) {
        return adminMapper.updateAdmin(admin);
    }
}
