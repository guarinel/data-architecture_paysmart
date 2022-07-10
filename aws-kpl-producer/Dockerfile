FROM openjdk:11-jdk-slim

COPY target/aws-kpl-producer-jar-with-dependencies.jar app.jar

RUN cat > offsets.dat
RUN cat > log.dat

ENTRYPOINT ["java","-jar","app.jar"] 