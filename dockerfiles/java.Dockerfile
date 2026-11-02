FROM maven:3-eclipse-temurin-21 AS build
WORKDIR /src
COPY . .
RUN if [ -f pom.xml ]; then mvn -B -DskipTests package && cp target/*.jar /app.jar; \
    else ./gradlew bootJar -x test && cp build/libs/*.jar /app.jar; fi

FROM eclipse-temurin:21-jre
COPY --from=build /app.jar /app.jar
ENV PORT=8080 SERVER_PORT=8080
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
