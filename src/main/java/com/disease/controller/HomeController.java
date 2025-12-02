package com.disease.controller;

import com.disease.domain.Farmer;
import com.disease.service.FrameworkService;
import com.disease.service.WeatherService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

@Controller
public class HomeController {

    private final FrameworkService frameworkService;
    private final WeatherService weatherService;

    public HomeController(FrameworkService frameworkService, WeatherService weatherService) {
        this.frameworkService = frameworkService;
        this.weatherService = weatherService;
    }

    @GetMapping({"", "/", "/home"})
    public String index(Model model, HttpSession session) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/farmer/login";
        }
        model.addAttribute("message", frameworkService.getFrameworkStatus());
        model.addAttribute("currentFarmer", farmer);
        model.addAttribute("weather", weatherService.currentWeather());
        return "index";
    }
}

