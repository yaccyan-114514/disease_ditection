package com.disease.controller;

import com.disease.domain.Farmer;
import com.disease.service.FarmerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/farmer")
public class AuthController {

    private final FarmerService farmerService;

    public AuthController(FarmerService farmerService) {
        this.farmerService = farmerService;
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String phone,
                          @RequestParam String password,
                          RedirectAttributes redirectAttributes,
                          HttpSession session) {
        Farmer farmer = farmerService.login(phone, password);
        if (farmer == null) {
            redirectAttributes.addFlashAttribute("error", "手机号或密码错误");
            return "redirect:/farmer/login";
        }
        session.setAttribute("currentFarmer", farmer);
        return "redirect:/home";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String doRegister(Farmer farmer,
                             RedirectAttributes redirectAttributes) {
        try {
            farmerService.register(farmer);
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/farmer/register";
        }
        redirectAttributes.addFlashAttribute("message", "注册成功，请登录");
        return "redirect:/farmer/login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/home";
    }
}

