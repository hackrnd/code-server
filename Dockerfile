ARG base_img=debian:10
ARG git_url=https://github.com/avryhof/python-starter.git

FROM $base_img

RUN apt-get update \
 && apt-get install -y \
    curl \
    dumb-init \
    htop \
    locales \
    man \
    nano \
    git \
    procps \
    ssh \
    sudo \
    vim \
    lsb-release \
  && rm -rf /var/lib/apt/lists/*

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8

RUN chsh -s /bin/bash
ENV SHELL=/bin/bash

RUN adduser --gecos '' --disabled-password coder && \
  echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN ARCH="$(dpkg --print-architecture)" && \
    curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml

COPY release-packages/code-server*.deb /tmp/
RUN dpkg -i /tmp/code-server*$(dpkg --print-architecture).deb && rm /tmp/code-server*.deb

EXPOSE 8080
USER coder

RUN mkdir /home/coder/app
RUN git clone $git_url /home/coder/app

WORKDIR /home/coder/app

ENTRYPOINT ["dumb-init", "fixuid", "-q", "/usr/bin/code-server", "--bind-addr", "0.0.0.0:8080", "."]