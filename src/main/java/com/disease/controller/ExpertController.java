package com.disease.controller;

import com.disease.domain.Expert;
import com.disease.domain.Question;
import com.disease.service.ExpertQuestionService;
import com.disease.service.ExpertService;
import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/expert")
public class ExpertController {

    private final ExpertQuestionService expertQuestionService;
    private final ServletContext servletContext;
    private final ExpertService expertService;

    public ExpertController(ExpertQuestionService expertQuestionService, ServletContext servletContext, ExpertService expertService) {
        this.expertQuestionService = expertQuestionService;
        this.servletContext = servletContext;
        this.expertService = expertService;
    }

    @GetMapping("")
    public String expertHome(@RequestParam(value = "userId", required = false) Long userId,
                             Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        
        // 获取专家帮扶的用户列表
        List<com.disease.domain.Farmer> helpedUsers = expertQuestionService.getHelpedUsers(expert.getId());
        
        // 如果指定了userId，获取该用户的对话记录
        List<Question> conversations = null;
        com.disease.domain.Farmer selectedUser = null;
        if (userId != null) {
            conversations = expertQuestionService.getConversationsByUserId(expert.getId(), userId);
            selectedUser = helpedUsers.stream()
                    .filter(u -> u.getId().equals(userId))
                    .findFirst()
                    .orElse(null);
        } else if (!helpedUsers.isEmpty()) {
            // 默认选择第一个用户
            selectedUser = helpedUsers.get(0);
            conversations = expertQuestionService.getConversationsByUserId(expert.getId(), selectedUser.getId());
        }
        
        model.addAttribute("currentExpert", expert);
        model.addAttribute("helpedUsers", helpedUsers);
        model.addAttribute("selectedUser", selectedUser);
        model.addAttribute("conversations", conversations != null ? conversations : new java.util.ArrayList<>());
        return "expert_home";
    }

    @GetMapping("/question")
    public String questionDetail(@RequestParam Long id, Model model, HttpSession session) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        
        Question question = expertQuestionService.getQuestionById(id);
        if (question == null) {
            return "redirect:/expert";
        }
        
        // 验证问题是否分配给该专家（通过answers表中的expert_id匹配）
        boolean isAssigned = question.getAnswers().stream()
                .anyMatch(answer -> answer.getExpertId() != null && answer.getExpertId().equals(expert.getId()));
        if (!isAssigned) {
            // 如果问题还没有分配给该专家，检查是否在问题列表中
            List<Question> assignedQuestions = expertQuestionService.getQuestionsByExpertId(expert.getId());
            boolean found = assignedQuestions.stream().anyMatch(q -> q.getId().equals(id));
            if (!found) {
                return "redirect:/expert";
            }
        }
        
        model.addAttribute("currentExpert", expert);
        model.addAttribute("question", question);
        return "expert_question_detail";
    }

    @PostMapping("/answer")
    public String submitAnswer(@RequestParam Long questionId,
                              @RequestParam String answerText,
                              @RequestParam(value = "image", required = false) MultipartFile image,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) throws IOException {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        
        if (answerText == null || answerText.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "请输入回答内容");
            Question question = expertQuestionService.getQuestionById(questionId);
            if (question != null && question.getUserId() != null) {
                return "redirect:/expert?userId=" + question.getUserId();
            }
            return "redirect:/expert/question?id=" + questionId;
        }
        
        String imagePath = null;
        if (image != null && !image.isEmpty()) {
            imagePath = storeImage(image);
        }
        
        expertQuestionService.answerQuestion(questionId, expert.getId(), answerText.trim(), imagePath);
        // 获取问题以获取userId，然后重定向到用户对话页面
        Question question = expertQuestionService.getQuestionById(questionId);
        if (question != null && question.getUserId() != null) {
            redirectAttributes.addFlashAttribute("message", "回答已提交");
            return "redirect:/expert?userId=" + question.getUserId();
        }
        redirectAttributes.addFlashAttribute("message", "回答已提交");
        return "redirect:/expert/question?id=" + questionId;
    }

    // 编辑个人信息
    @GetMapping("/profile/edit")
    public String editProfile(HttpSession session, Model model) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        // 从数据库重新获取最新信息
        expert = expertService.findById(expert.getId());
        model.addAttribute("expert", expert);
        return "expert_profile_edit";
    }

    @PostMapping("/profile/update")
    public String updateProfile(Expert expertForm,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        Expert expert = (Expert) session.getAttribute("currentExpert");
        if (expert == null) {
            return "redirect:/login";
        }
        
        // 从数据库获取最新信息
        Expert currentExpert = expertService.findById(expert.getId());
        
        // 更新字段
        currentExpert.setName(expertForm.getName());
        currentExpert.setGender(expertForm.getGender());
        currentExpert.setPhone(expertForm.getPhone());
        currentExpert.setEmail(expertForm.getEmail());
        currentExpert.setOrganization(expertForm.getOrganization());
        currentExpert.setTitle(expertForm.getTitle());
        currentExpert.setSpecialty(expertForm.getSpecialty());
        currentExpert.setBio(expertForm.getBio());
        
        // 如果提供了新密码，则更新密码
        if (expertForm.getPassword() != null && !expertForm.getPassword().trim().isEmpty()) {
            currentExpert.setPassword(expertForm.getPassword());
        }
        
        expertService.updateExpert(currentExpert);
        
        // 更新session中的专家信息
        session.setAttribute("currentExpert", currentExpert);
        
        redirectAttributes.addFlashAttribute("message", "个人信息更新成功");
        return "redirect:/expert";
    }

    private String storeImage(MultipartFile image) throws IOException {
        String uploads = servletContext.getRealPath("/uploads");
        if (uploads == null) {
            uploads = new File("uploads").getAbsolutePath();
        }
        File dir = new File(uploads);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        String extension = StringUtils.hasText(image.getOriginalFilename()) ?
                FilenameUtils.getExtension(image.getOriginalFilename()) : "jpg";
        String storedName = UUID.randomUUID().toString().replace("-", "") + "." + extension;
        File dest = new File(dir, storedName);
        image.transferTo(dest);
        return "/uploads/" + storedName;
    }
}

