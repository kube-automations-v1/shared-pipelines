FROM ghcr.io/graalvm/native-image-community:21 AS build
WORKDIR /src
COPY . .
RUN if [ -f pom.xml ]; then mvn -B -Pnative -DskipTests native:compile; \
    else ./gradlew nativeCompile -x test; fi
RUN cp "$(find target build/native -maxdepth 3 -type f -perm -u+x ! -name '*.so' ! -name '*.sh' 2>/dev/null | head -1)" /app

FROM debian:bookworm-slim
COPY --from=build /app /app
ENV PORT=8080 SERVER_PORT=8080
EXPOSE 8080
ENTRYPOINT ["/app"]
