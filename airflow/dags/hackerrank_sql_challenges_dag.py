from airflow.models import DAG
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator
from datetime import datetime

path_application = "/workspace/hackerrank_sql_challenges/15_days_of_sql_learning.py"

default_args = {
    "start_date": datetime(2022, 6, 1)
}

with DAG("hackerank_sql_challenges", schedule_interval = None,
         default_args = default_args, catchup = False) as dag:

    transform_and_write_15_days_of_sql_learning = (
        SparkSubmitOperator(
            task_id = "15_days_of_sql_learning",
            application = path_application,
            conn_id = "spark_cluster_conn",
            jars = "/jars/delta-core_2.12-1.0.0.jar"
        )
    )
 