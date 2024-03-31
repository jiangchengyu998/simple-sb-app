#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=`mvn -q -DforceStdout help:evaluate -Dexpression=project.name`
set +x

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=`mvn -q -DforceStdout help:evaluate -Dexpression=project.version`
set +x

# 查找 application.properties 中包含 "server.port" 的行，并提取端口号
port=$(grep "server.port" src/main/resources/application.properties | cut -d'=' -f2)

echo "Spring Boot 应用端口号是: $port"

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x
docker build --build-arg NAME="${NAME}" --build-arg VERSION="${VERSION}" --build-arg PORT="${port}" -t "${NAME}"-"${VERSION}" ../../ -f ../../Dockerfile