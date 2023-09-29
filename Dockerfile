# Use the official Maven image as the build stage
FROM maven:3.6.3 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files (pom.xml and source code) into the container
COPY pom.xml .
COPY server/ server/
COPY webapp/ webapp/

# Build the Java web application using Maven
RUN mvn clean install

# Use the official Tomcat image as the runtime stage
FROM tomcat:8

# Remove the default Tomcat applications (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the Java web application WAR file from the build stage to the Tomcat webapps directory
COPY --from=build /app/webapp/target/webapp.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port (8080) if needed
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]
