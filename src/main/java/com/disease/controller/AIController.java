package com.disease.controller;

import com.disease.domain.AIRecord;
import com.disease.domain.Farmer;
import com.disease.service.AIRecognitionService;
import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Controller;
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
@RequestMapping("/ai")
public class AIController {

    private final AIRecognitionService recognitionService;
    private final ServletContext servletContext;

    public AIController(AIRecognitionService recognitionService, ServletContext servletContext) {
        this.recognitionService = recognitionService;
        this.servletContext = servletContext;
    }

    @GetMapping
    public String uploadPage() {
        return "ai_recognition";
    }

    @PostMapping("/recognize")
    public String recognize(@RequestParam("image") MultipartFile image,
                            @RequestParam(value = "cropId", required = false) Long cropId,
                            RedirectAttributes redirectAttributes,
                            HttpSession session) throws IOException {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            redirectAttributes.addFlashAttribute("error", "请先登录");
            return "redirect:/farmer/login";
        }
        if (image == null || image.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "请上传农作物照片");
            return "redirect:/ai";
        }
        String fileName = storeImage(image);
        AIRecord record = recognitionService.recognize(farmer.getId(), cropId, fileName);
        redirectAttributes.addFlashAttribute("record", record);
        redirectAttributes.addFlashAttribute("imagePath", fileName);
        return "redirect:/ai";
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

