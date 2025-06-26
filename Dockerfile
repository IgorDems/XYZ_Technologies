# Use the official Tomcat image with JDK 17
FROM tomcat:9-jdk17
# Author
LABEL maintainer="IgorDems"
# Optional: Clean the default webapps if you don't want the examples
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy your WAR file into the Tomcat webapps directory
COPY target/XYZtechnologies-1.0.war /usr/local/tomcat/webapps/
# Expose Tomcat default port
EXPOSE 8080
# Tomcat is started automatically (CMD is inherited from base image)
