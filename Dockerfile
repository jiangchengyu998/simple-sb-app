# 使用官方 adoptopenjdk:17-jdk-hotspot 镜像作为基础镜像
FROM adoptopenjdk:17-jdk-hotspot

# 设置工作目录
WORKDIR /app

# 将本地的 JAR 文件复制到容器中的 /app 目录下
ARG NAME
ARG VERSION
RUN echo $NAME-$VERSION
COPY target/$NAME-$VERSION.jar $NAME-$VERSION.jar
#COPY target/*.jar app.jar

# 对外暴露的端口号
ARG PORT
RUN echo $PORT
EXPOSE $PORT

# 容器启动时运行的命令
CMD ["java", "-jar", "$NAME-$VERSION.jar"]
