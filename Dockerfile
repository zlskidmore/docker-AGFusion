# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set the environment variables
ENV agfusion_version 1.2
ENV DEBIAN_FRONTEND=noninteractive
ENV PYENSEMBL_CACHE_DIR=/opt
ENV ensembl_version=87

# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    python3-matplotlib \
    python3-pandas \
    python3-future \
    python3-biopython \
    curl \
    less \
    vim \
    libnss-sss

# install pyensemebl
RUN pip3 install pyensembl

# install AGFusion
WORKDIR /usr/local/bin
RUN curl -SL https://github.com/murphycj/AGFusion/releases/download/${agfusion_version}/agfusion-${agfusion_version}.tar.gz \
    | tar -zxvC /usr/local/bin/
WORKDIR /usr/local/bin/agfusion-${agfusion_version}
RUN pip3 install .
WORKDIR /usr/local/bin

# download agfusion prebuilt database
RUN mkdir -p /opt/agfusiondb/
RUN agfusion download -s homo_sapiens -r 75 -d /opt/agfusiondb/
RUN agfusion download -s homo_sapiens -r ${ensembl_version} -d /opt/agfusiondb/
RUN agfusion download -s mus_musculus -r ${ensembl_version} -d /opt/agfusiondb/

# download ensembl database
RUN mkdir -p /opt
RUN pyensembl install --species homo_sapiens --release 75
RUN pyensembl install --species homo_sapiens --release ${ensembl_version}
RUN pyensembl install --species mus_musculus --release ${ensembl_version}

# set default command
CMD ["agfusion --help"]
