#!/usr/bin/env bash

set -euo pipefail
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(which java)")")")"

if [ ! -d "/data/namenode/current" ]; then
  echo "Formatting NameNode..."
  gosu hdfs bash -lc "HADOOP_LOG_DIR=/var/log/hadoop/hdfs $HADOOP_HOME/bin/hdfs namenode -format -force -nonInteractive"
fi

gosu hdfs bash -lc "HADOOP_LOG_DIR=/var/log/hadoop/hdfs $HADOOP_HOME/bin/hdfs --daemon start namenode"
gosu yarn bash -lc "HADOOP_LOG_DIR=/var/log/hadoop/yarn YARN_LOG_DIR=/var/log/hadoop/yarn $HADOOP_HOME/bin/yarn --daemon start resourcemanager"
gosu mapred bash -lc "HADOOP_LOG_DIR=/var/log/hadoop/mapred $HADOOP_HOME/bin/mapred --daemon start historyserver"

echo "Master services started: NameNode (hdfs), ResourceManager (yarn), HistoryServer (mapred)."
trap 'echo "Stopping master..."; gosu mapred $HADOOP_HOME/bin/mapred --daemon stop historyserver || true; gosu yarn $HADOOP_HOME/bin/yarn --daemon stop resourcemanager || true; gosu hdfs $HADOOP_HOME/bin/hdfs --daemon stop namenode || true; exit 0' SIGTERM SIGINT
tail -f /dev/null & wait $!
