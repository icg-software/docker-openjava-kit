#!/bin/bash

MVN33_VERSION=
MVN35_VERSION=
MVN36_VERSION=
MVN38_VERSION=

case "$1" in
    mvn33)
        echo "Set Maven 3.3"
        rm /opt/mvn
        rm /usr/bin/mvn
        rm /usr/bin/mvnDebug
        rm /usr/bin/mvnyjp
        rm /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN33_VERSION} /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN33_VERSION} /opt/mvn
        ln -s /usr/local/apache-maven-${MVN33_VERSION}/bin/mvn /usr/bin/mvn
        ln -s /usr/local/apache-maven-${MVN33_VERSION}/bin/mvnDebug /usr/bin/mvnDebug
        ln -s /usr/local/apache-maven-${MVN33_VERSION}/bin/mvnyjp /usr/bin/mvnyjp
        ;;

    mvn35)
        echo "Set Maven 3.5"
        rm /opt/mvn
        rm /usr/bin/mvn
        rm /usr/bin/mvnDebug
        rm /usr/bin/mvnyjp
        rm /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN35_VERSION} /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN35_VERSION} /opt/mvn
        ln -s /usr/local/apache-maven-${MVN35_VERSION}/bin/mvn /usr/bin/mvn
        ln -s /usr/local/apache-maven-${MVN35_VERSION}/bin/mvnDebug /usr/bin/mvnDebug
        ln -s /usr/local/apache-maven-${MVN35_VERSION}/bin/mvnyjp /usr/bin/mvnyjp
        ;;
        
    mvn36)
        echo "Set Maven 3.6"
        rm /opt/mvn
        rm /usr/bin/mvn
        rm /usr/bin/mvnDebug
        rm /usr/bin/mvnyjp
        rm /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN36_VERSION} /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN36_VERSION} /opt/mvn
        ln -s /usr/local/apache-maven-${MVN36_VERSION}/bin/mvn /usr/bin/mvn
        ln -s /usr/local/apache-maven-${MVN36_VERSION}/bin/mvnDebug /usr/bin/mvnDebug
        ln -s /usr/local/apache-maven-${MVN36_VERSION}/bin/mvnyjp /usr/bin/mvnyjp
        ;;
        
    mvn38)
        echo "Set Maven 3.8"
        rm /opt/mvn
        rm /usr/bin/mvn
        rm /usr/bin/mvnDebug
        rm /usr/bin/mvnyjp
        rm /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN38_VERSION} /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN38_VERSION} /opt/mvn
        ln -s /usr/local/apache-maven-${MVN38_VERSION}/bin/mvn /usr/bin/mvn
        ln -s /usr/local/apache-maven-${MVN38_VERSION}/bin/mvnDebug /usr/bin/mvnDebug
        ln -s /usr/local/apache-maven-${MVN38_VERSION}/bin/mvnyjp /usr/bin/mvnyjp
        ;;

esac
