FROM openjdk:8-alpine as test

COPY target/solo /app/

WORKDIR /app

ENV TZ=Asia/Shanghai

EXPOSE 8080

ENTRYPOINT [ "java", "-cp", "lib/*:.", "org.b3log.solo.Server" ]

FROM openjdk:8-alpine as dev

COPY target/solo /app/

WORKDIR /app

ENV TZ=Asia/Shanghai

EXPOSE 8080

ENTRYPOINT [ "java", "-cp", "lib/*:.", "org.b3log.solo.Server" ]

FROM openjdk:8-alpine as prod

COPY target/solo /app/

WORKDIR /app

ENV TZ=Asia/Shanghai

EXPOSE 8080

ENTRYPOINT [ "java", "-cp", "lib/*:.", "org.b3log.solo.Server" ]
