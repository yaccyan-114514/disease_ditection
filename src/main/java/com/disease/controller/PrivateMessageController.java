package com.disease.controller;

import com.disease.domain.Expert;
import com.disease.domain.Farmer;
import com.disease.domain.PrivateMessage;
import com.disease.mapper.ExpertMapper;
import com.disease.mapper.FarmerMapper;
import com.disease.service.PrivateMessageService;
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
@RequestMapping("/private-message")
public class PrivateMessageController {

    private final PrivateMessageService privateMessageService;
    private final FarmerMapper farmerMapper;
    private final ExpertMapper expertMapper;

    public PrivateMessageController(PrivateMessageService privateMessageService,
                                   FarmerMapper farmerMapper,
                                   ExpertMapper expertMapper) {
        this.privateMessageService = privateMessageService;
        this.farmerMapper = farmerMapper;
        this.expertMapper = expertMapper;
    }

    /**
     * 私信列表页面（显示所有对话）
     */
    @GetMapping("/list")
    public String messageList(Model model, HttpSession session) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        Expert expert = (Expert) session.getAttribute("currentExpert");
        
        if (farmer == null && expert == null) {
            return "redirect:/login";
        }
        
        Long userId = farmer != null ? farmer.getId() : expert.getId();
        String userType = farmer != null ? "farmer" : "expert";
        
        List<PrivateMessage> conversations = privateMessageService.getConversationList(userId, userType);
        int unreadCount = privateMessageService.countUnreadMessages(userId, userType);
        
        model.addAttribute("currentFarmer", farmer);
        model.addAttribute("currentExpert", expert);
        model.addAttribute("conversations", conversations);
        model.addAttribute("unreadCount", unreadCount);
        
        return "private_message_list";
    }

    /**
     * 与特定用户的私信对话页面
     */
    @GetMapping("/chat")
    public String chat(@RequestParam Long otherUserId,
                      @RequestParam String otherUserType,
                      Model model, HttpSession session) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        Expert expert = (Expert) session.getAttribute("currentExpert");
        
        if (farmer == null && expert == null) {
            return "redirect:/login";
        }
        
        Long userId = farmer != null ? farmer.getId() : expert.getId();
        String userType = farmer != null ? "farmer" : "expert";
        
        // 获取对方用户信息
        Object otherUser = null;
        if ("farmer".equals(otherUserType)) {
            otherUser = farmerMapper.findById(otherUserId);
        } else if ("expert".equals(otherUserType)) {
            otherUser = expertMapper.findById(otherUserId);
        }
        
        if (otherUser == null) {
            return "redirect:/private-message/list";
        }
        
        // 获取对话记录
        List<PrivateMessage> messages = privateMessageService.getConversation(
            userId, userType, otherUserId, otherUserType);
        
        // 标记为已读
        privateMessageService.markConversationAsRead(otherUserId, otherUserType, userId, userType);
        
        // 统计未读数
        int unreadCount = privateMessageService.countUnreadMessages(userId, userType);
        
        model.addAttribute("currentFarmer", farmer);
        model.addAttribute("currentExpert", expert);
        model.addAttribute("otherUser", otherUser);
        model.addAttribute("otherUserType", otherUserType);
        model.addAttribute("messages", messages);
        model.addAttribute("unreadCount", unreadCount);
        
        return "private_message_chat";
    }

    /**
     * 发送私信
     */
    @PostMapping("/send")
    public String sendMessage(@RequestParam Long receiverId,
                             @RequestParam String receiverType,
                             @RequestParam String content,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        Expert expert = (Expert) session.getAttribute("currentExpert");
        
        if (farmer == null && expert == null) {
            return "redirect:/login";
        }
        
        if (content == null || content.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "消息内容不能为空");
            return "redirect:/private-message/chat?otherUserId=" + receiverId + "&otherUserType=" + receiverType;
        }
        
        Long senderId = farmer != null ? farmer.getId() : expert.getId();
        String senderType = farmer != null ? "farmer" : "expert";
        
        try {
            privateMessageService.sendMessage(senderId, senderType, receiverId, receiverType, content.trim());
            redirectAttributes.addFlashAttribute("message", "消息发送成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "发送失败：" + e.getMessage());
        }
        
        return "redirect:/private-message/chat?otherUserId=" + receiverId + "&otherUserType=" + receiverType;
    }
}
