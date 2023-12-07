FROM gradle:7.3.1-jdk17 AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle bootJar --no-daemon


FROM openjdk:8u181-jdk-alpine
EXPOSE 8080
RUN mkdir /app
RUN mkdir -p /home/tomita
COPY --from=builder /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar
COPY ./password.txt /home/tomita/
COPY ./confidential.txt /home/tomita/
RUN apk add openssl
CMD ["java", "-jar", "/app/spring-boot-application.jar"]
