FROM hub.cmtech-soft.com/k8s/centos:centos8.1.1911

USER root

RUN yum install openssh-clients -y

ENTRYPOINT [ "/bin/sh", "-c", "while true;do echo hello;sleep 1;done" ]