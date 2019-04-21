FROM amazonlinux:latest

RUN yum -y update \
    && yum install -y tar gzip \
    && curl -o install.sh https://www.cs.utah.edu/plt/installers/7.2/racket-7.2-x86_64-linux.sh \
    && yes yes | sh install.sh --unix-style --dest /usr

RUN raco pkg install -n www-tojoqk-com --deps search-auto https://github.com/tojoqk/www-tojoqk-com.git
