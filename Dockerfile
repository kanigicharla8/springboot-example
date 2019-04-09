FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
copy pom.xml /tmp/
RUN mvn -B dependency:go-offline -f /tmp/pom.xml -s /usr/share/maven/ref/settings-docker.xml
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package

FROM openjdk:8-jdk-alpine
EXPOSE 8080

RUN mkdir /app
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/*.jar /app/springboot-example.jar

ENTRYPOINT ["java",o"-Djava.security.egd=file:/dev/./urandm","-jar","/app/springboot-example.jar"]