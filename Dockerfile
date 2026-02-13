# 1. Tomcat 9.0 + JDK 11 환경
FROM tomcat:9.0-jdk11-openjdk-slim

# 2. 기본 webapps 제거 (선택)
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. 빌드된 WAR 파일을 Tomcat webapps에 복사
COPY target/household-budget.war /usr/local/tomcat/webapps/ROOT.war

# 4. 포트 개방
EXPOSE 8080

# 5. Tomcat 실행
CMD ["catalina.sh", "run"]
