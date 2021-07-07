FROM openjdk:8-jdk
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash unzip telnet tcpdump wget vim net-tools && \
    rm -rf /var/lib/apt/lists/*

ARG ROCKETMQ_VERSION
ENV ROCKETMQ_PKG pkg/rocketmq-all-${ROCKETMQ_VERSION}-bin-release
ENV ROCKETMQ_HOME /usr/local/rocketmq/rocketmq-${ROCKETMQ_VERSION}
ENV PATH ${PATH}:${ROCKETMQ_HOME}/bin

WORKDIR ${ROCKETMQ_HOME}
COPY ${ROCKETMQ_PKG} ${ROCKETMQ_HOME}
COPY scripts ${ROCKETMQ_HOME}/bin

RUN echo '. ~/.bash_aliases' >> /root/.bashrc
COPY .bash_aliases /root/
COPY .vimrc /root/

WORKDIR ${ROCKETMQ_HOME}/bin
