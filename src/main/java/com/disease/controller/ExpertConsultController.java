package com.disease.controller;

import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import com.disease.domain.Question;
import com.disease.mapper.ExpertMapper;
import com.disease.mapper.FarmerMapper;
import com.disease.service.ExpertConsultService;
import com.disease.service.MessageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/expert")
public class ExpertConsultController {

    private final ExpertConsultService expertConsultService;
    private final FarmerMapper farmerMapper;
    private final ExpertMapper expertMapper;
    private final MessageService messageService;

    public ExpertConsultController(ExpertConsultService expertConsultService,
                                   FarmerMapper farmerMapper,
                                   ExpertMapper expertMapper,
                                   MessageService messageService) {
        this.expertConsultService = expertConsultService;
        this.farmerMapper = farmerMapper;
        this.expertMapper = expertMapper;
        this.messageService = messageService;
    }

    @GetMapping("/qa")
    public String qaPage(Model model, HttpSession session) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/login";
        }
        
        // 重新加载农户信息以获取expert_id
        farmer = farmerMapper.findById(farmer.getId());
        if (farmer == null) {
            return "redirect:/login";
        }
        
        // 获取分配给的专家信息
        Expert assignedExpert = null;
        if (farmer.getExpertId() != null) {
            assignedExpert = expertMapper.findById(farmer.getExpertId());
        }
        
        // 获取该农户的所有对话记录
        List<Question> conversations = expertConsultService.getConversationsByFarmerId(farmer.getId());
        
        // 获取未读消息数量
        int unreadCount = messageService.countUnreadMessages(farmer.getId(), "farmer");
        
        // 获取所有消息（用于标记已读/未读）
        List<com.disease.domain.Message> messages = messageService.getMessagesByUser(farmer.getId(), "farmer");
        
        model.addAttribute("currentFarmer", farmer);
        model.addAttribute("assignedExpert", assignedExpert);
        model.addAttribute("conversations", conversations);
        model.addAttribute("unreadCount", unreadCount);
        model.addAttribute("messages", messages);
        return "expert_qa";
    }

    @PostMapping("/qa")
    public String submitQuestion(@RequestParam(value = "cropId", required = false) Long cropId,
                                 @RequestParam String questionText,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/login";
        }
        
        // 重新加载农户信息以获取expert_id
        farmer = farmerMapper.findById(farmer.getId());
        if (farmer == null) {
            return "redirect:/login";
        }
        
        if (questionText == null || questionText.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "请输入问题内容");
            return "redirect:/expert/qa";
        }
        
        try {
            expertConsultService.submitQuestion(farmer.getId(), cropId, questionText.trim(), farmer.getExpertId());
            redirectAttributes.addFlashAttribute("message", "问题已提交，专家将尽快回复");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "提交失败：" + e.getMessage());
        }
        
        return "redirect:/expert/qa";
    }
}

