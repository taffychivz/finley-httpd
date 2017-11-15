#!/bin/bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

export DB_USER=$(cat /run/secrets/sonardbuser)
export DB_PASSWORD=$(cat /run/secrets/sonardbpassword)
export DB_URL=$(cat /run/secrets/sonardburl)

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$DB_USER" \
  -Dsonar.jdbc.password="$DB_PASSWORD" \
  -Dsonar.jdbc.url="$DB_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
