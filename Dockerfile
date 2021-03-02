FROM tomcat:alpine

RUN wget -O usr/local/tomcat/webapps/demoApp.war -u admin:Learning http://192.168.18.90:8082

EXPOSE 8080

CMD['catalina.sh','bat']