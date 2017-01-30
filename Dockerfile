FROM armv7/armhf-ubuntu_core
RUN apt-get update && \
    apt-get install -qq git build-essential dpkg-dev libcrypto++-dev libsqlite3-dev libboost-all-dev pkg-config libpcap-dev libssl-dev
WORKDIR /root
RUN git clone --recursive https://github.com/named-data/ndn-cxx.git && \
    cd ndn-cxx && \
    ./waf configure --boost-libs=/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) && \
    ./waf -j1 && \
    ./waf install && \
    ldconfig
RUN git clone --recursive https://github.com/named-data/NFD.git && \
    cd NFD && \
    ./waf configure --boost-libs=/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) && \
    ./waf -j1 && \
    ./waf install
RUN git clone --recursive https://github.com/named-data/ndn-tools.git && \
    cd ndn-tools && \
    ./waf configure --boost-libs=/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) && \
    ./waf -j1 && \
    ./waf install
RUN mkdir /target && \
    cd ndn-cxx && ./waf install --destdir=/target && cd .. && \
    cd NFD && ./waf install --destdir=/target && cd .. && \
    cd ndn-tools && ./waf install --destdir=/target && cd ..
