#!/bin/bash
source config.sh
ARCH=$1
BALENAIMG=${balenaImgs[$ARCH]}
if [[ -z $BALENAIMG ]]; then
  echo 'Bad ARCH '$ARCH >/dev/stderr
  exit 2
fi
OUTPUTDIR=$(pwd)/deb-$ARCH

mkdir -p $OUTPUTDIR
docker run -v $OUTPUTDIR:/root \
--entrypoint '/usr/bin/qemu-arm-static' -w=/root \
$BALENAIMG'build' -execve -0 bash /bin/bash -c '
  echo "deb-src http://ppa.launchpad.net/named-data/ppa-dev/ubuntu bionic main" > /etc/apt/sources.list.d/named-data_ppa.list
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9F5FAD4324C0AA95C9CDB5890AE3F9FDE7887606
  apt-get update
  apt-get install -y -qq debhelper devscripts fakeroot

  if ! [[ -f /usr/bin/dh_installman.real ]]; then
    mv /usr/bin/dh_installman /usr/bin/dh_installman.real
    (echo "#!/bin/bash"; echo "/usr/bin/dh_installman.real \"$@\" || true") > /usr/bin/dh_installman
    chmod +x /usr/bin/dh_installman
  fi

  for PKG in ndn-cxx libchronosync libpsync nfd nlsr ndn-tools ndn-traffic-generator ndncert repo-ng; do
    apt-get build-dep -y -qq $PKG
    apt-get source $PKG
    sed -i "s/waf build/waf build -j6/" $PKG-*/debian/rules
    cd $PKG-*
    debuild -us -uc -b
    cd ..
    if [[ $PKG == ndn-cxx ]]; then
      dpkg -i libndn-cxx_*.deb libndn-cxx-dev_*.deb
    fi
    if [[ $PKG == libchronosync ]]; then
      dpkg -i libchronosync_*.deb libchronosync-dev_*.deb
    fi
    if [[ $PKG == libpsync ]]; then
      dpkg -i libpsync_*.deb libpsync-dev_*.deb
    fi
  done
'
