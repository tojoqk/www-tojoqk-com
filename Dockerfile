FROM amazonlinux:2017.03.1.20170812

RUN curl -o install.sh https://www.cs.utah.edu/plt/installers/7.2/racket-7.2-x86_64-linux.sh \
    && yes yes | sh install.sh --unix-style --dest /usr

RUN yum -y update \
    && yum install -y epel-release \
    && yum install -y npm --enablerepo=epel
