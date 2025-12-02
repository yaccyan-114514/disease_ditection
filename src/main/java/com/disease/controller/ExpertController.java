package com.disease.controller;

import com.disease.domain.Farmer;
import com.disease.domain.Question;
import com.disease.service.ExpertConsultService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/expert")
public class ExpertController {

    private final ExpertConsultService consultService;

    public ExpertController(ExpertConsultService consultService) {
        this.consultService = consultService;
    }

    @GetMapping("/qa")
    public String qaPage(Model model) {
        model.addAttribute("questions", consultService.latestQuestions(10));
        return "expert_qa";
    }

    @PostMapping("/question")
    public String submitQuestion(@RequestParam("questionText") String questionText,
                                 @RequestParam(value = "cropId", required = false) Long cropId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            redirectAttributes.addFlashAttribute("error", "请先登录");
            return "redirect:/farmer/login";
        }
        if (questionText == null || questionText.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "请描述问题");
            return "redirect:/expert/qa";
        }
        Question question = consultService.submitQuestion(farmer.getId(), cropId, questionText.trim());
        redirectAttributes.addFlashAttribute("message", "已成功提交，系统为您匹配的专家正在处理。");
        redirectAttributes.addFlashAttribute("newQuestion", question);
        return "redirect:/expert/qa";
    }
}

