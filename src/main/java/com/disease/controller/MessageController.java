package com.disease.controller;

import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import com.disease.service.MessageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/message")
public class MessageController {

    private final MessageService messageService;

    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    /**
     * 获取未读消息数量（AJAX接口）
     */
    @GetMapping("/unread/count")
    public String getUnreadCount(HttpSession session, Model model) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        Expert expert = (Expert) session.getAttribute("currentExpert");
        
        int count = 0;
        if (farmer != null) {
            count = messageService.countUnreadMessages(farmer.getId(), "farmer");
        } else if (expert != null) {
            count = messageService.countUnreadMessages(expert.getId(), "expert");
        }
        
        model.addAttribute("count", count);
        return "json"; // 需要配置JSON视图
    }

    /**
     * 标记消息为已读
     */
    @PostMapping("/read")
    public String markAsRead(@RequestParam Long messageId, HttpSession session, RedirectAttributes redirectAttributes) {
        messageService.markAsRead(messageId);
        redirectAttributes.addFlashAttribute("message", "消息已标记为已读");
        return "redirect:/expert/qa";
    }

    /**
     * 标记所有消息为已读
     */
    @PostMapping("/read/all")
    public String markAllAsRead(HttpSession session, RedirectAttributes redirectAttributes) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        Expert expert = (Expert) session.getAttribute("currentExpert");
        
        if (farmer != null) {
            messageService.markAllAsRead(farmer.getId(), "farmer");
        } else if (expert != null) {
            messageService.markAllAsRead(expert.getId(), "expert");
        }
        
        redirectAttributes.addFlashAttribute("message", "所有消息已标记为已读");
        return "redirect:/expert/qa";
    }
}
