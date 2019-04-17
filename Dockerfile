# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set the environment variables
ENV agfusion_version 1.2
ENV DEBIAN_FRONTEND=noninteractive

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

# download reference genome
RUN pyensembl install --species homo_sapiens --release 92

# set default command
CMD ["agfusion --help"]
