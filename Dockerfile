#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM  openjdk:8u131-jdk

ENV SCALA_VERSION 2.11.8
ENV SBT_VERSION 0.13.15

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

# install aws utils
RUN apt-get update && apt-get install -y \
    python \
    python-pip \
    zip \
  && pip install boto3==1.3.0 \
  && apt-get remove --auto-remove python-pip -y \
  && rm -rf /var/lib/apt/lists/*

# install npm and node
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash \
  && apt-get update && apt-get install nodejs -y \
  && rm -rf /var/lib/apt/lists/*

# Define working directory
WORKDIR /root
