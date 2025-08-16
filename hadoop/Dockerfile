FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH
ARG HADOOP_VERSION=3.4.0
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates curl netcat-openbsd openjdk-11-jdk-headless procps gosu tini && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd hadoop && useradd -g hadoop -m hadoop && \
    groupadd hdfs && useradd -g hdfs -G hadoop -m hdfs && \
    groupadd yarn && useradd -g yarn -G hadoop -m yarn && \
    groupadd mapred && useradd -g mapred -G hadoop -m mapred

RUN set -eux && \
    case "${TARGETARCH:-unknown}" in \
      amd64)  HADOOP_TGZ="hadoop-${HADOOP_VERSION}.tar.gz" ;; \
      arm64)  HADOOP_TGZ="hadoop-${HADOOP_VERSION}-aarch64.tar.gz" ;; \
      *)      echo "Unsupported arch: ${TARGETARCH}"; exit 1 ;; \
    esac && \
    curl -fSL "https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/${HADOOP_TGZ}" -o /tmp/hadoop.tgz && \
    tar -xzf /tmp/hadoop.tgz -C /opt && \
    ln -s "/opt/hadoop-${HADOOP_VERSION}" ${HADOOP_HOME} && \
    rm -f /tmp/hadoop.tgz

RUN mkdir -p /data/namenode /data/datanode /var/log/hadoop/hdfs /var/log/hadoop/yarn /var/log/hadoop/mapred /var/lib/hadoop/tmp && \
    chown -R hadoop:hadoop /data /var/log/hadoop /var/lib/hadoop && \
    chown -R hdfs:hdfs /data/namenode /data/datanode /var/log/hadoop/hdfs && \
    chown -R yarn:yarn /var/log/hadoop/yarn && \
    chown -R mapred:mapred /var/log/hadoop/mapred && \
    chmod -R 775 /var/log/hadoop /data /var/lib/hadoop

COPY hadoop-env.sh yarn-env.sh mapred-env.sh ${HADOOP_CONF_DIR}/
COPY core-site.xml hdfs-site.xml yarn-site.xml mapred-site.xml ${HADOOP_CONF_DIR}/
COPY log4j2.properties ${HADOOP_CONF_DIR}/
COPY entrypoint-master.sh /usr/local/bin/entrypoint-master.sh
COPY entrypoint-worker.sh /usr/local/bin/entrypoint-worker.sh
RUN chmod +x /usr/local/bin/entrypoint-*.sh

ENTRYPOINT ["/usr/bin/tini", "--"]
