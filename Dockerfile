FROM openjdk:15-slim
COPY target/spring-boot-web-0.0.1-SNAPSHOT.jar /home
CMD [ "java", "-jar", "/home/spring-boot-web-0.0.1-SNAPSHOT.jar" ]
