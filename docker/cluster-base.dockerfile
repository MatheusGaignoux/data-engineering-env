arg debian_buster_image_tag=8-jre-slim
from openjdk:${debian_buster_image_tag}

arg shared_workspace=/workspace

run mkdir -p ${shared_workspace} && \
    mkdir -p /mnt && \
    apt-get update -y && \
    apt-get install -y python3 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

env SHARED_WORKSPACE=${shared_workspace}

volume ${shared_workspace}
volume /mnt
cmd ["bash"]
