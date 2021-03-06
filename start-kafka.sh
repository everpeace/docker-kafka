#!/bin/sh

# Optional ENV variables:
# * ADVERTISED_LISTENERS: the listner address to be advertized to clients for the container, e.g. "PLAINTEXT://`docker-machine ip \`docker-machine active\``:9092"
# * ZK_CONNECT: the zookeeper.connect value, e.g "zk1:2181,zk2:2181,zk3:2181/kafka"
# * LOG_RETENTION_HOURS: the minimum age of a log file in hours to be eligible for deletion (default is 168, for 1 week)
# * LOG_RETENTION_BYTES: configure the size at which segments are pruned from the log, (default is 1073741824, for 1GB)
# * NUM_PARTITIONS: configure the default number of log partitions per topic
# * BROKER_ID: broker id for the container, if this was unset, unique broker id will be assigned by using zookeeper.

# Configure advertised host/port
if [ ! -z "$ADVERTISED_LISTENERS" ]; then
    echo "advertised listeners: $ADVERTISED_LISTENERS"
    export ESCAPED_ADVERTISED_LISTENERS=$(echo $ADVERTISED_LISTENERS | sed 's/\//\\\//g');
    sed -r -i "s/#(advertised.listeners)=(.*)/\1=$ESCAPED_ADVERTISED_LISTENERS/g" $KAFKA_HOME/config/server.properties
fi

if [ ! -z "$ZK_CONNECT" ]; then
  echo "zookeeper.connect: $ZK_CONNECT"
  sed -r -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=$ZK_CONNECT/g" $KAFKA_HOME/config/server.properties
fi

# Allow specification of log retention policies
if [ ! -z "$LOG_RETENTION_HOURS" ]; then
    echo "log retention hours: $LOG_RETENTION_HOURS"
    sed -r -i "s/(log.retention.hours)=(.*)/\1=$LOG_RETENTION_HOURS/g" $KAFKA_HOME/config/server.properties
fi
if [ ! -z "$LOG_RETENTION_BYTES" ]; then
    echo "log retention bytes: $LOG_RETENTION_BYTES"
    sed -r -i "s/#(log.retention.bytes)=(.*)/\1=$LOG_RETENTION_BYTES/g" $KAFKA_HOME/config/server.properties
fi

# Configure the default number of log partitions per topic
if [ ! -z "$NUM_PARTITIONS" ]; then
    echo "default number of partition: $NUM_PARTITIONS"
    sed -r -i "s/(num.partitions)=(.*)/\1=$NUM_PARTITIONS/g" $KAFKA_HOME/config/server.properties
fi

# Enable/disable auto creation of topics
if [ ! -z "$AUTO_CREATE_TOPICS" ]; then
    echo "auto.create.topics.enable: $AUTO_CREATE_TOPICS"
    echo "auto.create.topics.enable=$AUTO_CREATE_TOPICS" >> $KAFKA_HOME/config/server.properties
fi

if [ ! -z "$BROKER_ID" ]; then
  echo "broker.id: $BROKER_ID"
  sed -r -i  "s/broker.id=(.*)/broker.id=$BROKER_ID/g" $KAFKA_HOME/config/server.properties
else
  sed -r -i  "s/(broker.id=.*)/#\1/g" $KAFKA_HOME/config/server.properties
fi

# Run Kafka
cat $KAFKA_HOME/config/server.properties

$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
