FROM ghcr.io/icg-software/karaf-base:latest

LABEL maintainer="icgsoftware <j_liepe@icg-software.de>"

# Set installation details

ARG SYSTEM_LANG="de"
ARG SYSTEM_LOCALE="DE"
ARG SYSTEM_CHARSET="UTF-8"

ARG JAVA_VERSION_MAJOR=11
ARG RHEL_OPENJDK_PKG_NAME=java-${JAVA_VERSION_MAJOR}-openjdk
ARG MVN33_VERSION=3.3.9
ARG MVN35_VERSION=3.5.4
ARG MVN36_VERSION=3.6.3
ARG MVN38_VERSION=3.8.4
ARG APACHE_MIRROR=mirrors.sonic.net
ARG GRADLE_VERSION=6.7.1
ARG LTS_NODEJS=14
ARG JENKINS_USER_NAME=jenkins
ARG JENKINS_USER_ID=1000
ARG JNLP_VERSION=4.6
ARG AGENT_WORKDIR=/home/${JENKINS_USER_NAME}/agent
ARG JAVA_PATH=/usr/lib/jvm/java-11-openjdk

# complete RHEL installation

RUN \
	microdnf install langpacks-${SYSTEM_LANG} && \
	microdnf update -y && \
    microdnf install -y wget curl tar zip unzip vim sudo openssh-server openssh-clients openssl git subversion procps && \
    microdnf install -y ${RHEL_OPENJDK_PKG_NAME} ${RHEL_OPENJDK_PKG_NAME}-devel ${RHEL_OPENJDK_PKG_NAME}-javadoc ${RHEL_OPENJDK_PKG_NAME}-jmods ${RHEL_OPENJDK_PKG_NAME}-src && \
    mkdir /opt/jdk && ln -s /usr/lib/jvm/java /opt/jdk/latest 

# clean microdnf and prepare for first start

RUN microdnf clean all && \
    rm -rf /var/cache/microdnf && \
    touch /var/opt/firstboot && \
    /usr/bin/ssh-keygen -A

# my scripts

ADD ./switch_mvn_impl.sh /bin/switch_mvn_impl.sh
ADD ./initjdk.sh /sbin/initjdk.sh
ADD ./entrypoint.sh /entrypoint.sh

RUN \
	sed -ri "s/MVN33_VERSION=/MVN33_VERSION=${MVN33_VERSION}/g" /bin/switch_mvn_impl.sh && \
    sed -ri "s/MVN35_VERSION=/MVN35_VERSION=${MVN35_VERSION}/g" /bin/switch_mvn_impl.sh && \
    sed -ri "s/MVN36_VERSION=/MVN36_VERSION=${MVN36_VERSION}/g" /bin/switch_mvn_impl.sh && \
    sed -ri "s/MVN38_VERSION=/MVN38_VERSION=${MVN38_VERSION}/g" /bin/switch_mvn_impl.sh

RUN \
	chmod u+x /bin/switch_mvn_impl.sh && chmod u+x /sbin/initjdk.sh  && chmod u+x /entrypoint.sh && \
    echo 'Defaults    env_keep += "JENKINS_PWD SSH_KEYGEN JAVA_KIT_INIT_COMMAND"' >> /etc/sudoers.d/jdk && \
    echo "ALL ALL=(ALL) NOPASSWD:  /bin/switch_mvn_impl.sh" >> /etc/sudoers.d/jdk && \
    echo "ALL ALL=(ALL) NOPASSWD:  /sbin/initjdk.sh" >> /etc/sudoers.d/jdk
    
# install maven
    
RUN \
	wget http://${APACHE_MIRROR}/apache/maven/maven-3/${MVN33_VERSION}/binaries/apache-maven-${MVN33_VERSION}-bin.tar.gz && \
    tar -zxf apache-maven-${MVN33_VERSION}-bin.tar.gz && \
    tar -C /usr/local -xzf apache-maven-${MVN33_VERSION}-bin.tar.gz && \
    rm -f apache-maven-${MVN33_VERSION}-bin.tar.gz && \
    wget http://${APACHE_MIRROR}/apache/maven/maven-3/${MVN35_VERSION}/binaries/apache-maven-${MVN35_VERSION}-bin.tar.gz && \
    tar -zxf apache-maven-${MVN35_VERSION}-bin.tar.gz && \
    tar -C /usr/local -xzf apache-maven-${MVN35_VERSION}-bin.tar.gz && \
    rm -f apache-maven-${MVN35_VERSION}-bin.tar.gz && \
    wget http://${APACHE_MIRROR}/apache/maven/maven-3/${MVN36_VERSION}/binaries/apache-maven-${MVN36_VERSION}-bin.tar.gz && \
    tar -zxf apache-maven-${MVN36_VERSION}-bin.tar.gz && \
    tar -C /usr/local -xzf apache-maven-${MVN36_VERSION}-bin.tar.gz && \
    rm -f apache-maven-${MVN36_VERSION}-bin.tar.gz && \
    wget http://${APACHE_MIRROR}/apache/maven/maven-3/${MVN38_VERSION}/binaries/apache-maven-${MVN38_VERSION}-bin.tar.gz && \
    tar -zxf apache-maven-${MVN38_VERSION}-bin.tar.gz && \
    tar -C /usr/local -xzf apache-maven-${MVN38_VERSION}-bin.tar.gz && \
    rm -f apache-maven-${MVN38_VERSION}-bin.tar.gz
    
# install gradle

RUN \
	wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip -d /usr/local gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /usr/local/gradle-${GRADLE_VERSION} /opt/gradle && \
    ln -s /opt/gradle/bin/gradle /usr/bin/gradle && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip
    
# install nodejs / npm

RUN curl -sL https://rpm.nodesource.com/setup_${LTS_NODEJS}.x | sudo bash - && \
    microdnf install -y nodejs && \
    microdnf install -y gcc-c++ make

# switch to default settings

RUN /bin/switch_mvn_impl.sh mvn38

# jenkins stuff

RUN \
	groupadd -g ${JENKINS_USER_ID} ${JENKINS_USER_NAME} && useradd -m -d /home/${JENKINS_USER_NAME} -u ${JENKINS_USER_ID} -g ${JENKINS_USER_NAME} ${JENKINS_USER_NAME} && \
    echo "export M2_HOME=/opt/mvn" >> /home/${JENKINS_USER_NAME}/.profile && \
    echo "export M2_HOME=/opt/mvn" >> /home/${JENKINS_USER_NAME}/.bashrc && \
    echo "export JAVA_HOME=${JAVA_PATH}" >> /home/${JENKINS_USER_NAME}/.profile && \
    echo "export JAVA_HOME=${JAVA_PATH}" >> /home/${JENKINS_USER_NAME}/.bashrc && \
    echo "export JRE_HOME=${JAVA_PATH}/jre" >> /home/${JENKINS_USER_NAME}/.profile && \
    echo "export JRE_HOME=${JAVA_PATH}/jre" >> /home/${JENKINS_USER_NAME}/.bashrc && \
    mkdir /home/${JENKINS_USER_NAME}/.m2 && chown ${JENKINS_USER_NAME}.${JENKINS_USER_NAME} /home/${JENKINS_USER_NAME}/.m2 && \
    mkdir /home/${JENKINS_USER_NAME}/.jenkins && chown ${JENKINS_USER_NAME}.${JENKINS_USER_NAME} /home/${JENKINS_USER_NAME}/.jenkins && \
    mkdir ${AGENT_WORKDIR} &&  chown ${JENKINS_USER_NAME}.${JENKINS_USER_NAME} ${AGENT_WORKDIR} && \
    curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JNLP_VERSION}/remoting-${JNLP_VERSION}.jar && \
    chmod 755 /usr/share/jenkins && \
    chmod 644 /usr/share/jenkins/agent.jar && \
    ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar && \
    curl -fsSLo /usr/local/bin/jenkins-agent https://raw.githubusercontent.com/jenkinsci/docker-jnlp-slave/master/jenkins-agent && \
    chmod +x /usr/local/bin/jenkins-agent && ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

# Set environment variables.

ENV HOME=/root
ENV JAVA_HOME=${JAVA_PATH}
ENV JRE_HOME=${JAVA_PATH}
ENV JAVA_OPTS=
ENV M2_HOME=/opt/mvn
ENV MVN_IMPLEMENTATION=KEEP
ENV JENKINS_PWD=NONE
ENV LAUNCH_JNLP=false
ENV SSH_KEYGEN=false
ENV LANG=${SYSTEM_LANG}_${SYSTEM_LOCALE}.${SYSTEM_CHARSET}
ENV LANGUAGE=${SYSTEM_LANG}_${SYSTEM_LOCALE}:${SYSTEM_LANG}
ENV LC_ALL=${SYSTEM_LANG}_${SYSTEM_LOCALE}.${SYSTEM_CHARSET}
ENV JAVA_KIT_INIT_COMMAND=NONE
ENV AGENT_WORKDIR=${AGENT_WORKDIR}


# Define working directory.

WORKDIR ${HOME}

# Define entrypoint

ENTRYPOINT ["/entrypoint.sh"]

# Define default command.

CMD ["bash"] 
