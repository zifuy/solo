FROM openjdk:8-alpine

COPY target/solo /app/

WORKDIR /app

ENV TZ=Asia/Shanghai

EXPOSE 8080

ENTRYPOINT [ "java", "-cp", "lib/*:.", "org.b3log.solo.Server" ]
