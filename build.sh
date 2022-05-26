#!/bin/bash

SPARK_VERSION="3.1.3"
HADOOP_VERSION="3.2"
JUPYTERLAB_VERSION="3.4.2"

docker build \
    -f docker/cluster-base.dockerfile \
    -t cluster-base .

docker build \
    --build-arg spark_version="${SPARK_VERSION}" \
    --build-arg hadoop_version="${HADOOP_VERSION}" \
    -f docker/spark-base.dockerfile \
    -t spark-base .

docker build \
    -f docker/spark-master.dockerfile \
    -t spark-master .

docker build \
    -f docker/spark-worker.dockerfile \
    -t spark-worker .

docker build \
    --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
    --build-arg spark_version="${SPARK_VERSION}" \
    -f docker/jupyterlab.dockerfile \
    -t jupyterlab .
