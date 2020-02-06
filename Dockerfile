FROM openjdk:15-slim
COPY spring-petclinic.jar /home
CMD [ "java", "-jar", "/home/spring-petclinic.jar" ]
