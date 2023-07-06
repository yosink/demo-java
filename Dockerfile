FROM maven:3.8-openjdk-17-slim AS builder
LABEL stage=javabuilder
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories


# RUN git config --global url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf "https://github.com"

WORKDIR /build

COPY . .
RUN mvn clean package


FROM openjdk:21-ea-17-jdk-slim-buster
ENV TZ Asia/Shanghai
WORKDIR /app
COPY --from=builder /build/target/springboot-hello.jar /app/springboot-hello.jar

RUN chmod +x /app/springboot-hello.jar

CMD ["java", "-jar", "/app/springboot-hello.jar"]