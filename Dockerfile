# Stage 1: Build the Java application
FROM maven:3.9.8-eclipse-temurin-8 AS builder

# Set the working directory
WORKDIR /app

# Copy the application source code
COPY . ./

# Build the application using Maven
RUN mvn clean install

# Stage 2: Create the image for running the application
FROM eclipse-temurin:8-jre

# Set the working directory
WORKDIR /home/azureuser

# Set permissions for the azureuser
RUN chgrp -R 0 /home/azureuser && \
    chmod -R g=u /home/azureuser

# Copy the WAR file from the build stage
COPY --from=builder /app/target/sparkjava-hello-world-*.war /home/azureuser/sparkjava-hello-world.war

# Change to the azureuser
USER azureuser

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/home/azureuser/sparkjava-hello-world.war"]
