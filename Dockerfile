# FraSCAti 1.4 on Ubuntu 16.04 LTS
#
# VERSION 0.0.3

FROM ubuntu:16.04

MAINTAINER Miguel Jiménez <migueljimenezachinte@gmail.com>
LABEL Description="This image provides a fresh FraSCAti installation using an \
enhanced version of the binaries. You can read more about \
this at https://github.com/jachinte/frascati-binaries" \
      License="MIT" \
      Usage="docker run -d -p [HOST PORT NUMBER]:21 [HOST PORT NUMBER]:22" \
      Version="0.0.3"

COPY run.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/run.sh

# Make sure wget is installed
RUN apt-get -y update && apt-get install -y \
    wget \
    unzip \
    vsftpd \
    openssh-server \
    sudo

# Add user frascati (password: frascati)
RUN useradd -m -s /bin/bash frascati && echo "frascati:frascati" | chpasswd
RUN adduser frascati sudo

# SSH login fix. Otherwise user is kicked off after login (From: https://docs.docker.com/engine/examples/running_ssh_service/)
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Configure FTP
RUN sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
RUN sed -i 's/#local_umask=022/local_umask=022/' /etc/vsftpd.conf
RUN echo "pasv_enable=Yes" >> /etc/vsftpd.conf
RUN echo "pasv_min_port=40000" >> /etc/vsftpd.conf
RUN echo "pasv_max_port=40100" >> /etc/vsftpd.conf

# Download and install Oracle JDK 1.6.0_23
RUN mkdir /tmp/files && cd /tmp/files
RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/6u23-b05/jdk-6u23-linux-x64.bin
RUN chmod a+x jdk-6u23-linux-x64.bin
RUN ./jdk-6u23-linux-x64.bin
RUN mkdir /opt/jdk && mv jdk1.6.0_23 /opt/jdk

# Download and install FraSCAti
RUN wget http://download.forge.ow2.org/frascati/frascati-1.4-bin.zip
RUN unzip frascati-1.4-bin.zip -d /opt/

# Update the FraSCAti binary
RUN wget https://raw.githubusercontent.com/jachinte/frascati-binaries/master/frascati
RUN mv frascati /opt/frascati-runtime-1.4/bin/
RUN chmod a+x /opt/frascati-runtime-1.4/bin/frascati

# Environment variables
ENV JAVA_HOME /opt/jdk/jdk1.6.0_23
ENV FRASCATI_HOME /opt/frascati-runtime-1.4
ENV PATH $PATH:$JAVA_HOME/bin:$FRASCATI_HOME/bin

# Remove temporal directories
RUN rm -rf /tmp/files

# Expose FTP & SSH ports
EXPOSE 21 22

CMD ["/usr/local/bin/run.sh"]
