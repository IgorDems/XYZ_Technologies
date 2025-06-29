# # Use the official Tomcat image with JDK 17
# FROM tomcat:9-jdk17
# # Author
# LABEL maintainer="IgorDems"
# # Optional: Clean the default webapps if you don't want the examples
# RUN rm -rf /usr/local/tomcat/webapps/*
# # Copy your WAR file into the Tomcat webapps directory
# COPY target/XYZtechnologies-1.0.war /usr/local/tomcat/webapps/
# # Expose Tomcat default port
# EXPOSE 8080
# # Tomcat is started automatically (CMD is inherited from base image)


# Use a minimal Ubuntu base image
FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for Java and Tomcat
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

# Create tomcat directory
RUN mkdir -p /opt/tomcat

# Install required packages and download stable Tomcat 9 manually
RUN apt-get update && \
    apt-get install -y wget curl openjdk-17-jdk && \
    wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.106/bin/apache-tomcat-9.0.106.tar.gz && \
    tar -xzf apache-tomcat-9.0.106.tar.gz -C /opt/tomcat --strip-components=1 && \
    rm apache-tomcat-9.0.106.tar.gz && \
    chmod +x /opt/tomcat/bin/*.sh

# Set environment variables
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

# Configure Tomcat users and roles
RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<tomcat-users xmlns="http://tomcat.apache.org/xml"\n\
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n\
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"\n\
              version="1.0">\n\
    <role rolename="manager-gui"/>\n\
    <role rolename="manager-script"/>\n\
    <role rolename="manager-jmx"/>\n\
    <role rolename="manager-status"/>\n\
    <role rolename="admin-gui"/>\n\
    <user username="admin" password="admin_password" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui"/>\n\
</tomcat-users>' > /opt/tomcat/conf/tomcat-users.xml

# Create and configure context.xml files for manager and host-manager
RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<Context antiResourceLocking="false" privileged="true" >\n\
  <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />\n\
</Context>' > /opt/tomcat/webapps/manager/META-INF/context.xml && \
    echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<Context antiResourceLocking="false" privileged="true" >\n\
  <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />\n\
</Context>' > /opt/tomcat/webapps/host-manager/META-INF/context.xml

# Ensure the directories exist for manager and host-manager
RUN mkdir -p /opt/tomcat/webapps/manager/META-INF \
    /opt/tomcat/webapps/host-manager/META-INF

COPY **/XYZtechnologies-1.0.war /opt/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Start Apache Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]




# # Copy your WAR application to the Tomcat webapps directory
# COPY **/XYZtechnologies-1.0.war /opt/tomcat/webapps/

# # Expose Tomcat default port
# EXPOSE 8080

# # Start Tomcat when the container launches
# CMD ["/opt/tomcat/bin/catalina.sh", "run"]
