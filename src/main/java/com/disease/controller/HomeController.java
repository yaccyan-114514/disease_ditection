package com.disease.controller;

import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

@Controller
public class HomeController {

    @GetMapping({"", "/", "/home"})
    public String index(HttpSession session) {
        // 根据用户类型跳转
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        Expert expert = (Expert) session.getAttribute("currentExpert");
        
        if (farmer != null) {
            return "redirect:/farmer/home";
        } else if (expert != null) {
            return "redirect:/expert";
        } else {
            return "redirect:/login";
        }
    }
}

