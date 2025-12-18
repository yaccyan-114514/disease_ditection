# Java 应用 Dockerfile
# 使用多阶段构建：先构建，再运行
FROM maven:3.9-eclipse-temurin-17 AS builder

# 设置工作目录
WORKDIR /build

# 复制项目文件
COPY pom.xml .
COPY src ./src

# 构建 WAR 文件
RUN mvn clean package -DskipTests

# 运行阶段：基于 Tomcat
FROM tomcat:9-jdk17-openjdk-slim

# 安装 unzip（用于解压 WAR 文件）
RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /usr/local/tomcat

# 从构建阶段复制 WAR 文件
COPY --from=builder /build/target/disease_ditection.war /usr/local/tomcat/webapps/

# 配置 Tomcat
# 保持应用路径为 /disease_ditection（与开发环境一致）
# 如果需要部署为 ROOT，取消下面的注释并注释掉上面的部署方式
# RUN rm -rf /usr/local/tomcat/webapps/ROOT && \
#     mv /usr/local/tomcat/webapps/disease_ditection.war /usr/local/tomcat/webapps/ROOT.war

# 保持 /disease_ditection 路径部署
RUN rm -rf /usr/local/tomcat/webapps/disease_ditection && \
    mkdir -p /usr/local/tomcat/webapps/disease_ditection && \
    unzip -q /usr/local/tomcat/webapps/disease_ditection.war -d /usr/local/tomcat/webapps/disease_ditection/ && \
    rm /usr/local/tomcat/webapps/disease_ditection.war

# 创建上传目录
RUN mkdir -p /usr/local/tomcat/webapps/disease_ditection/uploads && \
    chmod 755 /usr/local/tomcat/webapps/disease_ditection/uploads

# 暴露端口
EXPOSE 8080

# 启动 Tomcat
CMD ["catalina.sh", "run"]
