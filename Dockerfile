FROM debian:stable-slim

# Buildroot version to use
ARG BUILD_ROOT_RELEASE=2024.02.1
# Root password for SSH
ARG ROOT_PASSWORD=browser-vm

# Copy v86 buildroot board config into image.
# NOTE: if you want to override this later to play with
# the config (e.g., run `make menuconfig`), mount a volume:
# docker run ... -v $PWD/buildroot-v86:/buildroot-v86 ...
COPY ./buildroot-v86 /buildroot-v86

WORKDIR /root

# OS dependencies & packages

RUN \
    apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y install \
    which \
    ccache \
    wget \
    sed \
    make \
    binutils \
    build-essential \
    diffutils \
    gcc \
    g++ \
    bash \
    patch \
    gzip \
    bzip2 \
    perl \
    tar \
    cpio \
    unzip \
    rsync \
    file \
    bc \
    findutils \
    libncurses5-dev \
    git \
    python3 \
    libssl-dev \
    libc6-i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Buildroot

RUN \
    wget -c http://buildroot.org/downloads/buildroot-${BUILD_ROOT_RELEASE}.tar.gz \
    && tar axf buildroot-${BUILD_ROOT_RELEASE}.tar.gz

# configure the locales
ENV LANG='C' \
    LANGUAGE='en_US:en' \
    LC_ALL='C' \
    NOTVISIBLE="in users profile" \
    TERM=xterm

# Buildroot will place built artifacts here at the end.
VOLUME /build

WORKDIR /root/buildroot-${BUILD_ROOT_RELEASE}
ENTRYPOINT ["/buildroot-v86/build-v86.sh"]
