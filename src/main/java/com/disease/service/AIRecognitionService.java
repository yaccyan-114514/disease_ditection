package com.disease.service;

import com.disease.domain.AIRecord;
import com.disease.mapper.AIRecordMapper;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Service
public class AIRecognitionService {

    private static final List<String> MOCK_RESULTS = Arrays.asList(
            "水稻稻瘟病", "小麦白粉病", "玉米大斑病", "茶小绿叶蝉", "棉铃虫", "番茄早疫病", "黄瓜霜霉病"
    );

    private final AIRecordMapper aiRecordMapper;
    private final Random random = new Random();

    public AIRecognitionService(AIRecordMapper aiRecordMapper) {
        this.aiRecordMapper = aiRecordMapper;
    }

    public AIRecord recognize(Long userId, Long cropId, String imagePath) {
        String result = MOCK_RESULTS.get(random.nextInt(MOCK_RESULTS.size()));
        AIRecord record = new AIRecord();
        record.setUserId(userId);
        record.setCropId(cropId);
        record.setImageUrl(imagePath);
        record.setAiResult(result);
        record.setFinalResult(result);
        aiRecordMapper.insert(record);
        return record;
    }
}

