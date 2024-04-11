FROM mcr.microsoft.com/devcontainers/ruby:3.3

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get -y install --no-install-recommends fonts-dejavu-core libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev 2>&1 \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*
