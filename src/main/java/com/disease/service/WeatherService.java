package com.disease.service;

import com.disease.domain.WeatherInfo;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
public class WeatherService {

    private static final String GAODE_KEY = "fd8a6873805d788fc54ff85029e4b177";
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 获取主界面显示的天气信息（固定为上海市）
     * @return 上海市的天气信息
     */
    public WeatherInfo currentWeather() {
        try {
            System.out.println("[WeatherService] currentWeather() 开始调用，固定查询上海市(310000)");
            // 固定使用上海市的天气，不再自动定位
            WeatherInfo result = getWeatherByCity("310000", "all");
            System.out.println("[WeatherService] currentWeather() 成功返回，城市=" + result.getCity() + ", 温度=" + result.getTemperature());
            return result;
        } catch (Exception e) {
            System.out.println("[WeatherService] currentWeather() 发生异常: " + e.getMessage());
            e.printStackTrace();
            // 如果查询失败，返回上海市的默认天气信息
            System.out.println("[WeatherService] 返回fallback默认数据");
            WeatherInfo fallback = new WeatherInfo();
            fallback.setCity("上海市");
            fallback.setProvince("上海市");
            fallback.setCountry("中国");
            fallback.setRegion("310000");
            fallback.setAdcode("310000");
            fallback.setTemperature(24.0);
            fallback.setWindspeed(3.0);
            fallback.setWindpower("3级");
            fallback.setWindDirection("东南风");
            fallback.setHumidity("60%");
            fallback.setDescription("晴朗");
            fallback.setBackgroundStyle(gradientFor(24.0, "晴朗"));
            return fallback;
        }
    }

    /**
     * 根据城市adcode查询天气信息
     * @param cityAdcode 城市adcode，例如：310000（上海市）
     * @param extension 气象类型：base（实况天气）或 all（预报天气），默认为 all
     * @return 天气信息
     */
    public WeatherInfo getWeatherByCity(String cityAdcode, String extension) {
        try {
            // 验证extension参数
            if (!"base".equals(extension) && !"all".equals(extension)) {
                extension = "all";
            }
            
            String weatherApiUrl = "https://restapi.amap.com/v3/weather/weatherInfo?key={key}&city={city}&extensions={extension}&output=json";
            Map<?, ?> weather = requestForMapWithExtension(weatherApiUrl, cityAdcode, extension);
            
            // 检查API返回状态
            String status = stringValue(weather, "status", "0");
            if ("0".equals(status)) {
                String info = stringValue(weather, "info", "查询失败");
                throw new RuntimeException("高德API返回错误: " + info);
            }
            
            // 当extensions=all时，API只返回forecasts，没有lives
            // 需要同时查询base获取实况数据，或者从forecasts[0].casts[0]提取（第一天的预报数据）
            Map<?, ?> live;
            List<WeatherInfo.ForecastDay> forecastDays = Collections.emptyList();
            
            if ("all".equals(extension)) {
                // all模式：先提取预报数据
                forecastDays = extractForecasts(weather);
                System.out.println("[WeatherService] 提取的预报数据数量: " + forecastDays.size());
                
                // 方法1：尝试从lives提取（如果API返回了lives）
                live = extractLive(weather);
                
                // 方法2：如果lives为空，从forecasts[0].casts[0]提取（第一天的预报数据作为实况）
                if (live == null || live.isEmpty()) {
                    Object forecasts = weather.get("forecasts");
                    if (forecasts instanceof List<?> list && !list.isEmpty() && list.get(0) instanceof Map<?, ?> forecastMap) {
                        Object casts = forecastMap.get("casts");
                        if (casts instanceof List<?> castList && !castList.isEmpty() && castList.get(0) instanceof Map<?, ?> firstCast) {
                            // 使用第一天的预报数据作为实况数据，并补充城市信息和字段映射
                            Map<String, Object> liveWithCity = new java.util.HashMap<>();
                            // 从forecasts[0]获取城市信息
                            liveWithCity.put("city", stringValue(forecastMap, "city", ""));
                            liveWithCity.put("province", stringValue(forecastMap, "province", ""));
                            liveWithCity.put("adcode", stringValue(forecastMap, "adcode", ""));
                            liveWithCity.put("reporttime", stringValue(forecastMap, "reporttime", ""));
                            // 字段映射：预报数据的字段名 -> 实况数据的字段名
                            String dayTemp = stringValue((Map<?, ?>) firstCast, "daytemp", "");
                            if (!dayTemp.isEmpty()) {
                                liveWithCity.put("temperature", dayTemp);
                            } else {
                                liveWithCity.put("temperature", "0");
                            }
                            String dayWeather = stringValue((Map<?, ?>) firstCast, "dayweather", "");
                            if (!dayWeather.isEmpty()) {
                                liveWithCity.put("weather", dayWeather);
                            }
                            String dayWind = stringValue((Map<?, ?>) firstCast, "daywind", "");
                            if (!dayWind.isEmpty()) {
                                liveWithCity.put("winddirection", dayWind);
                            }
                            String dayPower = stringValue((Map<?, ?>) firstCast, "daypower", "");
                            if (!dayPower.isEmpty()) {
                                liveWithCity.put("windpower", dayPower);
                            }
                            // 添加湿度（预报数据中没有，使用默认值或从其他地方获取）
                            liveWithCity.put("humidity", "--");
                            live = liveWithCity;
                            System.out.println("[WeatherService] 从forecasts[0].casts[0]提取实况数据，keys=" + live.keySet());
                        }
                    }
                }
            } else {
                // base模式：从lives提取实况数据
                live = extractLive(weather);
            }
            System.out.println("[WeatherService] 提取的live数据大小: " + (live != null ? live.size() : 0));
            
            double temperature = parseDouble(live, "temperature", 22.0);
            String windpowerText = stringValue(live, "windpower", "--");
            
            System.out.println("[WeatherService] 解析结果 - temperature=" + temperature + ", windpower=" + windpowerText);
            System.out.println("[WeatherService] live中的所有keys: " + (live != null ? live.keySet() : "null"));

            WeatherInfo info = new WeatherInfo();
            info.setCity(stringValue(live, "city", ""));
            info.setProvince(stringValue(live, "province", ""));
            info.setCountry("中国");
            info.setRegion(cityAdcode);
            info.setAdcode(cityAdcode);
            info.setTemperature(temperature);
            info.setWindspeed(parseWindSpeed(windpowerText, 3.0));
            info.setWindpower(windpowerText);
            info.setWindDirection(stringValue(live, "winddirection", "--"));
            info.setHumidity(stringValue(live, "humidity", "--"));
            info.setReportTime(stringValue(live, "reporttime", ""));
            info.setDescription(stringValue(live, "weather", "晴朗"));
            info.setForecasts(forecastDays);
            info.setBackgroundStyle(gradientFor(temperature, info.getDescription()));
            
            System.out.println("[WeatherService] 最终WeatherInfo - 城市: " + info.getProvince() + "/" + info.getCity() + 
                    ", adcode=" + cityAdcode + ", extension=" + extension +
                    ", 温度=" + info.getTemperature() + "℃" +
                    ", 风力=" + info.getWindpower() +
                    ", 湿度=" + info.getHumidity() +
                    ", 描述=" + info.getDescription() +
                    ", 风向=" + info.getWindDirection() +
                    ", 更新时间=" + info.getReportTime());
            return info;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("查询天气失败: " + e.getMessage(), e);
        }
    }

    private Map<?, ?> extractLive(Map<?, ?> weather) {
        if (weather == null) {
            System.out.println("[WeatherService] extractLive: weather为null");
            return Collections.emptyMap();
        }
        Object lives = weather.get("lives");
        System.out.println("[WeatherService] extractLive: lives类型=" + (lives != null ? lives.getClass().getName() : "null"));
        System.out.println("[WeatherService] extractLive: lives值=" + lives);
        
        if (lives instanceof java.util.List<?> list) {
            System.out.println("[WeatherService] extractLive: lives是List，大小=" + list.size());
            if (!list.isEmpty()) {
                Object first = list.get(0);
                System.out.println("[WeatherService] extractLive: 第一个元素类型=" + (first != null ? first.getClass().getName() : "null"));
                if (first instanceof Map<?, ?> map) {
                    System.out.println("[WeatherService] extractLive: 成功提取live数据，keys=" + map.keySet());
                    return map;
                }
            }
        }
        System.out.println("[WeatherService] extractLive: 未能提取live数据，返回空Map");
        return Collections.emptyMap();
    }

    private List<WeatherInfo.ForecastDay> extractForecasts(Map<?, ?> weather) {
        if (weather == null) {
            return Collections.emptyList();
        }
        Object forecasts = weather.get("forecasts");
        if (!(forecasts instanceof List<?> list) || list.isEmpty()) {
            return Collections.emptyList();
        }
        Object first = list.get(0);
        if (!(first instanceof Map<?, ?> forecastMap)) {
            return Collections.emptyList();
        }
        Object casts = forecastMap.get("casts");
        if (!(casts instanceof List<?> castList)) {
            return Collections.emptyList();
        }
        List<WeatherInfo.ForecastDay> result = new ArrayList<>();
        for (Object castObj : castList) {
            if (castObj instanceof Map<?, ?> cast) {
                WeatherInfo.ForecastDay day = new WeatherInfo.ForecastDay();
                day.setDate(stringValue(cast, "date", ""));
                day.setWeek(stringValue(cast, "week", ""));
                day.setDayWeather(stringValue(cast, "dayweather", ""));
                day.setNightWeather(stringValue(cast, "nightweather", ""));
                day.setDayTemp(stringValue(cast, "daytemp", ""));
                day.setNightTemp(stringValue(cast, "nighttemp", ""));
                day.setDayWind(stringValue(cast, "daywind", ""));
                day.setNightWind(stringValue(cast, "nightwind", ""));
                day.setDayPower(stringValue(cast, "daypower", ""));
                day.setNightPower(stringValue(cast, "nightpower", ""));
                result.add(day);
            }
        }
        return result;
    }

    private Map<?, ?> requestForMapWithExtension(String url, String adcode, String extension) throws java.io.IOException {
        String fullUrl = url.replace("{key}", GAODE_KEY).replace("{city}", adcode).replace("{extension}", extension);
        System.out.println("[WeatherService] 请求URL: " + fullUrl);
        
        String response = restTemplate.getForObject(url, String.class, GAODE_KEY, adcode, extension);
        System.out.println("[WeatherService] API原始响应: " + response);
        
        if (response == null || response.isBlank()) {
            System.out.println("[WeatherService] 警告: API返回为空或空白");
            return Collections.emptyMap();
        }
        
        Map<?, ?> result = objectMapper.readValue(response, new TypeReference<Map<String, Object>>() {});
        System.out.println("[WeatherService] 解析后的Map结构: " + result);
        System.out.println("[WeatherService] Map的keys: " + (result != null ? result.keySet() : "null"));
        return result;
    }

    private double parseDouble(Map<?, ?> map, String key, double defaultValue) {
        if (map == null) {
            return defaultValue;
        }
        Object value = map.get(key);
        if (value instanceof Number number) {
            return number.doubleValue();
        }
        try {
            return Double.parseDouble(String.valueOf(value));
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private String stringValue(Map<?, ?> map, String key, String defaultValue) {
        if (map == null) {
            return defaultValue;
        }
        Object value = map.get(key);
        return value == null ? defaultValue : String.valueOf(value);
    }

    private double parseWindSpeed(String windpower, double defaultValue) {
        if (windpower == null || windpower.isBlank()) {
            return defaultValue;
        }
        String digits = windpower.replaceAll("[^0-9.]", "");
        if (digits.isEmpty()) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(digits);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String gradientFor(double temperature, String description) {
        if (description.contains("雨")) {
            return "linear-gradient(120deg, rgba(0,27,71,0.95), rgba(28,88,138,0.9))";
        }
        if (description.contains("雪")) {
            return "linear-gradient(140deg, rgba(65,41,114,0.95), rgba(31,12,66,0.9))";
        }
        if (temperature >= 30) {
            return "linear-gradient(120deg, rgba(218,68,83,0.95), rgba(255,140,0,0.9))";
        }
        if (temperature <= 10) {
            return "linear-gradient(120deg, rgba(33,147,176,0.95), rgba(109,213,237,0.9))";
        }
        return "linear-gradient(120deg, rgba(38,87,137,0.95), rgba(44,131,185,0.9))";
    }
}

