# —————————————————————————————————————
# 第一阶段：编译阶段（builder）
# —————————————————————————————————————
FROM maven:3.8.7-openjdk-17 AS builder

# 设置工作目录
WORKDIR /build

# 先复制 pom.xml（或 build 文件），下载依赖
COPY pom.xml .
# 如果有父 POM 和 settings 等需要的文件，可一并复制
# COPY settings.xml .

RUN mvn dependency:go-offline -B

# 复制代码
COPY src ./src

# 编译打包（跳过测试或者保留测试看你需求）
RUN mvn clean package -DskipTests

# —————————————————————————————————————
# 第二阶段：运行阶段（runtime）
# —————————————————————————————————————
FROM openjdk:17-jdk-slim

# 设置环境变量，如果需要
ENV TZ=Asia/Shanghai \
    JAVA_OPTS=""

# 应用在容器中的工作目录
WORKDIR /app

# 从构建阶段复制打包好的 fat jar
# 假设编译阶段输出的是 target/simple-sb-app.jar
COPY --from=builder /build/target/simple-sb-app.jar app.jar

# 暴露端口（根据你的 Spring Boot 配置，默认是 8080，也可能是别的）
EXPOSE 8080

# 启动命令
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
