from cluster-base

# -- Layer: JupyterLab

arg spark_version=3.1.3
arg jupyterlab_version=3.4.2

copy requirements.txt ${SHARED_WORKSPACE}/

run apt-get update -y && \
    apt-get install -y python3-pip && \
    pip3 install -r ${SHARED_WORKSPACE}/requirements.txt && \
    pip3 install wget pyspark==${spark_version} jupyterlab==${jupyterlab_version}

# -- Runtime

expose 8888
workdir ${SHARED_WORKSPACE}
cmd jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
