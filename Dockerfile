FROM bitnami/git AS codes
WORKDIR /codes

RUN git clone https://github.com/yosink/demo-java.git

FROM maven:3.8-openjdk-17-slim AS builder
LABEL stage=javabuilder

WORKDIR /build

COPY --from=codes /codes/demo-java /build/

RUN mvn clean package


FROM openjdk:21-ea-17-jdk-slim-buster
ENV TZ Asia/Shanghai
WORKDIR /app
COPY --from=builder /build/target/springboot-hello.jar /app/springboot-hello.jar

RUN chmod +x /app/springboot-hello.jar

CMD ["java", "-jar", "/app/springboot-hello.jar"]