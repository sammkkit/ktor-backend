# Use the official Kotlin base image
FROM openjdk:17-jdk-alpine AS build

# Set the working directory
WORKDIR /app

# Copy the build.gradle.kts and settings.gradle.kts files
COPY build.gradle.kts ./
COPY settings.gradle.kts ./

# Copy the source code
COPY src ./src

# Copy the gradle wrapper
COPY gradlew ./
COPY gradle ./gradle

# Build the project
RUN ./gradlew build

# Start a new stage for the runtime image
FROM openjdk:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the built jar file from the previous stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
