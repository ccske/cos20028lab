export HADOOP_HOME=${HADOOP_HOME:-/opt/hadoop}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-$HADOOP_HOME/etc/hadoop}
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(which java)")")")"
export HADOOP_OPTS="${HADOOP_OPTS} -Dlog4j.configurationFile=file:${HADOOP_CONF_DIR}/log4j2.properties"
