from cluster-base

arg spark_version=3.1.3
arg hadoop_version=3.2

run apt-get update -y && \
    apt-get install -y curl && \
    curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz && \
    mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ && \
    mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs && \
    rm spark.tgz

env SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
env SPARK_MASTER_HOST spark-master
env SPARK_MASTER_PORT 7077
env PYSPARK_PYTHON python3

workdir ${SPARK_HOME}

copy jars/ jars/