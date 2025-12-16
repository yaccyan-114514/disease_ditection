package com.disease.controller;

import com.disease.domain.Admin;
import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import com.disease.service.AdminService;
import com.disease.service.ExpertService;
import com.disease.service.FarmerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    private final FarmerService farmerService;
    private final ExpertService expertService;
    private final AdminService adminService;

    public AuthController(FarmerService farmerService, ExpertService expertService, AdminService adminService) {
        this.farmerService = farmerService;
        this.expertService = expertService;
        this.adminService = adminService;
    }

    @GetMapping({"/login", "/farmer/login"})
    public String loginPage(@RequestParam(required = false) String error, 
                           org.springframework.ui.Model model) {
        if (error != null && !error.isEmpty()) {
            model.addAttribute("error", error);
        }
        return "login";
    }

    @PostMapping({"/login", "/farmer/login"})
    public String doLogin(@RequestParam String phone,
                          @RequestParam String password,
                          RedirectAttributes redirectAttributes,
                          HttpSession session,
                          javax.servlet.http.HttpServletRequest request) {
        // 先尝试作为管理员登录（支持用户名或手机号）
        Admin admin = adminService.login(phone, password);
        if (admin != null) {
            session.setAttribute("currentAdmin", admin);
            session.removeAttribute("currentFarmer");
            session.removeAttribute("currentExpert");
            // 保存登录IP地址
            saveLoginIp(session, request);
            return "redirect:/admin/dashboard";
        }
        
        // 再尝试作为农民登录
        Farmer farmer = farmerService.login(phone, password);
        if (farmer != null) {
            session.setAttribute("currentFarmer", farmer);
            session.removeAttribute("currentExpert");
            session.removeAttribute("currentAdmin");
            // 保存登录IP地址
            saveLoginIp(session, request);
            return "redirect:/farmer/home";
        }
        
        // 最后尝试作为专家登录
        Expert expert = expertService.login(phone, password);
        if (expert != null) {
            session.setAttribute("currentExpert", expert);
            session.removeAttribute("currentFarmer");
            session.removeAttribute("currentAdmin");
            // 保存登录IP地址
            saveLoginIp(session, request);
            return "redirect:/expert";
        }
        
        redirectAttributes.addFlashAttribute("error", "手机号或密码错误");
        return "redirect:/login";
    }

    /**
     * 保存登录IP地址到session
     */
    private void saveLoginIp(HttpSession session, javax.servlet.http.HttpServletRequest request) {
        String ip = getClientIpAddress(request);
        session.setAttribute("userIpAddress", ip);
    }

    /**
     * 获取客户端真实IP地址
     */
    private String getClientIpAddress(javax.servlet.http.HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        
        // 如果IP地址包含多个（通过代理），取第一个
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        
        return ip != null ? ip : "unknown";
    }

    @GetMapping("/farmer/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/farmer/register")
    public String doRegister(Farmer farmer,
                             RedirectAttributes redirectAttributes) {
        try {
            farmerService.register(farmer);
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/farmer/register";
        }
        redirectAttributes.addFlashAttribute("message", "注册成功，请登录");
        return "redirect:/login";
    }

    @GetMapping({"/logout", "/farmer/logout"})
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}

