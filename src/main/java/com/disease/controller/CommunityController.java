package com.disease.controller;

import com.disease.domain.Farmer;
import com.disease.service.CommunityService;
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
import java.util.UUID;

@Controller
@RequestMapping("/farmer/community")
public class CommunityController {

    private final CommunityService communityService;
    private final ServletContext servletContext;

    public CommunityController(CommunityService communityService, ServletContext servletContext) {
        this.communityService = communityService;
        this.servletContext = servletContext;
    }

    @GetMapping
    public String list(Model model, HttpSession session) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("currentFarmer", farmer);
        model.addAttribute("posts", communityService.latestPosts());
        return "community";
    }

    @PostMapping("/post")
    public String createPost(@RequestParam String title,
                            @RequestParam String content,
                            @RequestParam(value = "image", required = false) MultipartFile image,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) throws IOException {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/login";
        }
        
        if (title == null || title.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "请输入标题");
            return "redirect:/farmer/community";
        }
        
        if (content == null || content.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "请输入内容");
            return "redirect:/farmer/community";
        }
        
        String imagePath = null;
        if (image != null && !image.isEmpty()) {
            imagePath = storeImage(image);
        }
        
        try {
            communityService.createPost(farmer.getId(), title.trim(), content.trim(), imagePath);
            redirectAttributes.addFlashAttribute("message", "发布成功！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "发布失败：" + e.getMessage());
        }
        
        return "redirect:/farmer/community";
    }

    @PostMapping("/comment")
    public String addComment(@RequestParam Long postId,
                            @RequestParam String content,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            return "redirect:/login";
        }
        
        if (content == null || content.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "请输入评论内容");
            return "redirect:/farmer/community";
        }
        
        try {
            communityService.addComment(postId, farmer.getId(), content.trim());
            redirectAttributes.addFlashAttribute("message", "评论成功！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "评论失败：" + e.getMessage());
        }
        
        return "redirect:/farmer/community";
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

