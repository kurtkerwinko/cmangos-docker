FROM debian:bookworm

RUN apt update && apt upgrade -y
RUN apt install -y grep gettext-base git \
    build-essential gcc g++ automake autoconf make patch cmake \
    libmariadb-dev libmariadb-dev-compat mariadb-server libtool \
    libssl-dev binutils zlib1g-dev libc6 libbz2-dev libboost-all-dev

WORKDIR /root

# CMaNGOS
ARG GIT_CMANGOS_REPO \
    GIT_CMANGOS_REPO_COMMIT=master

RUN git clone ${GIT_CMANGOS_REPO} cmangos
RUN cd cmangos && git checkout ${GIT_CMANGOS_REPO_COMMIT}

## Set playerbots commit tag
ARG GIT_PLAYERBOTS_REPO_COMMIT=master
RUN perl -i -0777 -pe \
    "s|(GIT_REPOSITORY *\"https://github.com/cmangos/playerbots.git\"\n *GIT_TAG *)\"master\"(\n)|\1\"${GIT_PLAYERBOTS_REPO_COMMIT}\"\2|" \
    cmangos/src/CMakeLists.txt

RUN mkdir build
RUN cd build && cmake ../cmangos \
    -DPCH=1 \
    -DDEBUG=0 \
    -DBUILD_AHBOT=1 \
    -DBUILD_METRICS=1 \
    -DBUILD_PLAYERBOTS=1 \
    -DBUILD_EXTRACTORS=1 \
    -DCMAKE_INSTALL_PREFIX=/opt/cmangos
RUN cd build && make -j $(nproc) && make install && cd .. && rm -r build

# CMaNGOS Database
ARG GIT_DB_REPO \
    GIT_DB_REPO_COMMIT=master

RUN git clone ${GIT_DB_REPO} database
RUN cd database && git checkout ${GIT_DB_REPO_COMMIT}

# Scripts
COPY setup.sh /root
COPY auto-migration.sh /root
COPY db-migration.sh /root
COPY run-extractor.sh /root

# Config
WORKDIR /opt/cmangos/etc
RUN cp ahbot.conf.dist ahbot.conf
RUN cp aiplayerbot.conf.dist aiplayerbot.conf
RUN cp anticheat.conf.dist anticheat.conf
RUN cp mangosd.conf.dist mangosd.conf
RUN cp realmd.conf.dist realmd.conf

# Environment
ENV GIT_DB_REPO=${GIT_DB_REPO}
ENV GIT_DB_REPO_COMMIT=${GIT_DB_REPO_COMMIT}
ENV GIT_CMANGOS_REPO=${GIT_CMANGOS_REPO}
ENV GIT_CMANGOS_REPO_COMMIT=${GIT_CMANGOS_REPO_COMMIT}
ENV GIT_PLAYERBOTS_REPO_COMMIT=${GIT_PLAYERBOTS_REPO_COMMIT}

WORKDIR /opt/cmangos/bin

CMD ["bash"]
