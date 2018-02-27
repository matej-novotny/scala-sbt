#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# -------------------------------------------------- Pull base image
FROM  openjdk:8-jdk

ENV SCALA_VERSION 2.11.11
ENV SBT_VERSION 0.13.16

# -------------------------------------------------- Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# -------------------------------------------------- Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# -------------------------------------------------- Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

# -------------------------------------------------- Install python3

RUN echo 'deb http://ftp.de.debian.org/debian testing main' >> /etc/apt/sources.list
RUN echo 'APT::Default-Release "stable";' | tee -a /etc/apt/apt.conf.d/00local
RUN apt-get update && apt-get -y -t testing install python3.6 python3.6-tk
RUN curl https://bootstrap.pypa.io/get-pip.py | python3.6

# -------------------------------------------------- Define working directory

ENV MATPLOTLIBRC="/root"
RUN echo "backend      : Agg" >> $MATPLOTLIBRC/matplotlibrc

# -------------------------------------------------- Preinstall some misbehaved libraries

RUN apt-get -y -t testing install python3.6-numpy libdpkg-perl cython3-dbg
RUN python3.6 -m pip install tslearn

RUN apt-get -y clean
RUN apt-get -y autoremove

WORKDIR /root
