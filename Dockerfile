FROM docker.ocf.berkeley.edu/theocf/debian:stretch

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            bc \
            dirmngr \
            git \
            openjdk-8-jdk-headless

RUN echo "deb http://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

# Unfortunately this cannot be done in the main package installation step,
# since sbt is in a separate apt repo, so it needs another update to install
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            sbt \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY package.sh /tmp

CMD ["/tmp/package.sh"]
