FROM openjdk:19

COPY target/Waypoint-Nomad-PoC-1.0-SNAPSHOT.jar /poc.jar

ENTRYPOINT ["java", "-jar", "poc.jar"]