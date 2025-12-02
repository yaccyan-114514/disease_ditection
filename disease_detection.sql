/*
 Navicat Premium Dump SQL

 Source Server         : yaccyan
 Source Server Type    : MySQL
 Source Server Version : 90400 (9.4.0)
 Source Host           : localhost:3306
 Source Schema         : disease_detection

 Target Server Type    : MySQL
 Target Server Version : 90400 (9.4.0)
 File Encoding         : 65001

 Date: 27/11/2025 14:33:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admins
-- ----------------------------
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','disabled') DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of admins
-- ----------------------------
BEGIN;
INSERT INTO `admins` (`id`, `username`, `password`, `name`, `phone`, `email`, `created_at`, `status`) VALUES (1, 'admin', '123456', '系统管理员', '13800001001', 'admin@example.com', '2024-01-15 10:00:00', 'active');
INSERT INTO `admins` (`id`, `username`, `password`, `name`, `phone`, `email`, `created_at`, `status`) VALUES (2, 'zhangwei', '123456', '张伟', '13800001002', 'zhangwei@example.com', '2024-02-20 14:30:00', 'active');
INSERT INTO `admins` (`id`, `username`, `password`, `name`, `phone`, `email`, `created_at`, `status`) VALUES (3, 'liumei', '123456', '刘梅', '13800001003', 'liumei@example.com', '2024-03-10 09:15:00', 'active');
INSERT INTO `admins` (`id`, `username`, `password`, `name`, `phone`, `email`, `created_at`, `status`) VALUES (4, 'wanggang', '123456', '王刚', '13800001004', 'wanggang@example.com', '2024-04-05 16:45:00', 'active');
INSERT INTO `admins` (`id`, `username`, `password`, `name`, `phone`, `email`, `created_at`, `status`) VALUES (5, 'chenfang', '123456', '陈芳', '13800001005', 'chenfang@example.com', '2024-05-12 11:20:00', 'disabled');
COMMIT;

-- ----------------------------
-- Table structure for AIRecords
-- ----------------------------
DROP TABLE IF EXISTS `AIRecords`;
CREATE TABLE `AIRecords` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `crop_id` bigint DEFAULT NULL,
  `image_url` varchar(300) NOT NULL,
  `ai_result` varchar(200) DEFAULT NULL,
  `final_result` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`),
  KEY `crop_id` (`crop_id`),
  CONSTRAINT `airecords_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `farmers` (`id`),
  CONSTRAINT `airecords_ibfk_2` FOREIGN KEY (`crop_id`) REFERENCES `crops` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of AIRecords
-- ----------------------------
BEGIN;
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (1, 1, 1, '/uploads/ai_record_1.jpg', '水稻稻瘟病', '水稻稻瘟病', '2024-06-10 09:35:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (2, 2, 8, '/uploads/ai_record_2.jpg', '番茄早疫病', '番茄早疫病', '2024-06-12 14:25:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (3, 3, 3, '/uploads/ai_record_3.jpg', '玉米大斑病', '玉米大斑病', '2024-06-15 10:20:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (4, 4, 1, '/uploads/ai_record_4.jpg', '水稻纹枯病', '水稻纹枯病', '2024-06-18 11:50:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (5, 5, 9, '/uploads/ai_record_5.jpg', '黄瓜霜霉病', '黄瓜霜霉病', '2024-06-20 08:35:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (6, 6, 5, '/uploads/ai_record_6.jpg', '棉铃虫', '棉铃虫', '2024-06-22 15:25:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (7, 7, 2, '/uploads/ai_record_7.jpg', '小麦白粉病', '小麦白粉病', '2024-06-25 09:15:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (8, 9, 13, '/uploads/ai_record_8.jpg', '茶小绿叶蝉', '茶小绿叶蝉', '2024-06-28 13:45:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (9, 10, 1, '/uploads/ai_record_9.jpg', '蚜虫', NULL, '2024-07-01 10:25:00');
INSERT INTO `AIRecords` (`id`, `user_id`, `crop_id`, `image_url`, `ai_result`, `final_result`, `created_at`) VALUES (10, 12, 11, '/uploads/ai_record_10.jpg', '红蜘蛛', NULL, '2024-07-03 14:55:00');
COMMIT;

-- ----------------------------
-- Table structure for answers
-- ----------------------------
DROP TABLE IF EXISTS `answers`;
CREATE TABLE `answers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `question_id` bigint NOT NULL,
  `expert_id` bigint NOT NULL,
  `answer_text` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  KEY `expert_id` (`expert_id`),
  CONSTRAINT `answers_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  CONSTRAINT `answers_ibfk_2` FOREIGN KEY (`expert_id`) REFERENCES `experts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of answers
-- ----------------------------
BEGIN;
INSERT INTO `answers` (`id`, `question_id`, `expert_id`, `answer_text`, `created_at`) VALUES (1, 1, 1, '根据您描述的症状，这是水稻稻瘟病。主要症状是叶片出现褐色病斑，病斑中央灰白色，边缘褐色。防治方法：1.选用抗病品种；2.合理密植；3.控制氮肥用量；4.发病初期用多菌灵50%可湿性粉剂1:800倍液或甲基托布津70%可湿性粉剂1:1000倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '2024-06-10 15:30:00');
INSERT INTO `answers` (`id`, `question_id`, `expert_id`, `answer_text`, `created_at`) VALUES (2, 2, 2, '根据您描述的症状，这是番茄早疫病。主要症状是叶片出现圆形或椭圆形病斑，病斑中央灰褐色，边缘深褐色，有同心轮纹。防治方法：1.选用抗病品种；2.合理密植；3.控制氮肥用量；4.发病初期用百菌清75%可湿性粉剂1:600倍液或代森锰锌80%可湿性粉剂1:600倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '2024-06-12 16:20:00');
INSERT INTO `answers` (`id`, `question_id`, `expert_id`, `answer_text`, `created_at`) VALUES (3, 3, 4, '根据您描述的症状，这是玉米大斑病。主要症状是叶片出现长条形病斑，病斑中央灰褐色，边缘深褐色。防治方法：1.选用抗病品种；2.合理密植；3.控制氮肥用量；4.及时排水；5.发病初期用代森锰锌80%可湿性粉剂1:600倍液或多菌灵50%可湿性粉剂1:800倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '2024-06-15 14:15:00');
INSERT INTO `answers` (`id`, `question_id`, `expert_id`, `answer_text`, `created_at`) VALUES (4, 4, 1, '根据您描述的症状，这是水稻纹枯病。主要症状是叶鞘和叶片出现云纹状病斑，病斑边缘褐色，中央淡褐色。防治方法：1.选用抗病品种；2.合理密植；3.控制氮肥用量；4.浅水勤灌，及时晒田；5.发病初期用井冈霉素5%水剂1:1000倍液或多菌灵50%可湿性粉剂1:800倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '2024-06-18 16:45:00');
INSERT INTO `answers` (`id`, `question_id`, `expert_id`, `answer_text`, `created_at`) VALUES (5, 5, 2, '根据您描述的症状，这是黄瓜霜霉病。主要症状是叶片出现多角形病斑，病斑初期水渍状，后期变黄褐色，背面有灰黑色霉层。防治方法：1.选用抗病品种；2.合理密植；3.及时通风；4.发病初期用百菌清75%可湿性粉剂1:600倍液或代森锰锌80%可湿性粉剂1:600倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '2024-06-20 12:30:00');
INSERT INTO `answers` (`id`, `question_id`, `expert_id`, `answer_text`, `created_at`) VALUES (6, 6, 6, '根据您描述的症状，这是棉铃虫。主要症状是幼虫蛀食棉铃，造成棉铃脱落或烂铃。防治方法：1.选用抗虫品种；2.合理密植；3.控制氮肥用量；4.发生初期用氯氰菊酯10%乳油1:2000倍液或敌敌畏80%乳油1:800倍液喷雾防治，每隔7-10天喷一次，连续2-3次；5.可以释放赤眼蜂等天敌进行生物防治。', '2024-06-22 17:20:00');
INSERT INTO `answers` (`id`, `question_id`, `expert_id`, `answer_text`, `created_at`) VALUES (7, 7, 5, '根据您描述的症状，这是小麦白粉病。主要症状是叶片和茎秆表面出现白色粉状物，严重时叶片变黄枯死。防治方法：1.选用抗病品种；2.合理密植；3.控制氮肥用量；4.及时通风；5.发病初期用三唑酮20%乳油1:1000倍液或多菌灵50%可湿性粉剂1:800倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '2024-06-25 13:10:00');
INSERT INTO `answers` (`id`, `question_id`, `expert_id`, `answer_text`, `created_at`) VALUES (8, 8, 6, '根据您描述的症状，这是茶小绿叶蝉。主要症状是叶片出现黄白色小点，严重时叶片变黄枯死，叶片背面有很多小虫。防治方法：1.选用抗虫品种；2.合理密植；3.控制氮肥用量；4.发生初期用吡虫啉10%可湿性粉剂1:2000倍液或噻虫嗪25%水分散粒剂1:3000倍液喷雾防治，每隔7-14天喷一次，连续2-3次；5.可以释放瓢虫、草蛉等天敌进行生物防治。', '2024-06-28 15:40:00');
COMMIT;

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `farmers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of comments
-- ----------------------------
BEGIN;
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (1, 1, 2, '感谢分享，我也准备试试这些方法。', '2024-06-05 14:30:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (2, 1, 4, '很有用的经验，我去年也遇到了类似的问题。', '2024-06-05 16:20:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (3, 2, 5, '番茄早疫病确实很常见，我也用过百菌清，效果不错。', '2024-06-08 18:10:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (4, 2, 8, '学习了，谢谢分享。', '2024-06-09 09:45:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (5, 3, 6, '玉米高产的关键是选好品种和科学管理。', '2024-06-12 15:30:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (6, 3, 11, '我也种玉米，今年产量也不错，主要是及时防治了病虫害。', '2024-06-13 10:20:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (7, 4, 3, '黄瓜霜霉病防治要及时，晚了就不好治了。', '2024-06-15 15:50:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (8, 4, 7, '通风很重要，可以减少病害的发生。', '2024-06-16 11:30:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (9, 5, 10, '小麦白粉病要早防早治，晚了影响产量。', '2024-06-18 18:20:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (10, 5, 13, '三唑酮效果不错，我每年都用。', '2024-06-19 14:15:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (11, 6, 14, '茶叶种植管理很重要，直接影响品质。', '2024-06-20 16:40:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (12, 6, 16, '学习了，谢谢分享经验。', '2024-06-21 10:25:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (13, 7, 17, '红蜘蛛确实很麻烦，要及时防治。', '2024-06-25 14:50:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (14, 7, 19, '保持田间湿度很重要，可以减少红蜘蛛的发生。', '2024-06-26 11:20:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (15, 8, 20, '有机农业是未来的趋势，虽然产量低点，但品质好。', '2024-06-28 17:30:00');
INSERT INTO `comments` (`id`, `post_id`, `user_id`, `content`, `created_at`) VALUES (16, 8, 22, '我也在尝试有机种植，希望能多交流。', '2024-06-29 13:45:00');
COMMIT;

-- ----------------------------
-- Table structure for crops
-- ----------------------------
DROP TABLE IF EXISTS `crops`;
CREATE TABLE `crops` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `crop_name` varchar(100) NOT NULL,
  `planting_season` varchar(100) DEFAULT NULL,
  `region_adapt` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of crops
-- ----------------------------
BEGIN;
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (1, '水稻', '春季、夏季', '长江中下游、华南、西南地区', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (2, '小麦', '秋季、冬季', '华北、黄淮、长江中下游地区', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (3, '玉米', '春季、夏季', '东北、华北、黄淮、西南地区', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (4, '大豆', '春季、夏季', '东北、黄淮、长江流域', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (5, '棉花', '春季', '黄河流域、长江流域、新疆', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (6, '油菜', '秋季、冬季', '长江流域、黄淮地区', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (7, '花生', '春季、夏季', '黄淮、长江中下游、华南地区', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (8, '番茄', '春季、秋季', '全国各地', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (9, '黄瓜', '春季、夏季、秋季', '全国各地', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (10, '白菜', '春季、秋季', '全国各地', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (11, '草莓', '秋季、冬季', '长江中下游、华北、东北地区', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (12, '苹果', '春季', '华北、西北、东北地区', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (13, '茶叶', '春季、秋季', '长江流域、华南、西南地区', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (14, '葡萄', '春季', '华北、西北、长江流域', '2024-01-01 10:00:00');
INSERT INTO `crops` (`id`, `crop_name`, `planting_season`, `region_adapt`, `created_at`) VALUES (15, '西瓜', '春季、夏季', '全国各地', '2024-01-01 10:00:00');
COMMIT;

-- ----------------------------
-- Table structure for diseases
-- ----------------------------
DROP TABLE IF EXISTS `diseases`;
CREATE TABLE `diseases` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` enum('disease','pest') NOT NULL,
  `host_crop` varchar(100) DEFAULT NULL,
  `symptoms` text,
  `harm_level` enum('low','medium','high') DEFAULT NULL,
  `occurrence_season` varchar(100) DEFAULT NULL,
  `climate_conditions` text,
  `soil_conditions` text,
  `risk_factors` text,
  `diagnosis_keypoints` text,
  `similar_diseases` json DEFAULT NULL,
  `prevention_methods` text,
  `control_methods` text,
  `chemical_control` json DEFAULT NULL,
  `biological_control` text,
  `agricultural_control` text,
  `is_green_control` tinyint(1) DEFAULT '0',
  `images` json DEFAULT NULL,
  `region` varchar(200) DEFAULT NULL,
  `quarantine_level` enum('1','2','3') DEFAULT NULL,
  `report_source` varchar(100) DEFAULT NULL,
  `created_by` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pest_created_by` (`created_by`),
  CONSTRAINT `fk_pest_created_by` FOREIGN KEY (`created_by`) REFERENCES `experts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of diseases
-- ----------------------------
BEGIN;
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (1, '水稻稻瘟病', 'disease', '水稻', '叶片出现褐色病斑，病斑中央灰白色，边缘褐色，严重时叶片枯死。', 'high', '夏季、秋季', '高温高湿，温度25-28℃，相对湿度90%以上', '酸性土壤，氮肥过多', '密植、氮肥过量、长期深水灌溉', '病斑呈梭形，中央灰白色，边缘褐色，有黄色晕圈', '[\"稻纹枯病\", \"稻胡麻斑病\"]', '选用抗病品种，合理密植，控制氮肥用量', '发病初期用多菌灵、甲基托布津等药剂喷雾防治', '[\"多菌灵50%可湿性粉剂1:800倍液\", \"甲基托布津70%可湿性粉剂1:1000倍液\"]', '使用枯草芽孢杆菌等生物制剂', '合理施肥，浅水勤灌，及时晒田', 1, '[\"/images/rice_blast_1.jpg\", \"/images/rice_blast_2.jpg\"]', '长江中下游、华南地区', '2', '农业部门监测', 1);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (2, '水稻纹枯病', 'disease', '水稻', '叶鞘和叶片出现云纹状病斑，病斑边缘褐色，中央淡褐色，严重时整株枯死。', 'high', '夏季、秋季', '高温高湿，温度28-32℃，相对湿度85%以上', '黏性土壤，长期深水', '密植、氮肥过多、长期深水灌溉', '病斑呈云纹状，边缘褐色，中央淡褐色', '[\"稻瘟病\", \"稻胡麻斑病\"]', '选用抗病品种，合理密植，控制氮肥用量', '发病初期用井冈霉素、多菌灵等药剂喷雾防治', '[\"井冈霉素5%水剂1:1000倍液\", \"多菌灵50%可湿性粉剂1:800倍液\"]', '使用木霉菌等生物制剂', '合理施肥，浅水勤灌，及时晒田', 1, '[\"/images/rice_sheath_1.jpg\", \"/images/rice_sheath_2.jpg\"]', '长江中下游、华南地区', '2', '农业部门监测', 1);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (3, '小麦白粉病', 'disease', '小麦', '叶片和茎秆表面出现白色粉状物，严重时叶片变黄枯死。', 'medium', '春季、秋季', '温度15-20℃，相对湿度60-80%', '肥沃土壤，氮肥过多', '密植、氮肥过量、通风不良', '叶片表面有白色粉状物，后期出现黑色小点', '[\"小麦锈病\", \"小麦叶枯病\"]', '选用抗病品种，合理密植，控制氮肥用量', '发病初期用三唑酮、多菌灵等药剂喷雾防治', '[\"三唑酮20%乳油1:1000倍液\", \"多菌灵50%可湿性粉剂1:800倍液\"]', '使用枯草芽孢杆菌等生物制剂', '合理施肥，及时通风，清除病残体', 1, '[\"/images/wheat_powdery_1.jpg\", \"/images/wheat_powdery_2.jpg\"]', '华北、黄淮、长江中下游地区', '2', '农业部门监测', 5);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (4, '玉米大斑病', 'disease', '玉米', '叶片出现长条形病斑，病斑中央灰褐色，边缘深褐色，严重时叶片枯死。', 'high', '夏季、秋季', '温度20-25℃，相对湿度85%以上', '黏性土壤，排水不良', '密植、氮肥过多、连作', '病斑呈长条形，中央灰褐色，边缘深褐色', '[\"玉米小斑病\", \"玉米灰斑病\"]', '选用抗病品种，合理密植，控制氮肥用量', '发病初期用代森锰锌、多菌灵等药剂喷雾防治', '[\"代森锰锌80%可湿性粉剂1:600倍液\", \"多菌灵50%可湿性粉剂1:800倍液\"]', '使用枯草芽孢杆菌等生物制剂', '合理施肥，及时排水，清除病残体', 1, '[\"/images/corn_leaf_1.jpg\", \"/images/corn_leaf_2.jpg\"]', '东北、华北、黄淮地区', '2', '农业部门监测', 4);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (5, '番茄早疫病', 'disease', '番茄', '叶片出现圆形或椭圆形病斑，病斑中央灰褐色，边缘深褐色，有同心轮纹。', 'medium', '春季、夏季、秋季', '温度20-25℃，相对湿度80%以上', '黏性土壤，排水不良', '密植、氮肥过多、连作', '病斑呈圆形或椭圆形，有同心轮纹', '[\"番茄晚疫病\", \"番茄叶霉病\"]', '选用抗病品种，合理密植，控制氮肥用量', '发病初期用百菌清、代森锰锌等药剂喷雾防治', '[\"百菌清75%可湿性粉剂1:600倍液\", \"代森锰锌80%可湿性粉剂1:600倍液\"]', '使用木霉菌等生物制剂', '合理施肥，及时通风，清除病残体', 1, '[\"/images/tomato_early_1.jpg\", \"/images/tomato_early_2.jpg\"]', '全国各地', '2', '农业部门监测', 2);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (6, '黄瓜霜霉病', 'disease', '黄瓜', '叶片出现多角形病斑，病斑初期水渍状，后期变黄褐色，背面有灰黑色霉层。', 'high', '春季、夏季、秋季', '温度15-22℃，相对湿度85%以上', '黏性土壤，排水不良', '密植、氮肥过多、通风不良', '病斑呈多角形，背面有灰黑色霉层', '[\"黄瓜白粉病\", \"黄瓜炭疽病\"]', '选用抗病品种，合理密植，控制氮肥用量', '发病初期用百菌清、代森锰锌等药剂喷雾防治', '[\"百菌清75%可湿性粉剂1:600倍液\", \"代森锰锌80%可湿性粉剂1:600倍液\"]', '使用枯草芽孢杆菌等生物制剂', '合理施肥，及时通风，清除病残体', 1, '[\"/images/cucumber_downy_1.jpg\", \"/images/cucumber_downy_2.jpg\"]', '全国各地', '2', '农业部门监测', 2);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (7, '蚜虫', 'pest', '多种作物', '叶片卷曲，植株生长缓慢，叶片上有大量蚜虫聚集，分泌蜜露。', 'medium', '春季、夏季、秋季', '温度15-25℃，相对湿度60-80%', '肥沃土壤，氮肥过多', '密植、氮肥过量、天敌减少', '叶片上有大量蚜虫聚集，分泌蜜露', '[\"白粉虱\", \"蓟马\"]', '选用抗虫品种，合理密植，控制氮肥用量', '发生初期用吡虫啉、噻虫嗪等药剂喷雾防治', '[\"吡虫啉10%可湿性粉剂1:2000倍液\", \"噻虫嗪25%水分散粒剂1:3000倍液\"]', '释放瓢虫、草蛉等天敌', '合理施肥，及时清除杂草，保护天敌', 1, '[\"/images/aphid_1.jpg\", \"/images/aphid_2.jpg\"]', '全国各地', '1', '农业部门监测', 7);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (8, '红蜘蛛', 'pest', '多种作物', '叶片出现黄白色小点，严重时叶片变黄枯死，叶片背面有红色小虫。', 'medium', '春季、夏季、秋季', '温度20-30℃，相对湿度40-60%', '沙性土壤，干旱', '干旱、高温、天敌减少', '叶片背面有红色小虫，叶片出现黄白色小点', '[\"白蜘蛛\", \"二斑叶螨\"]', '选用抗虫品种，合理密植，保持田间湿度', '发生初期用阿维菌素、氯氰菊酯等药剂喷雾防治', '[\"阿维菌素1.8%乳油1:2000倍液\", \"氯氰菊酯10%乳油1:2000倍液\"]', '释放捕食螨等天敌', '合理灌溉，保持田间湿度，保护天敌', 1, '[\"/images/spider_mite_1.jpg\", \"/images/spider_mite_2.jpg\"]', '全国各地', '1', '农业部门监测', 7);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (9, '棉铃虫', 'pest', '棉花', '幼虫蛀食棉铃，造成棉铃脱落或烂铃，严重影响产量。', 'high', '夏季、秋季', '温度25-30℃，相对湿度60-80%', '沙性土壤，排水良好', '密植、氮肥过多、天敌减少', '棉铃上有蛀孔，内有幼虫', '[\"棉红铃虫\", \"棉小造桥虫\"]', '选用抗虫品种，合理密植，控制氮肥用量', '发生初期用氯氰菊酯、敌敌畏等药剂喷雾防治', '[\"氯氰菊酯10%乳油1:2000倍液\", \"敌敌畏80%乳油1:800倍液\"]', '释放赤眼蜂等天敌', '合理施肥，及时清除杂草，保护天敌', 0, '[\"/images/cotton_bollworm_1.jpg\", \"/images/cotton_bollworm_2.jpg\"]', '黄河流域、长江流域、新疆', '2', '农业部门监测', 6);
INSERT INTO `diseases` (`id`, `name`, `type`, `host_crop`, `symptoms`, `harm_level`, `occurrence_season`, `climate_conditions`, `soil_conditions`, `risk_factors`, `diagnosis_keypoints`, `similar_diseases`, `prevention_methods`, `control_methods`, `chemical_control`, `biological_control`, `agricultural_control`, `is_green_control`, `images`, `region`, `quarantine_level`, `report_source`, `created_by`) VALUES (10, '茶小绿叶蝉', 'pest', '茶叶', '叶片出现黄白色小点，严重时叶片变黄枯死，影响茶叶品质。', 'medium', '春季、夏季、秋季', '温度20-28℃，相对湿度70-85%', '酸性土壤，排水良好', '密植、氮肥过多、天敌减少', '叶片上有大量小虫，叶片出现黄白色小点', '[\"茶尺蠖\", \"茶毛虫\"]', '选用抗虫品种，合理密植，控制氮肥用量', '发生初期用吡虫啉、噻虫嗪等药剂喷雾防治', '[\"吡虫啉10%可湿性粉剂1:2000倍液\", \"噻虫嗪25%水分散粒剂1:3000倍液\"]', '释放瓢虫、草蛉等天敌', '合理施肥，及时清除杂草，保护天敌', 1, '[\"/images/tea_leafhopper_1.jpg\", \"/images/tea_leafhopper_2.jpg\"]', '长江流域、华南、西南地区', '1', '农业部门监测', 6);
COMMIT;

-- ----------------------------
-- Table structure for diseases_pesticides
-- ----------------------------
DROP TABLE IF EXISTS `diseases_pesticides`;
CREATE TABLE `diseases_pesticides` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `disease_id` bigint NOT NULL,
  `pesticide_id` bigint NOT NULL,
  `recommended_dose` varchar(100) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `disease_id` (`disease_id`),
  KEY `pesticide_id` (`pesticide_id`),
  CONSTRAINT `diseases_pesticides_ibfk_1` FOREIGN KEY (`disease_id`) REFERENCES `diseases` (`id`),
  CONSTRAINT `diseases_pesticides_ibfk_2` FOREIGN KEY (`pesticide_id`) REFERENCES `pesticides` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of diseases_pesticides
-- ----------------------------
BEGIN;
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (1, 1, 1, '1:800倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (2, 1, 3, '1:1000倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (3, 2, 1, '1:800倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (4, 3, 7, '1:1000倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (5, 3, 1, '1:800倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (6, 4, 8, '1:600倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (7, 4, 1, '1:800倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (8, 5, 2, '1:600倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (9, 5, 8, '1:600倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (10, 6, 2, '1:600倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (11, 6, 8, '1:600倍液', '发病初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (12, 7, 5, '1:2000倍液', '发生初期使用，每隔7-14天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (13, 7, 10, '1:3000倍液', '发生初期使用，每隔7-14天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (14, 8, 6, '1:2000倍液', '发生初期使用，每隔7-14天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (15, 8, 9, '1:2000倍液', '发生初期使用，每隔7-14天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (16, 9, 9, '1:2000倍液', '发生初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (17, 9, 4, '1:800倍液', '发生初期使用，每隔7-10天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (18, 10, 5, '1:2000倍液', '发生初期使用，每隔7-14天喷一次，连续2-3次');
INSERT INTO `diseases_pesticides` (`id`, `disease_id`, `pesticide_id`, `recommended_dose`, `notes`) VALUES (19, 10, 10, '1:3000倍液', '发生初期使用，每隔7-14天喷一次，连续2-3次');
COMMIT;

-- ----------------------------
-- Table structure for experts
-- ----------------------------
DROP TABLE IF EXISTS `experts`;
CREATE TABLE `experts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `organization` varchar(100) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `specialty` varchar(200) DEFAULT NULL,
  `bio` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','disabled') DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of experts
-- ----------------------------
BEGIN;
INSERT INTO `experts` (`id`, `name`, `gender`, `phone`, `email`, `password`, `organization`, `title`, `specialty`, `bio`, `created_at`, `status`) VALUES (1, '李明', 'male', '13900001001', 'liming@example.com', '123456', '中国农业科学院', '研究员', '水稻病虫害防治、植物病理学', '从事农业病虫害研究20余年，在水稻病害防治方面有丰富经验。', '2024-01-10 08:00:00', 'active');
INSERT INTO `experts` (`id`, `name`, `gender`, `phone`, `email`, `password`, `organization`, `title`, `specialty`, `bio`, `created_at`, `status`) VALUES (2, '王秀英', 'female', '13900001002', 'wangxiuying@example.com', '123456', '农业大学植物保护学院', '教授', '蔬菜病虫害诊断、生物防治', '专注于蔬菜病虫害的生物防治技术研究，发表论文50余篇。', '2024-01-15 09:30:00', 'active');
INSERT INTO `experts` (`id`, `name`, `gender`, `phone`, `email`, `password`, `organization`, `title`, `specialty`, `bio`, `created_at`, `status`) VALUES (3, '张建国', 'male', '13900001003', 'zhangjianguo@example.com', '123456', '省农业技术推广中心', '高级农艺师', '果树病虫害防治、农药使用指导', '长期从事基层农业技术推广工作，擅长果树病虫害的现场诊断。', '2024-02-01 10:15:00', 'active');
INSERT INTO `experts` (`id`, `name`, `gender`, `phone`, `email`, `password`, `organization`, `title`, `specialty`, `bio`, `created_at`, `status`) VALUES (4, '刘红', 'female', '13900001004', 'liuhong@example.com', '123456', '市农业科学研究所', '副研究员', '玉米病虫害、农业信息化', '研究玉米主要病虫害的发生规律和防治技术，参与多项省级科研项目。', '2024-02-10 14:20:00', 'active');
INSERT INTO `experts` (`id`, `name`, `gender`, `phone`, `email`, `password`, `organization`, `title`, `specialty`, `bio`, `created_at`, `status`) VALUES (5, '陈强', 'male', '13900001005', 'chenqiang@example.com', '123456', '农业大学', '副教授', '小麦病害、植物免疫', '主要从事小麦病害的分子机制研究，在植物免疫领域有深入研究。', '2024-03-05 11:00:00', 'active');
INSERT INTO `experts` (`id`, `name`, `gender`, `phone`, `email`, `password`, `organization`, `title`, `specialty`, `bio`, `created_at`, `status`) VALUES (6, '赵敏', 'female', '13900001006', 'zhaomin@example.com', '123456', '农业技术推广站', '农艺师', '经济作物病虫害、绿色防控', '专注于茶叶、棉花等经济作物的病虫害绿色防控技术推广。', '2024-03-15 15:30:00', 'active');
INSERT INTO `experts` (`id`, `name`, `gender`, `phone`, `email`, `password`, `organization`, `title`, `specialty`, `bio`, `created_at`, `status`) VALUES (7, '孙伟', 'male', '13900001007', 'sunwei@example.com', '123456', '植物保护研究所', '研究员', '农业害虫综合治理、天敌利用', '研究农业害虫的生物防治和综合治理技术，擅长天敌昆虫的利用。', '2024-04-01 09:00:00', 'active');
INSERT INTO `experts` (`id`, `name`, `gender`, `phone`, `email`, `password`, `organization`, `title`, `specialty`, `bio`, `created_at`, `status`) VALUES (8, '周丽', 'female', '13900001008', 'zhouli@example.com', '123456', '农业科学院', '助理研究员', '设施农业病虫害、精准施药', '主要从事设施农业中病虫害的精准识别和施药技术研究。', '2024-04-20 13:45:00', 'disabled');
COMMIT;

-- ----------------------------
-- Table structure for farmer_crops
-- ----------------------------
DROP TABLE IF EXISTS `farmer_crops`;
CREATE TABLE `farmer_crops` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `farmer_id` bigint NOT NULL,
  `crop_id` bigint NOT NULL,
  `plant_date` date DEFAULT NULL,
  `growth_stage` varchar(100) DEFAULT NULL,
  `location` varchar(200) DEFAULT NULL,
  `area` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `farmer_id` (`farmer_id`),
  KEY `crop_id` (`crop_id`),
  CONSTRAINT `farmer_crops_ibfk_1` FOREIGN KEY (`farmer_id`) REFERENCES `farmers` (`id`),
  CONSTRAINT `farmer_crops_ibfk_2` FOREIGN KEY (`crop_id`) REFERENCES `crops` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of farmer_crops
-- ----------------------------
BEGIN;
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (1, 1, 1, '2024-04-15', '分蘖期', '南京市江宁区某镇某村123号', 8.50);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (2, 1, 2, '2024-10-20', '出苗期', '南京市江宁区某镇某村123号', 7.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (3, 2, 8, '2024-03-10', '开花期', '苏州市吴中区某镇某村456号', 3.50);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (4, 2, 11, '2024-09-15', '结果期', '苏州市吴中区某镇某村456号', 4.80);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (5, 3, 3, '2024-05-01', '拔节期', '徐州市铜山区某镇某村789号', 15.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (6, 3, 4, '2024-06-10', '开花期', '徐州市铜山区某镇某村789号', 10.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (7, 4, 1, '2024-04-20', '分蘖期', '常州市武进区某镇某村321号', 7.60);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (8, 4, 6, '2024-10-15', '出苗期', '常州市武进区某镇某村321号', 5.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (9, 5, 9, '2024-03-20', '结果期', '无锡市惠山区某镇某村654号', 6.80);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (10, 5, 15, '2024-04-10', '结果期', '无锡市惠山区某镇某村654号', 12.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (11, 6, 5, '2024-04-05', '现蕾期', '南通市通州区某镇某村987号', 4.50);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (12, 6, 7, '2024-05-15', '开花期', '南通市通州区某镇某村987号', 2.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (13, 7, 1, '2024-04-18', '分蘖期', '盐城市大丰区某镇某村147号', 12.20);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (14, 7, 2, '2024-10-22', '出苗期', '盐城市大丰区某镇某村147号', 10.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (15, 7, 3, '2024-05-05', '拔节期', '盐城市大丰区某镇某村147号', 8.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (16, 9, 13, '2024-03-15', '采摘期', '镇江市丹徒区某镇某村369号', 8.70);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (17, 9, 12, '2024-04-01', '开花期', '镇江市丹徒区某镇某村369号', 6.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (18, 12, 8, '2024-03-12', '结果期', '淮安市淮安区某镇某村963号', 2.80);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (19, 12, 11, '2024-09-20', '结果期', '淮安市淮安区某镇某村963号', 3.00);
INSERT INTO `farmer_crops` (`id`, `farmer_id`, `crop_id`, `plant_date`, `growth_stage`, `location`, `area`) VALUES (20, 12, 14, '2024-04-15', '结果期', '淮安市淮安区某镇某村963号', 2.00);
COMMIT;

-- ----------------------------
-- Table structure for farmers
-- ----------------------------
DROP TABLE IF EXISTS `farmers`;
CREATE TABLE `farmers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `id_card` varchar(30) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `region` varchar(100) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `farm_size` decimal(10,2) DEFAULT NULL,
  `main_crops` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','disabled') DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of farmers
-- ----------------------------
BEGIN;
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (1, '张大山', 'male', '15000001001', '320101198001011234', '123456', '江苏省南京市', '南京市江宁区某镇某村123号', 15.50, '水稻、小麦', '2024-01-20 10:00:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (2, '李桂花', 'female', '15000001002', '320101198502021234', '123456', '江苏省苏州市', '苏州市吴中区某镇某村456号', 8.30, '蔬菜、草莓', '2024-01-25 14:30:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (3, '王老五', 'male', '15000001003', '320101197803031234', '123456', '江苏省徐州市', '徐州市铜山区某镇某村789号', 25.00, '玉米、大豆', '2024-02-05 09:15:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (4, '刘翠花', 'female', '15000001004', '320101199004041234', '123456', '江苏省常州市', '常州市武进区某镇某村321号', 12.60, '水稻、油菜', '2024-02-10 11:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (5, '陈大牛', 'male', '15000001005', '320101198205051234', '123456', '江苏省无锡市', '无锡市惠山区某镇某村654号', 18.80, '蔬菜、水果', '2024-02-15 16:45:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (6, '赵小芳', 'female', '15000001006', '320101199306061234', '123456', '江苏省南通市', '南通市通州区某镇某村987号', 6.50, '棉花、花生', '2024-03-01 08:30:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (7, '孙建国', 'male', '15000001007', '320101197507071234', '123456', '江苏省盐城市', '盐城市大丰区某镇某村147号', 30.20, '水稻、小麦、玉米', '2024-03-10 13:00:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (8, '周美丽', 'female', '15000001008', '320101198808081234', '123456', '江苏省扬州市', '扬州市江都区某镇某村258号', 10.40, '蔬菜、花卉', '2024-03-20 15:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (9, '吴大勇', 'male', '15000001009', '320101198909091234', '123456', '江苏省镇江市', '镇江市丹徒区某镇某村369号', 14.70, '茶叶、果树', '2024-04-05 10:45:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (10, '郑秀兰', 'female', '15000001010', '320101199010101234', '123456', '江苏省泰州市', '泰州市高港区某镇某村741号', 9.20, '水稻、蔬菜', '2024-04-12 12:30:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (11, '马强', 'male', '15000001011', '320101198111111234', '123456', '江苏省宿迁市', '宿迁市宿城区某镇某村852号', 22.30, '小麦、玉米、大豆', '2024-04-20 09:00:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (12, '林小梅', 'female', '15000001012', '320101199212121234', '123456', '江苏省淮安市', '淮安市淮安区某镇某村963号', 7.80, '蔬菜、草莓、葡萄', '2024-05-01 14:15:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (13, '黄大伟', 'male', '15000001013', '320101197313131234', '123456', '江苏省连云港市', '连云港市海州区某镇某村159号', 19.50, '水稻、小麦、棉花', '2024-05-10 11:30:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (14, '徐小丽', 'female', '15000001014', '320101198414141234', '123456', '江苏省南京市', '南京市六合区某镇某村357号', 11.20, '蔬菜、水果、花卉', '2024-05-15 16:00:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (15, '何老六', 'male', '15000001015', '320101197515151234', '123456', '江苏省苏州市', '苏州市相城区某镇某村468号', 16.90, '水稻、油菜、茶叶', '2024-05-20 08:45:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (16, '罗大富', 'male', '15000001016', '320101198616161234', '123456', '江苏省南京市', '南京市浦口区某镇某村111号', 13.40, '水稻、小麦', '2024-05-25 10:00:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (17, '钱小芳', 'female', '15000001017', '320101199717171234', '123456', '江苏省苏州市', '苏州市工业园区某镇某村222号', 9.60, '蔬菜、水果', '2024-06-01 14:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (18, '冯大勇', 'male', '15000001018', '320101197818181234', '123456', '江苏省徐州市', '徐州市贾汪区某镇某村333号', 21.80, '玉米、大豆、花生', '2024-06-05 09:30:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (19, '韩小丽', 'female', '15000001019', '320101198919191234', '123456', '江苏省常州市', '常州市新北区某镇某村444号', 8.90, '蔬菜、草莓', '2024-06-10 11:45:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (20, '杨大伟', 'male', '15000001020', '320101197020201234', '123456', '江苏省无锡市', '无锡市锡山区某镇某村555号', 17.30, '水稻、油菜', '2024-06-15 15:00:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (21, '朱小梅', 'female', '15000001021', '320101199121211234', '123456', '江苏省南通市', '南通市崇川区某镇某村666号', 10.70, '棉花、蔬菜', '2024-06-20 08:15:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (22, '秦大强', 'male', '15000001022', '320101198222221234', '123456', '江苏省盐城市', '盐城市亭湖区某镇某村777号', 24.50, '水稻、小麦、玉米', '2024-06-25 13:30:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (23, '许小芳', 'female', '15000001023', '320101199323231234', '123456', '江苏省扬州市', '扬州市广陵区某镇某村888号', 7.20, '蔬菜、花卉', '2024-07-01 10:45:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (24, '何大勇', 'male', '15000001024', '320101197424241234', '123456', '江苏省镇江市', '镇江市京口区某镇某村999号', 15.80, '茶叶、果树', '2024-07-05 14:00:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (25, '施小丽', 'female', '15000001025', '320101198525251234', '123456', '江苏省泰州市', '泰州市海陵区某镇某村101号', 11.90, '水稻、蔬菜', '2024-07-10 09:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (26, '张二山', 'male', '15000001026', '320101197626261234', '123456', '江苏省宿迁市', '宿迁市沭阳县某镇某村202号', 20.40, '小麦、玉米', '2024-07-15 12:35:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (27, '李二花', 'female', '15000001027', '320101199727271234', '123456', '江苏省淮安市', '淮安市清江浦区某镇某村303号', 8.10, '蔬菜、草莓、葡萄', '2024-07-20 16:50:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (28, '王二五', 'male', '15000001028', '320101198828281234', '123456', '江苏省连云港市', '连云港市赣榆区某镇某村404号', 18.60, '水稻、小麦、棉花', '2024-07-25 11:05:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (29, '刘二花', 'female', '15000001029', '320101197929291234', '123456', '江苏省南京市', '南京市溧水区某镇某村505号', 12.30, '蔬菜、水果、花卉', '2024-08-01 14:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (30, '陈二牛', 'male', '15000001030', '320101199030301234', '123456', '江苏省苏州市', '苏州市昆山市某镇某村606号', 16.20, '水稻、油菜、茶叶', '2024-08-05 09:35:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (31, '赵二芳', 'female', '15000001031', '320101198131311234', '123456', '江苏省徐州市', '徐州市新沂市某镇某村707号', 9.80, '玉米、大豆', '2024-08-10 13:50:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (32, '孙二国', 'male', '15000001032', '320101197232321234', '123456', '江苏省常州市', '常州市金坛区某镇某村808号', 22.70, '水稻、小麦、玉米', '2024-08-15 10:05:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (33, '周二美', 'female', '15000001033', '320101199333331234', '123456', '江苏省无锡市', '无锡市江阴市某镇某村909号', 7.50, '蔬菜、草莓', '2024-08-20 15:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (34, '吴二勇', 'male', '15000001034', '320101198434341234', '123456', '江苏省南通市', '南通市如皋市某镇某村110号', 14.40, '棉花、花生', '2024-08-25 11:35:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (35, '郑二兰', 'female', '15000001035', '320101197535351234', '123456', '江苏省盐城市', '盐城市东台市某镇某村211号', 10.60, '水稻、蔬菜', '2024-09-01 09:50:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (36, '马二强', 'male', '15000001036', '320101199636361234', '123456', '江苏省扬州市', '扬州市仪征市某镇某村312号', 19.10, '小麦、玉米、大豆', '2024-09-05 14:05:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (37, '林二梅', 'female', '15000001037', '320101198737371234', '123456', '江苏省镇江市', '镇江市句容市某镇某村413号', 8.70, '蔬菜、草莓、葡萄', '2024-09-10 10:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (38, '黄二伟', 'male', '15000001038', '320101197838381234', '123456', '江苏省泰州市', '泰州市兴化市某镇某村514号', 17.90, '水稻、小麦、棉花', '2024-09-15 15:35:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (39, '徐二丽', 'female', '15000001039', '320101199939391234', '123456', '江苏省宿迁市', '宿迁市泗阳县某镇某村615号', 11.50, '蔬菜、水果、花卉', '2024-09-20 11:50:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (40, '何二六', 'male', '15000001040', '320101198040401234', '123456', '江苏省淮安市', '淮安市涟水县某镇某村716号', 13.80, '水稻、油菜、茶叶', '2024-09-25 09:05:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (41, '罗二富', 'male', '15000001041', '320101197141411234', '123456', '江苏省连云港市', '连云港市灌云县某镇某村817号', 20.60, '水稻、小麦', '2024-10-01 14:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (42, '钱二芳', 'female', '15000001042', '320101199242421234', '123456', '江苏省南京市', '南京市高淳区某镇某村918号', 9.40, '蔬菜、水果', '2024-10-05 10:35:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (43, '冯二勇', 'male', '15000001043', '320101198343431234', '123456', '江苏省苏州市', '苏州市太仓市某镇某村119号', 15.70, '玉米、大豆、花生', '2024-10-10 15:50:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (44, '韩二丽', 'female', '15000001044', '320101197444441234', '123456', '江苏省徐州市', '徐州市邳州市某镇某村220号', 8.60, '蔬菜、草莓', '2024-10-15 11:05:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (45, '杨二伟', 'male', '15000001045', '320101199545451234', '123456', '江苏省常州市', '常州市溧阳市某镇某村321号', 18.40, '水稻、油菜', '2024-10-20 09:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (46, '朱二梅', 'female', '15000001046', '320101198646461234', '123456', '江苏省无锡市', '无锡市宜兴市某镇某村422号', 12.10, '棉花、蔬菜', '2024-10-25 14:35:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (47, '秦二强', 'male', '15000001047', '320101197747471234', '123456', '江苏省南通市', '南通市海安市某镇某村523号', 23.30, '水稻、小麦、玉米', '2024-11-01 10:50:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (48, '许二芳', 'female', '15000001048', '320101199848481234', '123456', '江苏省盐城市', '盐城市建湖县某镇某村624号', 7.30, '蔬菜、花卉', '2024-11-05 15:05:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (49, '何二勇', 'male', '15000001049', '320101198949491234', '123456', '江苏省扬州市', '扬州市高邮市某镇某村725号', 16.50, '茶叶、果树', '2024-11-10 11:20:00', 'active');
INSERT INTO `farmers` (`id`, `name`, `gender`, `phone`, `id_card`, `password`, `region`, `address`, `farm_size`, `main_crops`, `created_at`, `status`) VALUES (50, '施二丽', 'female', '15000001050', '320101197050501234', '123456', '江苏省镇江市', '镇江市丹阳市某镇某村826号', 10.90, '水稻、蔬菜', '2024-11-15 09:35:00', 'disabled');
COMMIT;

-- ----------------------------
-- Table structure for pesticides
-- ----------------------------
DROP TABLE IF EXISTS `pesticides`;
CREATE TABLE `pesticides` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `composition` varchar(200) DEFAULT NULL,
  `toxicity_level` varchar(50) DEFAULT NULL,
  `safe_interval` varchar(50) DEFAULT NULL,
  `dilution_ratio` varchar(100) DEFAULT NULL,
  `usage_method` text,
  `approval_number` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of pesticides
-- ----------------------------
BEGIN;
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (1, '多菌灵', '多菌灵50%可湿性粉剂', '低毒', '7-10天', '1:800-1000', '喷雾，每公顷用量750-1125克', 'PD85123-15', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (2, '百菌清', '百菌清75%可湿性粉剂', '低毒', '7天', '1:600-800', '喷雾，每公顷用量1500-2250克', 'PD86123-20', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (3, '甲基托布津', '甲基托布津70%可湿性粉剂', '低毒', '7-10天', '1:1000-1500', '喷雾，每公顷用量750-1125克', 'PD87123-25', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (4, '敌敌畏', '敌敌畏80%乳油', '中等毒', '7-10天', '1:800-1000', '喷雾，每公顷用量750-1125毫升', 'PD88123-30', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (5, '吡虫啉', '吡虫啉10%可湿性粉剂', '低毒', '7-14天', '1:2000-3000', '喷雾，每公顷用量150-225克', 'PD89123-35', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (6, '阿维菌素', '阿维菌素1.8%乳油', '低毒', '7-14天', '1:2000-3000', '喷雾，每公顷用量450-675毫升', 'PD90123-40', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (7, '三唑酮', '三唑酮20%乳油', '低毒', '7-10天', '1:1000-1500', '喷雾，每公顷用量750-1125毫升', 'PD91123-45', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (8, '代森锰锌', '代森锰锌80%可湿性粉剂', '低毒', '7-10天', '1:600-800', '喷雾，每公顷用量1500-2250克', 'PD92123-50', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (9, '氯氰菊酯', '氯氰菊酯10%乳油', '中等毒', '7-10天', '1:2000-3000', '喷雾，每公顷用量300-450毫升', 'PD93123-55', '2024-01-01 10:00:00');
INSERT INTO `pesticides` (`id`, `name`, `composition`, `toxicity_level`, `safe_interval`, `dilution_ratio`, `usage_method`, `approval_number`, `created_at`) VALUES (10, '噻虫嗪', '噻虫嗪25%水分散粒剂', '低毒', '7-14天', '1:3000-5000', '喷雾，每公顷用量75-150克', 'PD94123-60', '2024-01-01 10:00:00');
COMMIT;

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `content` text NOT NULL,
  `images` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `farmers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of posts
-- ----------------------------
BEGIN;
INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `images`, `created_at`) VALUES (1, 1, '水稻种植经验分享', '今年种植水稻，采用了新的种植技术，产量比去年提高了15%。主要经验是：1.选用抗病品种；2.合理密植；3.控制氮肥用量；4.及时防治病虫害。', '[\"/images/post1_1.jpg\", \"/images/post1_2.jpg\"]', '2024-06-05 10:00:00');
INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `images`, `created_at`) VALUES (2, 2, '番茄病虫害防治心得', '番茄种植过程中，早疫病是比较常见的病害。我的防治经验是：1.选用抗病品种；2.合理密植；3.发病初期及时用药；4.加强田间管理。', '[\"/images/post2_1.jpg\"]', '2024-06-08 14:30:00');
INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `images`, `created_at`) VALUES (3, 3, '玉米高产栽培技术', '今年玉米产量不错，分享一下栽培技术：1.选用优良品种；2.适时播种；3.合理密植；4.科学施肥；5.及时防治病虫害。', '[\"/images/post3_1.jpg\", \"/images/post3_2.jpg\"]', '2024-06-12 09:20:00');
INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `images`, `created_at`) VALUES (4, 5, '黄瓜霜霉病防治经验', '黄瓜霜霉病是常见病害，我的防治经验是：1.选用抗病品种；2.合理密植；3.及时通风；4.发病初期及时用药。', '[\"/images/post4_1.jpg\"]', '2024-06-15 11:40:00');
INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `images`, `created_at`) VALUES (5, 7, '小麦白粉病防治方法', '小麦白粉病防治要点：1.选用抗病品种；2.合理密植；3.控制氮肥用量；4.发病初期及时用药；5.加强田间管理。', '[\"/images/post5_1.jpg\"]', '2024-06-18 16:10:00');
INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `images`, `created_at`) VALUES (6, 9, '茶叶种植管理经验', '茶叶种植要注意：1.选用优良品种；2.合理密植；3.科学施肥；4.及时防治病虫害；5.适时采摘。', '[\"/images/post6_1.jpg\", \"/images/post6_2.jpg\"]', '2024-06-20 13:25:00');
INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `images`, `created_at`) VALUES (7, 12, '草莓病虫害综合防治', '草莓种植过程中，红蜘蛛是比较常见的害虫。防治方法：1.选用抗虫品种；2.合理密植；3.保持田间湿度；4.发生初期及时用药。', '[\"/images/post7_1.jpg\"]', '2024-06-25 10:50:00');
INSERT INTO `posts` (`id`, `user_id`, `title`, `content`, `images`, `created_at`) VALUES (8, 15, '有机农业种植心得', '采用有机农业种植方式，虽然产量略低，但品质更好，价格也更高。主要措施：1.使用有机肥；2.生物防治病虫害；3.轮作倒茬；4.加强田间管理。', '[\"/images/post8_1.jpg\"]', '2024-06-28 15:30:00');
COMMIT;

-- ----------------------------
-- Table structure for questions
-- ----------------------------
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `crop_id` bigint DEFAULT NULL,
  `question_text` text NOT NULL,
  `images` json DEFAULT NULL,
  `status` enum('pending','answered') DEFAULT 'pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `crop_id` (`crop_id`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `farmers` (`id`),
  CONSTRAINT `questions_ibfk_2` FOREIGN KEY (`crop_id`) REFERENCES `crops` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of questions
-- ----------------------------
BEGIN;
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (1, 1, 1, '我的水稻叶片上出现了很多褐色病斑，病斑中央是灰白色的，这是什么病？应该怎么防治？', '[\"/images/question1_1.jpg\", \"/images/question1_2.jpg\"]', 'answered', '2024-06-10 09:30:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (2, 2, 8, '番茄叶片上出现了圆形病斑，有同心轮纹，这是什么病害？', '[\"/images/question2_1.jpg\"]', 'answered', '2024-06-12 14:20:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (3, 3, 3, '玉米叶片上出现了长条形病斑，中央灰褐色，边缘深褐色，这是什么病？', '[\"/images/question3_1.jpg\", \"/images/question3_2.jpg\"]', 'answered', '2024-06-15 10:15:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (4, 4, 1, '水稻叶片上出现了云纹状病斑，这是什么病害？', '[\"/images/question4_1.jpg\"]', 'answered', '2024-06-18 11:45:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (5, 5, 9, '黄瓜叶片背面有灰黑色霉层，叶片正面出现多角形病斑，这是什么病？', '[\"/images/question5_1.jpg\"]', 'answered', '2024-06-20 08:30:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (6, 6, 5, '棉花上有很多虫子，棉铃被蛀食了，这是什么害虫？', '[\"/images/question6_1.jpg\"]', 'answered', '2024-06-22 15:20:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (7, 7, 2, '小麦叶片上出现了白色粉状物，这是什么病害？', '[\"/images/question7_1.jpg\"]', 'answered', '2024-06-25 09:10:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (8, 9, 13, '茶叶叶片上出现了黄白色小点，叶片背面有很多小虫，这是什么害虫？', '[\"/images/question8_1.jpg\"]', 'answered', '2024-06-28 13:40:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (9, 10, 1, '水稻叶片卷曲，上面有很多小虫子，这是什么害虫？', '[\"/images/question9_1.jpg\"]', 'pending', '2024-07-01 10:20:00');
INSERT INTO `questions` (`id`, `user_id`, `crop_id`, `question_text`, `images`, `status`, `created_at`) VALUES (10, 12, 11, '草莓叶片上出现了红色小虫，叶片变黄了，这是什么害虫？', '[\"/images/question10_1.jpg\"]', 'pending', '2024-07-03 14:50:00');
COMMIT;

-- ----------------------------
-- Table structure for solutions
-- ----------------------------
DROP TABLE IF EXISTS `solutions`;
CREATE TABLE `solutions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `disease_id` bigint NOT NULL,
  `method_type` enum('agriculture','chemical','biological','physical') NOT NULL,
  `content` text NOT NULL,
  `cost` varchar(100) DEFAULT NULL,
  `difficulty` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `disease_id` (`disease_id`),
  CONSTRAINT `solutions_ibfk_1` FOREIGN KEY (`disease_id`) REFERENCES `diseases` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of solutions
-- ----------------------------
BEGIN;
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (1, 1, 'agriculture', '选用抗病品种，合理密植，控制氮肥用量，浅水勤灌，及时晒田。', '低', '简单', '2024-01-10 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (2, 1, 'chemical', '发病初期用多菌灵50%可湿性粉剂1:800倍液或甲基托布津70%可湿性粉剂1:1000倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '中等', '中等', '2024-01-10 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (3, 1, 'biological', '使用枯草芽孢杆菌等生物制剂，每公顷用量1500-2250克，兑水750-1125升喷雾。', '中等', '中等', '2024-01-10 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (4, 2, 'agriculture', '选用抗病品种，合理密植，控制氮肥用量，浅水勤灌，及时晒田，清除病残体。', '低', '简单', '2024-01-10 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (5, 2, 'chemical', '发病初期用井冈霉素5%水剂1:1000倍液或多菌灵50%可湿性粉剂1:800倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '中等', '中等', '2024-01-10 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (6, 3, 'agriculture', '选用抗病品种，合理密植，控制氮肥用量，及时通风，清除病残体。', '低', '简单', '2024-03-05 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (7, 3, 'chemical', '发病初期用三唑酮20%乳油1:1000倍液或多菌灵50%可湿性粉剂1:800倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '中等', '中等', '2024-03-05 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (8, 4, 'agriculture', '选用抗病品种，合理密植，控制氮肥用量，及时排水，清除病残体。', '低', '简单', '2024-02-10 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (9, 4, 'chemical', '发病初期用代森锰锌80%可湿性粉剂1:600倍液或多菌灵50%可湿性粉剂1:800倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '中等', '中等', '2024-02-10 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (10, 5, 'agriculture', '选用抗病品种，合理密植，控制氮肥用量，及时通风，清除病残体。', '低', '简单', '2024-01-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (11, 5, 'chemical', '发病初期用百菌清75%可湿性粉剂1:600倍液或代森锰锌80%可湿性粉剂1:600倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '中等', '中等', '2024-01-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (12, 6, 'agriculture', '选用抗病品种，合理密植，控制氮肥用量，及时通风，清除病残体。', '低', '简单', '2024-01-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (13, 6, 'chemical', '发病初期用百菌清75%可湿性粉剂1:600倍液或代森锰锌80%可湿性粉剂1:600倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '中等', '中等', '2024-01-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (14, 7, 'agriculture', '选用抗虫品种，合理密植，控制氮肥用量，及时清除杂草，保护天敌。', '低', '简单', '2024-04-01 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (15, 7, 'chemical', '发生初期用吡虫啉10%可湿性粉剂1:2000倍液或噻虫嗪25%水分散粒剂1:3000倍液喷雾防治，每隔7-14天喷一次，连续2-3次。', '中等', '中等', '2024-04-01 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (16, 7, 'biological', '释放瓢虫、草蛉等天敌，每公顷释放5000-10000头。', '中等', '中等', '2024-04-01 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (17, 8, 'agriculture', '选用抗虫品种，合理密植，保持田间湿度，保护天敌。', '低', '简单', '2024-04-01 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (18, 8, 'chemical', '发生初期用阿维菌素1.8%乳油1:2000倍液或氯氰菊酯10%乳油1:2000倍液喷雾防治，每隔7-14天喷一次，连续2-3次。', '中等', '中等', '2024-04-01 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (19, 8, 'biological', '释放捕食螨等天敌，每公顷释放10000-20000头。', '中等', '中等', '2024-04-01 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (20, 9, 'agriculture', '选用抗虫品种，合理密植，控制氮肥用量，及时清除杂草，保护天敌。', '低', '简单', '2024-03-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (21, 9, 'chemical', '发生初期用氯氰菊酯10%乳油1:2000倍液或敌敌畏80%乳油1:800倍液喷雾防治，每隔7-10天喷一次，连续2-3次。', '中等', '中等', '2024-03-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (22, 9, 'biological', '释放赤眼蜂等天敌，每公顷释放50000-100000头。', '中等', '中等', '2024-03-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (23, 10, 'agriculture', '选用抗虫品种，合理密植，控制氮肥用量，及时清除杂草，保护天敌。', '低', '简单', '2024-03-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (24, 10, 'chemical', '发生初期用吡虫啉10%可湿性粉剂1:2000倍液或噻虫嗪25%水分散粒剂1:3000倍液喷雾防治，每隔7-14天喷一次，连续2-3次。', '中等', '中等', '2024-03-15 10:00:00');
INSERT INTO `solutions` (`id`, `disease_id`, `method_type`, `content`, `cost`, `difficulty`, `created_at`) VALUES (25, 10, 'biological', '释放瓢虫、草蛉等天敌，每公顷释放5000-10000头。', '中等', '中等', '2024-03-15 10:00:00');
COMMIT;

-- ----------------------------
-- Table structure for weatherForcast
-- ----------------------------
DROP TABLE IF EXISTS `weatherForcast`;
CREATE TABLE `weatherForcast` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `location` varchar(200) NOT NULL,
  `temperature` varchar(50) DEFAULT NULL,
  `humidity` varchar(50) DEFAULT NULL,
  `rainfall` varchar(50) DEFAULT NULL,
  `wind_speed` varchar(50) DEFAULT NULL,
  `pest_risk_level` varchar(50) DEFAULT NULL,
  `forecast_time` datetime NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of weatherForcast
-- ----------------------------
BEGIN;
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (1, '江苏省南京市', '25-30℃', '65-75%', '5-10mm', '2-3级', '中等', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (2, '江苏省苏州市', '26-31℃', '70-80%', '10-15mm', '2-3级', '较高', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (3, '江苏省徐州市', '28-33℃', '55-65%', '0-5mm', '3-4级', '较低', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (4, '江苏省常州市', '24-29℃', '68-78%', '8-12mm', '2-3级', '中等', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (5, '江苏省无锡市', '25-30℃', '72-82%', '12-18mm', '2-3级', '较高', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (6, '江苏省南通市', '23-28℃', '75-85%', '15-20mm', '3-4级', '高', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (7, '江苏省盐城市', '27-32℃', '60-70%', '3-8mm', '3-4级', '中等', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (8, '江苏省扬州市', '24-29℃', '70-80%', '10-15mm', '2-3级', '较高', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (9, '江苏省镇江市', '25-30℃', '68-78%', '8-12mm', '2-3级', '中等', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
INSERT INTO `weatherForcast` (`id`, `location`, `temperature`, `humidity`, `rainfall`, `wind_speed`, `pest_risk_level`, `forecast_time`, `created_at`) VALUES (10, '江苏省泰州市', '26-31℃', '72-82%', '12-18mm', '2-3级', '较高', '2024-06-15 08:00:00', '2024-06-15 07:00:00');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
