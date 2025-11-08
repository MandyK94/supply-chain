#!/bin/sh
MVNW_REPOURL=""
MVNW_VERBOSE=""
WRAPPER_JAR=".mvn/wrapper/maven-wrapper.jar"
WRAPPER_LAUNCHER="org.apache.maven.wrapper.MavenWrapperMain"
exec java -Dmaven.multiModuleProjectDirectory="$PWD" -cp "$WRAPPER_JAR" $WRAPPER_LAUNCHER "$@"
