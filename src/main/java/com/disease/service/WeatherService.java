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
    private static final String IP_API = "https://restapi.amap.com/v3/ip?key={key}";
    private static final String WEATHER_API = "https://restapi.amap.com/v3/weather/weatherInfo?key={key}&city={city}&extensions=all&output=json";
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public WeatherInfo currentWeather() {
        try {
            LocationInfo location = resolveLocation();
            Map<?, ?> weather = requestForMap(WEATHER_API, location.adcode());
            Map<?, ?> live = extractLive(weather);
            List<WeatherInfo.ForecastDay> forecastDays = extractForecasts(weather);
            double temperature = parseDouble(live, "temperature", 22.0);
            String windpowerText = stringValue(live, "windpower", "--");

            WeatherInfo info = new WeatherInfo();
            info.setCity(stringValue(live, "city", location.city()));
            info.setProvince(stringValue(live, "province", location.province()));
            info.setCountry("中国");
            info.setRegion(location.adcode());
            info.setAdcode(location.adcode());
            info.setTemperature(temperature);
            info.setWindspeed(parseWindSpeed(windpowerText, 3.0));
            info.setWindpower(windpowerText);
            info.setWindDirection(stringValue(live, "winddirection", "--"));
            info.setHumidity(stringValue(live, "humidity", "--"));
            info.setReportTime(stringValue(live, "reporttime", ""));
            info.setDescription(stringValue(live, "weather", "晴朗"));
            info.setForecasts(forecastDays);
            info.setBackgroundStyle(gradientFor(temperature, info.getDescription()));
            System.out.printf("[WeatherService] 来源: 高德 %s/%s adcode=%s, 温度=%.1f℃, 风力=%s, 湿度=%s, 描述=%s%n",
                    info.getProvince(), info.getCity(), info.getRegion(),
                    info.getTemperature(), info.getWindpower(), info.getHumidity(), info.getDescription());
            return info;
        } catch (Exception e) {
            e.printStackTrace();
            WeatherInfo fallback = new WeatherInfo();
            fallback.setCity("本地");
            fallback.setCountry("中国");
            fallback.setTemperature(24.0);
            fallback.setWindspeed(3.0);
            fallback.setDescription("晴朗");
            fallback.setBackgroundStyle(gradientFor(24.0, "晴朗"));
            return fallback;
        }
    }

    private Map<?, ?> extractLive(Map<?, ?> weather) {
        if (weather == null) {
            return Collections.emptyMap();
        }
        Object lives = weather.get("lives");
        if (lives instanceof java.util.List<?> list && !list.isEmpty() && list.get(0) instanceof Map<?, ?> map) {
            return map;
        }
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

    private LocationInfo resolveLocation() {
        try {
            Map<?, ?> resp = requestForMap(IP_API, null);
            String adcode = stringValue(resp, "adcode", "");
            String city = stringValue(resp, "city", "");
            String province = stringValue(resp, "province", "");
            if (adcode.isBlank() || city.isBlank() || province.isBlank()) {
                adcode = "310000";
                city = "上海市";
                province = "上海市";
            }
            return new LocationInfo(adcode, city, province);
        } catch (Exception e) {
            return new LocationInfo("310000", "上海市", "上海市");
        }
    }

    private Map<?, ?> requestForMap(String url, String adcode) throws java.io.IOException {
        String response = (adcode == null)
                ? restTemplate.getForObject(url, String.class, GAODE_KEY)
                : restTemplate.getForObject(url, String.class, GAODE_KEY, adcode);
        if (response == null || response.isBlank()) {
            return Collections.emptyMap();
        }
        return objectMapper.readValue(response, new TypeReference<Map<String, Object>>() {});
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

    private record LocationInfo(String adcode, String city, String province) {}
}

