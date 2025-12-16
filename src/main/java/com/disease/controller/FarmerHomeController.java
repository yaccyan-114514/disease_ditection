package com.disease.controller;

import com.disease.domain.Farmer;
import com.disease.service.FarmerService;
import com.disease.service.FrameworkService;
import com.disease.service.WeatherService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/farmer")
public class FarmerHomeController {

    private final FrameworkService frameworkService;
    private final WeatherService weatherService;
    private final FarmerService farmerService;

    public FarmerHomeController(FrameworkService frameworkService, WeatherService weatherService, FarmerService farmerService) {
        this.frameworkService = frameworkService;
        this.weatherService = weatherService;
        this.farmerService = farmerService;
    }

    @GetMapping("/home")
    public String index(Model model, HttpSession session) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/login";
        }
        model.addAttribute("message", frameworkService.getFrameworkStatus());
        model.addAttribute("currentFarmer", farmer);
        model.addAttribute("weather", weatherService.currentWeather());
        return "index";
    }

    // 编辑个人信息
    @GetMapping("/profile/edit")
    public String editProfile(HttpSession session, Model model) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/login";
        }
        // 从数据库重新获取最新信息
        farmer = farmerService.findById(farmer.getId());
        model.addAttribute("farmer", farmer);
        return "farmer_profile_edit";
    }

    @PostMapping("/profile/update")
    public String updateProfile(Farmer farmerForm,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/login";
        }
        
        // 从数据库获取最新信息
        Farmer currentFarmer = farmerService.findById(farmer.getId());
        
        // 更新字段
        currentFarmer.setName(farmerForm.getName());
        currentFarmer.setGender(farmerForm.getGender());
        currentFarmer.setPhone(farmerForm.getPhone());
        currentFarmer.setIdCard(farmerForm.getIdCard());
        currentFarmer.setRegion(farmerForm.getRegion());
        currentFarmer.setAddress(farmerForm.getAddress());
        currentFarmer.setFarmSize(farmerForm.getFarmSize());
        currentFarmer.setMainCrops(farmerForm.getMainCrops());
        
        // 如果提供了新密码，则更新密码
        if (farmerForm.getPassword() != null && !farmerForm.getPassword().trim().isEmpty()) {
            currentFarmer.setPassword(farmerForm.getPassword());
        }
        
        farmerService.updateFarmer(currentFarmer);
        
        // 更新session中的农户信息
        session.setAttribute("currentFarmer", currentFarmer);
        
        redirectAttributes.addFlashAttribute("message", "个人信息更新成功");
        return "redirect:/farmer/home";
    }
}

