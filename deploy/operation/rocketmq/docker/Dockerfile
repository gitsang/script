FROM centos:7

# environment
ARG version
ENV ROCKETMQ_VERSION ${version}
ENV ROCKETMQ_TARGET rocketmq-${ROCKETMQ_VERSION}
ENV ROCKETMQ_HOME /home/rocketmq/rocketmq-${ROCKETMQ_VERSION}

# install depandancy
RUN yum install -y java-1.8.0-openjdk-devel.x86_64
RUN yum install -y unzip gettext nmap-ncat openssl telnet, which gnupg
RUN yum clean all -y

# copy target file
COPY ${ROCKETMQ_TARGET} ${ROCKETMQ_HOME}
COPY scripts/runserver.sh ${ROCKETMQ_HOME}/bin/runserver.sh
COPY scripts/runbroker.sh ${ROCKETMQ_HOME}/bin/runbroker.sh

# change java ext dir
RUN sed -i 's/${JAVA_HOME}\/jre\/lib\/ext/${JAVA_HOME}\/jre\/lib\/ext:${JAVA_HOME}\/lib\/ext/' ${ROCKETMQ_HOME}/bin/tools.sh

# running info
ARG user=rocketmq
ARG group=rocketmq
ARG uid=3000
ARG gid=3000

RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user}

USER ${user}
WORKDIR ${ROCKETMQ_HOME}/bin
