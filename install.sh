#!/bin/bash
# install.sh
# Miguel Jimenez
# To use execute: sudo -E ./install.sh

function show {
        echo ""
	echo "-----------------------------------"
	echo " $1"
	echo "-----------------------------------"
        echo ""
}

show "ADDING REPOSITORIES"
echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -

show "INSTALLING DEPENDENCIES"
apt-get -y update && apt-get install -y wget unzip vsftpd openssh-server rabbitmq-server

show "ADDING USER frascati:frascati"
useradd -m -s /bin/bash frascati && echo "frascati:frascati" | chpasswd
adduser frascati sudo

show "DOWNLOADING FRASCATI"
mkdir /tmp/files
cd /tmp/files
wget -c http://download.forge.ow2.org/frascati/frascati-1.4-bin.zip -P /tmp/files
unzip frascati-1.4-bin.zip -d /opt/

show "DOWNLOADING JAVA 1.6_23"
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/6u23-b05/jdk-6u23-linux-x64.bin -P /tmp/files
chmod a+x jdk-6u23-linux-x64.bin
./jdk-6u23-linux-x64.bin
mkdir /opt/jdk
mv jdk1.6.0_23 /opt/jdk

show "UPDATING FRASCATI BINARIES"
wget https://raw.githubusercontent.com/jachinte/frascati-binaries/master/frascati
mv frascati /opt/frascati-runtime-1.4/bin/
chmod a+x /opt/frascati-runtime-1.4/bin/frascati

p=0
if [ -z "$JAVA_HOME" ]; then
	p=$((p + 2))
	bash -c 'echo "export JAVA_HOME=/opt/jdk/jdk1.6.0_23" >> /etc/profile'
fi

if [ -z "$FRASCATI_HOME" ]; then
	p=$((p + 3))
	bash -c 'echo "export FRASCATI_HOME=/opt/frascati-runtime-1.4" >> /etc/profile'
fi  

if [ "$p" = 2 ]; then
	bash -c 'echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile'
fi
if [ "$p" = 3 ]; then
	bash -c 'echo "export PATH=\$PATH:\$FRASCATI_HOME/bin" >> /etc/profile'
fi
if [ "$p" = 5 ]; then
	bash -c 'echo "export PATH=\$PATH:\$JAVA_HOME/bin:\$FRASCATI_HOME/bin" >> /etc/profile'
fi

show "INSTALLING RABBITMQ MANAGEMENT PLUGIN"
rabbitmq-plugins enable rabbitmq_management
wget -c http://localhost:15672/cli/rabbitmqadmin -P /opt/rabbitmq-cli
chmod a+x /opt/rabbitmq-cli/rabbitmqadmin

r=false
if ! hash rabbitmqadmin 2>/dev/null; then
	r=true
	p=$((p + 1))
	bash -c 'echo "export PATH=\$PATH:/opt/rabbitmq-cli" >> /etc/profile'
fi

if [ "$p" -gt "0" ]; then
	show "ENVIRONMENT VARIABLES UPDATED"
	. /etc/profile
	show "COPY AND PASTE: source /etc/profile"
fi

if [ "$r" = "true" ]; then
	show "CREATING RABBITMQ EXCHANGES"
	rabbitmqadmin declare exchange --vhost=/ name=namespaces_exchange type=topic -u guest -p guest durable=true
	rabbitmqadmin declare exchange --vhost=/ name=probes_exchange type=direct -u guest -p guest durable=true
	rabbitmqadmin declare exchange --vhost=/ name=monitors_exchange type=direct -u guest -p guest durable=true
	rabbitmqadmin declare exchange --vhost=/ name=logs_namespace type=fanout -u guest -p guest durable=true
	rabbitmqadmin declare exchange --vhost=/ name=rpc_exchange type=direct -u guest -p guest durable=true
fi
