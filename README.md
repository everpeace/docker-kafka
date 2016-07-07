Kafka Docker Image
===================

A Kafka Docker Image for use with Kubernetes.

To start the image you need to specify a couple of environment variables for the container.

| Environment Variable                          | Description                           |
| --------------------------------------------- | --------------------------------------|
|ADVERTISED_LISTENERS | the listner address to be advertized to clients for the container, e.g. "PLAINTEXT://`docker-machine ip \`docker-machine active\``:9092" |
| ZK_CONNECT | the zookeeper.connect value, e.g "zk1:2181,zk2:2181,zk3:2181/kafka" |
| LOG_RETENTION_HOURS | the minimum age of a log file in hours to be eligible for deletion (default is 168, for 1 week) |
| LOG_RETENTION_BYTES | configure the size at which segments are pruned from the log, (default is 1073741824, for 1GB) |
| NUM_PARTITIONS| configure the default number of log partitions per topic |
| BROKER_ID | broker id for the container, if this was unset, unique broker id will be assigned by using zookeeper. |

Ensuring that zk1, zk2 ... zk3 can be resolved is beyond the scope of this image.
You can use DNS, or Kubernetes services, etc depending on your environment (see below).

## Inside Kubernetes
please see ['example'](example/) directory.
