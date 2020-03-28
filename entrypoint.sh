#!/bin/bash

if [ "${MVN_IMPLEMENTATION}" = "MVN33" ]
then
    sudo /bin/switch_mvn_impl.sh mvn33
fi

if [ "${MVN_IMPLEMENTATION}" = "MVN35" ]
then
    sudo /bin/switch_mvn_impl.sh mvn35
fi

if [ "${MVN_IMPLEMENTATION}" = "MVN36" ]
then
    sudo /bin/switch_mvn_impl.sh mvn36
fi

if [ -f /var/opt/firstboot ]
then
    sudo /sbin/initjdk.sh
fi

export JENKINS_PWD=''

for arg in "$@"
do
    shift
    [ "$arg" = "-launchjnlp" ] && export LAUNCH_JNLP="true" && continue
    set -- "$@" "$arg"
done

if [ "${LAUNCH_JNLP}" = "true" ]
then
    echo jenkins-agent "$@";
    /usr/local/bin/jenkins-agent "$@";
    exit;
fi

exec "$@"
