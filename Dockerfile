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
RUN git clone --recursive https://github.com/NDN-Routing/infoedit.git && \
    cd infoedit && \
    clang++ -o infoedit -std=c++11 infoedit.cpp -lboost_program_options && \
    cp infoedit /usr/local/bin/infoedit && \
    cp infoedit /target/usr/local/bin/infoedit
RUN find /target -type f | xargs ldd 2>/dev/null | grep /lib/ | awk '{ print $3 }' | sort -u | xargs dpkg -S | cut -d: -f1 | sort -u > /target/deps.txt

FROM armv7/armhf-ubuntu_core
COPY --from=compile /target /
RUN apt-get update && apt-get install -qq $(cat /deps.txt) && apt-get clean && rm /deps.txt
RUN cd /usr/local/etc/ndn && \
    cp nfd.conf.sample nfd.conf && \
    infoedit -f nfd.conf -d face_system.unix && \
    infoedit -f nfd.conf -s face_system.udp.mcast -v no && \
    infoedit -f nfd.conf -d face_system.ether && \
    echo 'transport=tcp4://127.0.0.1:6363' > client.conf
CMD ["/usr/local/bin/nfd"]
HEALTHCHECK CMD nfdc status || exit 1
