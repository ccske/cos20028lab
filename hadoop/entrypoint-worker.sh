#!/usr/bin/env bash

set -euo pipefail
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(which java)")")")"

gosu hdfs bash -lc "HADOOP_LOG_DIR=/var/log/hadoop/hdfs $HADOOP_HOME/bin/hdfs --daemon start datanode"
gosu yarn bash -lc "HADOOP_LOG_DIR=/var/log/hadoop/yarn YARN_LOG_DIR=/var/log/hadoop/yarn $HADOOP_HOME/bin/yarn --daemon start nodemanager"

echo "Worker services started: DataNode (hdfs), NodeManager (yarn)."
trap 'echo "Stopping worker..."; gosu yarn $HADOOP_HOME/bin/yarn --daemon stop nodemanager || true; gosu hdfs $HADOOP_HOME/bin/hdfs --daemon stop datanode || true; exit 0' SIGTERM SIGINT
tail -f /dev/null & wait $!
