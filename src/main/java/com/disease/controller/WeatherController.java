package com.disease.controller;

import com.disease.domain.WeatherInfo;
import com.disease.service.WeatherService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/weather")
public class WeatherController {

    private final WeatherService weatherService;

    public WeatherController(WeatherService weatherService) {
        this.weatherService = weatherService;
    }

    /**
     * 查询指定城市的天气信息
     * @param city 城市adcode，例如：310000（上海市）
     * @param extension 气象类型：base（实况天气）或 all（预报天气），默认为 all
     * @return 天气信息
     */
    @GetMapping("/query")
    public ResponseEntity<?> queryWeather(
            @RequestParam(value = "city", defaultValue = "310000") String city,
            @RequestParam(value = "extension", defaultValue = "all") String extension) {
        try {
            WeatherInfo weather = weatherService.getWeatherByCity(city, extension);
            return ResponseEntity.ok(weather);
        } catch (Exception e) {
            e.printStackTrace();
            java.util.Map<String, Object> errorResponse = new java.util.HashMap<>();
            errorResponse.put("status", "0");
            errorResponse.put("info", "查询失败");
            errorResponse.put("infocode", "500");
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    /**
     * 获取当前定位城市的天气信息（自动定位）
     * @return 天气信息
     */
    @GetMapping("/current")
    public ResponseEntity<WeatherInfo> getCurrentWeather() {
        WeatherInfo weather = weatherService.currentWeather();
        return ResponseEntity.ok(weather);
    }
}
