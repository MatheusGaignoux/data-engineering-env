from spark-base

arg spark_master_web_ui=8080

expose ${spark_master_web_ui} ${SPARK_MASTER_PORT}

cmd bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out
