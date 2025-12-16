package com.disease.controller;

import com.disease.domain.AIRecord;
import com.disease.domain.Farmer;
import com.disease.service.AIRecognitionService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/ai")
public class AIController {

    private final AIRecognitionService recognitionService;
    private final ServletContext servletContext;
    private final ObjectMapper objectMapper;
    
    @Value("${ai.service.url:http://localhost:5000}")
    private String aiServiceUrl;

    public AIController(AIRecognitionService recognitionService, ServletContext servletContext) {
        this.recognitionService = recognitionService;
        this.servletContext = servletContext;
        this.objectMapper = new ObjectMapper();
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
            return "redirect:/login";
        }
        if (image == null || image.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "请上传农作物照片");
            return "redirect:/ai";
        }
        String fileName = storeImage(image);
        AIRecord record = recognitionService.recognize(farmer.getId(), cropId, fileName);
        redirectAttributes.addFlashAttribute("record", record);
        redirectAttributes.addFlashAttribute("imagePath", fileName);
        
        // 保存识别结果的 JSON 到 session，供流式输出使用
        try {
            Map<String, Object> resultJson = recognitionService.getLastPredictionResult();
            if (resultJson != null) {
                // 构建完整的识别结果 JSON（包含 result 字段）
                Map<String, Object> fullResult = new HashMap<>();
                fullResult.put("success", true);
                fullResult.put("result", resultJson);
                session.setAttribute("lastPredictionJson", objectMapper.writeValueAsString(fullResult));
            }
        } catch (Exception e) {
            System.err.println("保存预测结果到 session 失败: " + e.getMessage());
        }
        
        return "redirect:/ai";
    }
    
    @GetMapping("/explain")
    public void explain(HttpSession session, HttpServletResponse response) throws IOException {
        Farmer farmer = (Farmer) session.getAttribute("currentFarmer");
        if (farmer == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "请先登录");
            return;
        }
        
        String jsonStr = (String) session.getAttribute("lastPredictionJson");
        if (jsonStr == null || jsonStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "没有可用的识别结果");
            return;
        }
        
        // 设置响应头为 Server-Sent Events
        response.setContentType("text/event-stream");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Connection", "keep-alive");
        response.setHeader("X-Accel-Buffering", "no");
        
        try {
            // 调用 Python API 的 /explain 接口（使用 HttpURLConnection 支持流式）
            String url = aiServiceUrl + "/explain";
            System.out.println("[AIController] 调用 Qwen3 解释接口");
            System.out.println("[AIController] aiServiceUrl 配置值: " + aiServiceUrl);
            System.out.println("[AIController] 完整 URL: " + url);
            
            URL apiUrl = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) apiUrl.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            connection.setRequestProperty("Accept", "text/event-stream");
            connection.setRequestProperty("Connection", "keep-alive");
            connection.setDoOutput(true);
            connection.setDoInput(true);
            connection.setConnectTimeout(30000);  // 30秒连接超时
            connection.setReadTimeout(60000);     // 60秒读取超时
            
            // 发送请求体
            Map<String, Object> requestBody = new HashMap<>();
            Map<String, Object> resultMap = objectMapper.readValue(jsonStr, Map.class);
            requestBody.put("result_json", resultMap);
            String requestBodyStr = objectMapper.writeValueAsString(requestBody);
            
            System.out.println("[AIController] 请求体: " + requestBodyStr.substring(0, Math.min(200, requestBodyStr.length())) + "...");
            
            try (java.io.OutputStream os = connection.getOutputStream()) {
                byte[] input = requestBodyStr.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
                os.flush();
            }
            
            // 检查响应码
            int responseCode = connection.getResponseCode();
            System.out.println("[AIController] Python API 响应码: " + responseCode);
            
            if (responseCode != HttpURLConnection.HTTP_OK) {
                // 读取错误信息
                try (BufferedReader errorReader = new BufferedReader(
                        new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {
                    StringBuilder errorResponse = new StringBuilder();
                    String errorLine;
                    while ((errorLine = errorReader.readLine()) != null) {
                        errorResponse.append(errorLine);
                    }
                    throw new RuntimeException("Python API 返回错误: " + responseCode + ", " + errorResponse.toString());
                }
            }
            
            // 读取流式响应
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                java.io.PrintWriter writer = response.getWriter();
                while ((line = reader.readLine()) != null) {
                    if (line.startsWith("data: ")) {
                        writer.write(line + "\n");
                        writer.flush();
                        if (line.contains("[DONE]")) {
                            break;
                        }
                    }
                }
            }
        } catch (Exception e) {
            response.getWriter().write("data: {\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}\n\n");
            response.getWriter().flush();
        }
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

