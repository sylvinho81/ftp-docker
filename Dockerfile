FROM centos

ARG USER
ARG PASS


RUN yum -y install openssl vsftpd firewalld && rm -rf /var/cache/yum/*

RUN useradd -ms /bin/bash $USER && echo $USER:$PASS | chpasswd

RUN firewall-cmd --zone=public --add-port=990/tcp --permanent
RUN firewall-cmd --reload


COPY vsftp.conf /etc/vsftp/vsftp.conf
COPY vsftp_ftps.conf /etc/vsftp/vsftp_ftps.conf
COPY vsftp_ftps_tls.conf /etc/vsftp/vsftp_ftps_tls.conf
COPY vsftp_ftps_implicit.conf /etc/vsftp/vsftp_ftps_implicit.conf
COPY start.sh /

RUN chmod +x /start.sh
RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/

VOLUME /home/$USER
VOLUME /var/log/vsftpd

EXPOSE 20 21 21100-21110

ENTRYPOINT ["/start.sh"]
