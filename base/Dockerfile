# BSD 2-Clause License

# Copyright (c) 2020, Supreeth Herle
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM ubuntu:focal as builder

ENV DEBIAN_FRONTEND=noninteractive

# Install updates and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        ninja-build \
        build-essential \
        flex \
        bison \
        git \
        cmake \
        libsctp-dev \
        libgnutls28-dev \
        libgcrypt-dev \
        libssl-dev \
        libidn11-dev \
        libmongoc-dev \
        libbson-dev \
        libyaml-dev \
        meson \
        mongodb \
        curl \
        gnupg \
        ca-certificates \
        libmicrohttpd-dev \
        libcurl4-gnutls-dev \
        libnghttp2-dev \
        libtins-dev \
        libidn11-dev \
        libtalloc-dev \ 
        libhiredis0.14
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs
RUN apt-get install libhiredis-dev

# Get open5gs code and install
RUN echo 57
RUN git clone --recursive https://github.com/AbdallahRustom/open5gs.git && cd open5gs && \  
    git checkout vpp-upg   && meson build --prefix=`pwd`/install && \     
    ninja -C build && cd build && ninja install && \
    mkdir -p /open5gs/install/include

# Building WebUI of open5gs
RUN cd open5gs/webui && npm clean-install && npm run build

# Build final image
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        libssl-dev \
        libyaml-dev \
        libmicrohttpd-dev \
        libmongoc-dev \
        libsctp-dev \
        libcurl4-gnutls-dev \
        libtins-dev \
        libidn11-dev \
        libtalloc-dev \
        libhiredis0.14 \ 
        netbase \
        ifupdown \
        net-tools \
        iputils-ping \
        python3-setuptools \
        python3-wheel \
        python3-pip \
        iptables \
        tcpdump \
        iperf && \
    apt-get autoremove -y && apt-get autoclean

RUN pip3 install click

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

RUN update-ca-certificates

COPY --from=builder /open5gs/install/bin /open5gs/install/bin
COPY --from=builder /open5gs/install/etc /open5gs/install/etc
COPY --from=builder /open5gs/install/include /open5gs/install/include
COPY --from=builder /open5gs/install/lib /open5gs/install/lib
COPY --from=builder /open5gs/webui /open5gs/webui

# Set the working directory to open5gs
WORKDIR /open5gs
RUN echo 9

COPY ./amf /mnt/amf/
COPY ./amf/amf_init.sh /mnt/amf/amf_init.sh
COPY ./amf/amf.yaml /mnt/amf/amf.yaml
COPY ./log/amf.log /open5gs/install/var/log/open5gs/amf.log

COPY ./ausf /mnt/ausf/
COPY ./ausf/ausf_init.sh /mnt/ausf/ausf_init.sh
COPY ./ausf/ausf.yaml /mnt/ausf/ausf.yaml
COPY ./log/ausf.log /open5gs/install/var/log/open5gs/ausf.log

COPY ./nrf /mnt/nrf/
COPY ./nrf/nrf_init.sh /mnt/nrf/nrf_init.sh
COPY ./nrf/nrf.yaml /mnt/nrf/nrf.yaml
COPY ./log/nrf.log /open5gs/install/var/log/open5gs/nrf.log

COPY ./smf /mnt/smf/
COPY ./smf/smf_init.sh /mnt/smf/smf_init.sh
COPY ./smf/ip_utils.py /mnt/smf/ip_utils.py
COPY ./smf/smf.yaml /mnt/smf/smf.yaml
COPY ./smf/smf.conf /mnt/smf/smf.conf
COPY ./smf/smf_roaming.conf /mnt/smf/smf_roaming.conf
COPY ./smf/make_certs.sh /mnt/smf/make_certs.sh
COPY ./log/smf.log /open5gs/install/var/log/open5gs/smf.log
COPY ./cdr /open5gs/install/var/cdr/

COPY ./udm /mnt/udm/
COPY ./udm/udm_init.sh /mnt/udm/udm_init.sh
COPY ./udm/udm.yaml /mnt/udm/udm.yaml
COPY ./log/udm.log /open5gs/install/var/log/open5gs/udm.log

COPY ./udr /mnt/udr/
COPY ./udr/udr_init.sh /mnt/udr/udr_init.sh
COPY ./udr/udr.yaml /mnt/udr/udr.yaml
COPY ./log/udr.log /open5gs/install/var/log/open5gs/udr.log

COPY ./bsf /mnt/bsf/
COPY ./bsf/bsf_init.sh /mnt/bsf/bsf_init.sh
COPY ./bsf/bsf.yaml /mnt/bsf/bsf.yaml
COPY ./log/bsf.log /open5gs/install/var/log/open5gs/bsf.log

COPY ./pcf /mnt/pcf/
COPY ./pcf/pcf_init.sh /mnt/pcf/pcf_init.sh
COPY ./pcf/pcf.yaml /mnt/pcf/pcf.yaml
COPY ./log/pcf.log /open5gs/install/var/log/open5gs/pcf.log

COPY open5gs_init.sh /
CMD /open5gs_init.sh
