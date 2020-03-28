## OpenJDK and Java / JS tools based on CentOS:7

This is docker image provides OpenJDK and command lines build tools. 

### Source Repository

@see on [GitHub](https://github.com/spalarus/docker-openjava-kit) ([Dockerfile](https://github.com/spalarus/docker-openjava-kit/blob/master/Dockerfile))

### Purpose

* JRE
* Jenkins slave
* base image for java services
* command-line development

### Tools

* vi
* subversion
* git
* mvn (3.3, 3.5, 3.6)
* gradle 6.2.2
* nodejs 12.16.1
* npm 6.13.4

### Select java implementation 

**Run container**
```bash
docker run -it --rm spalarus/openjava-kit java -version 

openjdk version "11.0.6" 2020-01-14 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.6+10-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.6+10-LTS, mixed mode, sharing)
```
 
### Environment VARs

| VAR                  | Description                                   | Value                       |
|----------------------|-----------------------------------------------|-----------------------------|
| JDK_IMPLEMENTATION   | switch selecting JDK                          | ORACLEJDK / OPENJDK         |
| MVN_IMPLEMENTATION   | switch for MVN-Version                        | MVN33 / MVN35 / MVN36       |
| JENKINS_PWD          | set password for jenkins user                 | password for jenkins usr    |
| LAUNCH_JNLP          | run jenkins JNLP agent                        | true / false                |

### Docker Agent via SSH

This image can be used for [Jenkins Docker Plugin](https://wiki.jenkins.io/display/JENKINS/Docker+Plugin) as ssh-slave. You have to configure jenkins password by VAR JENKINS_PWD. Jenkins start sshd bei default (/usr/sbin/sshd -D) and expose port 22.

### Docker Agent via JNLP

Set VAR LAUNCH_JNLP to true.
