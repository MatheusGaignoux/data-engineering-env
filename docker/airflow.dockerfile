from spark-base

arg airflow_version=2.3.1 
env AIRFLOW_HOME="/airflow"

run mkdir -p /airflow/dags

copy airflow/config /airflow
copy airflow/init.sh /airflow/init.sh
copy requirements.txt ${SHARED_WORKSPACE}/
run chmod a+x /airflow/init.sh

run apt-get update -y && \
    apt-get install -y python3-pip && \
    apt-get install -y postgresql-client && \
    pip3 install apache-airflow==${airflow_version} \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.3.1/constraints-3.7.txt" && \
    pip3 install "apache-airflow[postgres]" && \
    pip3 install pyspark==3.1.3 && \
    pip3 install -r ${SHARED_WORKSPACE}/requirements.txt && \
    pip3 install apache-airflow-providers-apache-spark
    
workdir ${AIRFLOW_HOME}

expose  8080

cmd /airflow/init.sh
