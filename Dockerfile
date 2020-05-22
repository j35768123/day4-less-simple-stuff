FROM maven:3.6.3-jdk-8-openj9 as builder
COPY . /usr/src/mymaven
WORKDIR /usr/src/mymaven
RUN mvn clean install -Dmaven.test.skip=true

# Use WebSphere Liberty base image from the Docker Store
FROM docker.io/websphere-liberty:javaee8

# Copy war from build stage and server.xml into image
COPY --from=builder /usr/src/mymaven/target/simple-stuff.war /config/dropins
COPY --from=builder /usr/src/mymaven/config/server.xml /config/
COPY --from=builder /usr/src/mymaven/config/server.env /config/
