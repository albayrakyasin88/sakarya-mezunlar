FROM tomcat:9.0-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY webapp /usr/local/tomcat/webapps/ROOT
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/lib && curl -L -o /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/postgresql-42.7.4.jar https://jdbc.postgresql.org/download/postgresql-42.7.4.jar
EXPOSE 8080
CMD ["catalina.sh", "run"]
