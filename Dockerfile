FROM golang:1.15.5-buster as build

# for China User
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN echo \
# for China User
"deb http://mirrors.aliyun.com/debian buster main contrib non-free" \
"deb http://mirrors.aliyun.com/debian buster-proposed-updates main contrib non-free" \
"deb http://mirrors.aliyun.com/debian buster-updates main contrib non-free" \
"deb http://mirrors.aliyun.com/debian-security/ buster/updates main non-free contrib" \
"deb http://ftp.de.debian.org/debian buster main" \
> /etc/apt/sources.list

ARG USQL_VERSION=0.7.8

RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct

RUN apt-get update && apt-get install -y gettext-base tzdata libaio1 unzip && apt-get -y autoclean

COPY ./oracle/unixODBC* ./
RUN tar -xf unixODBC* && cd unixODBC-2.3.1 && sed -i "/^LIB_VERSION=/c\LIB_VERSION=1:0:0" configure && ./configure --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE && make && make install && echo /usr/local/lib/ >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf && ldconfig  && cd .. && rm -fr unixODBC*.tar.gz

RUN go get -u -tags all github.com/xo/usql@v${USQL_VERSION}

RUN mkdir /opt/oracle
COPY ./oracle/instantclient-* /opt/oracle/

RUN unzip -q -d /opt/oracle /opt/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip && unzip -q -d /opt/oracle /opt/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip && rm -fr /opt/oracle/instant*.zip

RUN ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/instantclient_12_1/libclntsh.so && ln -s /opt/oracle/instantclient_12_1/libocci.so.12.1 /opt/oracle/instantclient_12_1/libocci.so && echo /opt/oracle/instantclient_12_1 >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf && ldconfig

FROM build

WORKDIR /data

ENTRYPOINT ["usql"]
