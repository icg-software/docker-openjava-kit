#!/bin/bash

rm /var/opt/firstboot

if [[ ! -z "${JENKINS_PWD}" ]]
then
    if [ "${JENKINS_PWD}" = "NONE" ]
    then
        echo "jenkins:`openssl rand -hex 13`" | chpasswd
    else
        echo "jenkins:${JENKINS_PWD}" | chpasswd
    fi
fi

if [ "${SSH_KEYGEN}" = "true" ]
then
    echo "generate ssh host keys"
    rm /etc/ssh/ssh_host_*
    /usr/bin/ssh-keygen -A
fi

