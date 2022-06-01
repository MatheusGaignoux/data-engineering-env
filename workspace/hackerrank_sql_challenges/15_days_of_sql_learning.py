from pyspark.sql import SparkSession
from pyspark.sql.window import Window
from pyspark.sql.types import StructType
from pyspark.sql.functions import col, lit, count, dense_rank, first, when, datediff, sum as colsum, current_timestamp

import json

def read_schema(schema_name: str) -> dict:
    file = open(f"/mnt/schemas/schema-{schema_name}.json", "r")
    return json.load(file)

def run_15_days_of_sql_learning():
    spark = (
        SparkSession
        .builder
        .appName("hackerrank:hackers submissions - ETL")
        .master("spark://spark-master:7077")
        .getOrCreate()
    )
    
    spark.sparkContext.setLogLevel("ERROR")
    
    # Schema definition:
    hackers_schema = StructType.fromJson(read_schema("hackers"))
    submissions_schema = StructType.fromJson(read_schema("submissions"))

    # Data file path in the swamp layer:
    hackers_path = "/mnt/swamp/hackers.jsonl"
    submissions_path = "/mnt/swamp/submissions.jsonl"
    
    hackers = (
        spark
        .read
        .json(hackers_path, schema = hackers_schema)
    )

    submissions = (
        spark
        .read
        .json(submissions_path, schema = submissions_schema)
    )
    
    # Get the hacker_id who made the biggest number of submissions each day:
    daily_subs = (
        submissions
        .groupBy(col("submission_date"), col("hacker_id"))
        .agg(count("submission_id").alias("qtt_submissions"))
        .orderBy(col("submission_date"), col("qtt_submissions").desc(), col("hacker_id"))
        .groupBy(col("submission_date"))
        .agg(first("hacker_id").alias("hacker_id"))
    )

    # Get the number of hacker_ids that submited in each successive day:
    start_date = "2016-03-01"
    window = Window.partitionBy(col("hacker_id")).orderBy(col("submission_date"))
    condition = (dense_rank().over(window) - 1) == datediff(col("submission_date"), lit(start_date))

    cols = [
        col("submission_date"),
        col("hacker_id"),
        when(condition, lit(1)).otherwise(lit(0)).alias("successive_submission"),
        dense_rank().over(window).alias("rn")
    ]

    successive_hackers = (
        submissions
        .select(*cols)
        .distinct()
        .groupBy(col("submission_date"))
        .agg(colsum("successive_submission").alias("qtt_hackers"))
    )

    df = (
        successive_hackers.alias("x")
        .join(daily_subs.alias("y"), on = "submission_date", how = "inner")
        .join(hackers.alias("z"), on = "hacker_id", how = "inner")
        .select(
            col("submission_date"),
            col("qtt_hackers"),
            col("y.hacker_id").alias("first_hacker_id"),
            col("z.name").alias("first_hacker_name"),
            current_timestamp().alias("processing_time")
        )
        .orderBy(col("submission_date"))
    )
    
    # Saving the file to drive step:    
    path = "/mnt/g_layer/15_days_of_sql_learning" # g_layer stands for gold layer

    (
        df
        .write
        .format("delta")
        .mode("overwrite")
        .option("overwriteSchema", True)
        .save(path)
    )
    
if __name__ == "__main__":
    run_15_days_of_sql_learning()
