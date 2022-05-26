from spark-base

arg spark_worker_web_ui=8081

expose ${spark_worker_web_ui}

cmd bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out
