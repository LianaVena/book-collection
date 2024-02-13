#FROM maven:3-eclipse-temurin-17-alpine
#COPY pom.xml .
#RUN mvn clean package -DskipTests

FROM amazoncorretto:17-alpine3.19
ARG JAR_FILE=*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
