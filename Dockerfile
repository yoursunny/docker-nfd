FROM armv7/armhf-ubuntu_core AS compile
RUN apt-get update && \
    apt-get install -qq build-essential clang dpkg-dev git libboost-all-dev libcrypto++-dev libpcap-dev libssl-dev libsqlite3-dev pkg-config
WORKDIR /root
RUN git clone --recursive https://github.com/named-data/ndn-cxx.git && \
    cd ndn-cxx && \
    CXX=clang++ ./waf configure --boost-libs=/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) && \
    ./waf -j2 && \
    ./waf install && \
    ./waf install --destdir=/target && \
    ldconfig
RUN git clone --recursive https://github.com/named-data/NFD.git && \
    cd NFD && \
    CXX=clang++ ./waf configure --boost-libs=/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) && \
    ./waf -j2 && \
    ./waf install && \
    ./waf install --destdir=/target
RUN git clone --recursive https://github.com/named-data/ndn-tools.git && \
    cd ndn-tools && \
    CXX=clang++ ./waf configure --boost-libs=/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) && \
    ./waf -j2 && \
    ./waf install && \
    ./waf install --destdir=/target
RUN find /target -type f | xargs ldd 2>/dev/null | grep /lib/ | awk '{ print $3 }' | sort -u | xargs dpkg -S | cut -d: -f1 | sort -u > /target/deps.txt

FROM armv7/armhf-ubuntu_core
COPY --from=compile /target /
RUN apt-get update && apt-get install -qq $(cat /deps.txt) && apt-get clean && rm /deps.txt
