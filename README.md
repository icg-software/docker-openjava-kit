## OpenJDK and Java / JS tools based on CentOS:7

This docker image provides OpenJDK and other java and js command line build tools. 

### Source Repository

@see on [GitHub](https://github.com/spalarus/docker-openjava-kit) ([Dockerfile](https://github.com/spalarus/docker-openjava-kit/blob/master/Dockerfile))

### Use Case

* Jenkins agent
* command-line development

### Tools


* openjdk 11.0.9
* vi
* subversion
* git
* mvn (3.3, 3.5, 3.6)
* gradle 6.7.1
* nodejs 14.15.1
* npm 6.14.8

### RUN 

**OpenJDK java binary**
```bash
docker run -it --rm spalarus/openjava-kit java -version 
openjdk version "11.0.9" 2020-10-20 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.9+11-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.9+11-LTS, mixed mode, sharing)
```
 
### Environment VARs

| VAR                  | Description                                   | Value                       |
|----------------------|-----------------------------------------------|-----------------------------|
| MVN_IMPLEMENTATION   | switch for MVN-Version                        | MVN33 / MVN35 / MVN36       |
| JENKINS_PWD          | set password for jenkins user                 | password for jenkins usr    |
| LAUNCH_JNLP          | run jenkins JNLP agent                        | true / false                |

### Docker Agent via SSH

This image can be used as ssh-slave for [Jenkins Docker Plugin](https://wiki.jenkins.io/display/JENKINS/Docker+Plugin). You have to configure jenkins password by VAR JENKINS_PWD. Jenkins start sshd bei default (/usr/sbin/sshd -D) and expose port 22.

### Docker Agent via JNLP

Set VAR: LAUNCH_JNLP=true.
