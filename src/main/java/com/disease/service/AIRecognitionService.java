package com.disease.service;

import com.disease.domain.AIRecord;
import com.disease.mapper.AIRecordMapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.lang.NonNull;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.ServletContextAware;

import javax.servlet.ServletContext;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

@Service
public class AIRecognitionService implements ServletContextAware {

    private final AIRecordMapper aiRecordMapper;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;
    private ServletContext servletContext;
    
    // 保存最后一次预测结果
    private Map<String, Object> lastPredictionResult = null;
    
    @Value("${ai.service.url:http://localhost:5000}")
    private String aiServiceUrl;
    
    @Value("${ai.service.enabled:true}")
    private boolean aiServiceEnabled;

    public AIRecognitionService(AIRecordMapper aiRecordMapper, RestTemplate restTemplate) {
        this.aiRecordMapper = aiRecordMapper;
        this.restTemplate = restTemplate;
        this.objectMapper = new ObjectMapper();
    }
    
    public Map<String, Object> getLastPredictionResult() {
        return lastPredictionResult;
    }
    
    @Override
    public void setServletContext(@NonNull ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    public AIRecord recognize(Long userId, Long cropId, String imagePath) {
        AIRecord record = new AIRecord();
        record.setUserId(userId);
        record.setCropId(cropId);
        record.setImageUrl(imagePath);
        
        String aiResult;
        String finalResult;
        
        if (aiServiceEnabled) {
            try {
                // 调用 Python AI 服务
                Map<String, Object> predictionResult = callAIService(imagePath);
                
                if (predictionResult != null && predictionResult.containsKey("disease")) {
                    // 保存完整的预测结果供 Qwen3 使用
                    lastPredictionResult = predictionResult;
                    
                    String crop = predictionResult.containsKey("crop") ? 
                        (String) predictionResult.get("crop") : "";
                    String diseaseName = predictionResult.containsKey("disease_name") ? 
                        (String) predictionResult.get("disease_name") : "";
                    Double confidence = (Double) predictionResult.get("confidence");
                    String description = predictionResult.containsKey("description") ? 
                        (String) predictionResult.get("description") : "";
                    
                    // 格式化识别结果
                    if (diseaseName != null && !diseaseName.isEmpty()) {
                        aiResult = String.format("%s - %s (置信度: %.2f%%)", 
                            crop, diseaseName, confidence * 100);
                        finalResult = String.format("作物: %s\n病害: %s\n置信度: %.2f%%\n\n%s", 
                            crop, diseaseName, confidence * 100, description);
                    } else {
                        // 健康状态
                        aiResult = String.format("%s - 健康 (置信度: %.2f%%)", 
                            crop, confidence * 100);
                        finalResult = String.format("作物: %s\n状态: 健康\n置信度: %.2f%%", 
                            crop, confidence * 100);
                    }
                    
                    // 如果有其他预测结果（Top 5），也可以显示
                    if (predictionResult.containsKey("all_predictions")) {
                        @SuppressWarnings("unchecked")
                        java.util.List<Map<String, Object>> allPredictions = 
                            (java.util.List<Map<String, Object>>) predictionResult.get("all_predictions");
                        if (allPredictions != null && allPredictions.size() > 1) {
                            finalResult += "\n\n其他可能结果:\n";
                            for (int i = 1; i < Math.min(allPredictions.size(), 4); i++) {
                                Map<String, Object> pred = allPredictions.get(i);
                                String pCrop = (String) pred.get("crop");
                                String pDisease = (String) pred.get("disease");
                                Double pConf = (Double) pred.get("confidence");
                                finalResult += String.format("%d. %s - %s (%.2f%%)\n", 
                                    i, pCrop, pDisease.isEmpty() ? "健康" : pDisease, pConf * 100);
                            }
                        }
                    }
                } else {
                    throw new RuntimeException("AI服务返回结果格式错误");
                }
            } catch (Exception e) {
                System.err.println("[AIRecognitionService] 调用AI服务失败: " + e.getMessage());
                e.printStackTrace();
                // 降级到模拟结果
                aiResult = "识别失败，请稍后重试";
                finalResult = "AI服务暂时不可用: " + e.getMessage();
            }
        } else {
            // 使用模拟结果
            aiResult = "模拟结果: 水稻稻瘟病";
            finalResult = "模拟识别结果（AI服务未启用）";
        }
        
        record.setAiResult(aiResult);
        
        // 限制 final_result 长度，避免数据库字段溢出
        // 数据库字段是 varchar(200)，保留一些余量
        int maxLength = 300;  // 留10个字符的余量
        if (finalResult != null && finalResult.length() > maxLength) {
            finalResult = finalResult.substring(0, maxLength) + "...";
        }
        
        record.setFinalResult(finalResult);
        aiRecordMapper.insert(record);
        return record;
    }

    /**
     * 调用 Python AI 服务进行预测
     * 
     * @param imagePath 图片路径（相对于webapp根目录，如 /uploads/xxx.jpg）
     * @return 预测结果 Map
     */
    private Map<String, Object> callAIService(String imagePath) throws Exception {
        // 获取图片的绝对路径
        String realPath = getImageRealPath(imagePath);
        File imageFile = new File(realPath);
        
        if (!imageFile.exists()) {
            throw new RuntimeException("图片文件不存在: " + realPath);
        }
        
        // 准备请求
        String url = aiServiceUrl + "/predict";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        FileSystemResource resource = new FileSystemResource(imageFile);
        body.add("image", resource);
        
        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
        
        // 发送请求
        ResponseEntity<String> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                requestEntity,
                String.class
        );
        
        if (response.getStatusCode() == HttpStatus.OK) {
            // 解析响应
            JsonNode jsonNode = objectMapper.readTree(response.getBody());
            
            if (jsonNode.has("success") && jsonNode.get("success").asBoolean()) {
                JsonNode resultNode = jsonNode.get("result");
                
                Map<String, Object> result = new HashMap<>();
                
                // 解析病害信息
                String disease = resultNode.has("disease") ? 
                    resultNode.get("disease").asText() : "未知";
                String crop = resultNode.has("crop") ? 
                    resultNode.get("crop").asText() : "";
                String diseaseName = resultNode.has("disease_name") ? 
                    resultNode.get("disease_name").asText() : "";
                double confidence = resultNode.has("confidence") ? 
                    resultNode.get("confidence").asDouble() : 0.0;
                
                result.put("disease", disease);
                result.put("crop", crop);
                result.put("disease_name", diseaseName);
                result.put("confidence", confidence);
                
                // 构建描述信息
                String description = String.format("%s - %s (置信度: %.2f%%)", 
                    crop, diseaseName.isEmpty() ? "健康" : diseaseName, confidence * 100);
                result.put("description", description);
                
                // 如果有其他预测结果，也可以包含
                if (resultNode.has("all_predictions")) {
                    java.util.List<Map<String, Object>> allPredictions = new java.util.ArrayList<>();
                    resultNode.get("all_predictions").forEach(node -> {
                        Map<String, Object> pred = new HashMap<>();
                        if (node.has("crop")) pred.put("crop", node.get("crop").asText());
                        if (node.has("disease")) pred.put("disease", node.get("disease").asText());
                        if (node.has("confidence")) pred.put("confidence", node.get("confidence").asDouble());
                        allPredictions.add(pred);
                    });
                    result.put("all_predictions", allPredictions);
                }
                
                return result;
            } else {
                String error = jsonNode.has("error") ? 
                    jsonNode.get("error").asText() : "未知错误";
                throw new RuntimeException("AI服务返回错误: " + error);
            }
        } else {
            throw new RuntimeException("AI服务请求失败，状态码: " + response.getStatusCode());
        }
    }

    /**
     * 获取图片的绝对路径
     */
    private String getImageRealPath(String imagePath) {
        // imagePath 格式: /uploads/xxx.jpg
        // 需要转换为实际文件系统路径
        
        if (servletContext != null) {
            // 优先使用 ServletContext 获取真实路径
            String realPath = servletContext.getRealPath(imagePath);
            if (realPath != null) {
                File file = new File(realPath);
                if (file.exists()) {
                    return realPath;
                }
            }
        }
        
        // 降级方案：尝试从多个可能的位置查找
        if (imagePath.startsWith("/uploads/")) {
            String[] possiblePaths = {
                System.getProperty("catalina.base") + "/webapps/disease_ditection" + imagePath,
                System.getProperty("user.dir") + "/target/disease_ditection" + imagePath,
                System.getProperty("user.dir") + "/src/main/webapp" + imagePath,
                System.getProperty("user.dir") + imagePath
            };
            
            for (String path : possiblePaths) {
                File file = new File(path);
                if (file.exists()) {
                    return path;
                }
            }
        }
        
        // 如果找不到，返回原始路径
        return imagePath;
    }
}

