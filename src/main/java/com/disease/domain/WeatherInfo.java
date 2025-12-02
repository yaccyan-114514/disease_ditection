package com.disease.domain;

public class WeatherInfo {
    private String city;
    private String province;
    private String region;
    private String country;
    private String adcode;
    private Double temperature;
    private Double windspeed;
    private String windpower;
    private String windDirection;
    private String reportTime;
    private String humidity;
    private String description;
    private String backgroundStyle;
    private java.util.List<ForecastDay> forecasts;

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getAdcode() {
        return adcode;
    }

    public void setAdcode(String adcode) {
        this.adcode = adcode;
    }

    public Double getTemperature() {
        return temperature;
    }

    public void setTemperature(Double temperature) {
        this.temperature = temperature;
    }

    public Double getWindspeed() {
        return windspeed;
    }

    public void setWindspeed(Double windspeed) {
        this.windspeed = windspeed;
    }

    public String getWindpower() {
        return windpower;
    }

    public void setWindpower(String windpower) {
        this.windpower = windpower;
    }

    public String getWindDirection() {
        return windDirection;
    }

    public void setWindDirection(String windDirection) {
        this.windDirection = windDirection;
    }

    public String getReportTime() {
        return reportTime;
    }

    public void setReportTime(String reportTime) {
        this.reportTime = reportTime;
    }

    public String getHumidity() {
        return humidity;
    }

    public void setHumidity(String humidity) {
        this.humidity = humidity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBackgroundStyle() {
        return backgroundStyle;
    }

    public void setBackgroundStyle(String backgroundStyle) {
        this.backgroundStyle = backgroundStyle;
    }

    public java.util.List<ForecastDay> getForecasts() {
        return forecasts;
    }

    public void setForecasts(java.util.List<ForecastDay> forecasts) {
        this.forecasts = forecasts;
    }

    public static class ForecastDay {
        private String date;
        private String week;
        private String dayWeather;
        private String nightWeather;
        private String dayTemp;
        private String nightTemp;
        private String dayWind;
        private String nightWind;
        private String dayPower;
        private String nightPower;

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public String getWeek() {
            return week;
        }

        public void setWeek(String week) {
            this.week = week;
        }

        public String getDayWeather() {
            return dayWeather;
        }

        public void setDayWeather(String dayWeather) {
            this.dayWeather = dayWeather;
        }

        public String getNightWeather() {
            return nightWeather;
        }

        public void setNightWeather(String nightWeather) {
            this.nightWeather = nightWeather;
        }

        public String getDayTemp() {
            return dayTemp;
        }

        public void setDayTemp(String dayTemp) {
            this.dayTemp = dayTemp;
        }

        public String getNightTemp() {
            return nightTemp;
        }

        public void setNightTemp(String nightTemp) {
            this.nightTemp = nightTemp;
        }

        public String getDayWind() {
            return dayWind;
        }

        public void setDayWind(String dayWind) {
            this.dayWind = dayWind;
        }

        public String getNightWind() {
            return nightWind;
        }

        public void setNightWind(String nightWind) {
            this.nightWind = nightWind;
        }

        public String getDayPower() {
            return dayPower;
        }

        public void setDayPower(String dayPower) {
            this.dayPower = dayPower;
        }

        public String getNightPower() {
            return nightPower;
        }

        public void setNightPower(String nightPower) {
            this.nightPower = nightPower;
        }
    }
}

