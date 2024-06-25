# From
#   1. https://hint.io/blog/rails-development-with-docker
#   2. https://gist.github.com/nvick/96c22b18b6cb31fa458fafba32fa000f

ARG RUBY_VERSION=3.1.2
FROM ruby:$RUBY_VERSION

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  yarn \
  locales \
  git \
  netcat \
  vim \
  sudo

ARG UID
ENV UID $UID
ARG GID
ENV GID $GID
ARG USER=ruby
ENV USER $USER

RUN groupadd -g $GID $USER && \
  useradd -u $UID -g $USER -m $USER && \
  usermod -p "*" $USER && \
  usermod -aG sudo $USER && \
  echo "$USER ALL=NOPASSWD: ALL" >> /etc/sudoers.d/50-$USER

RUN curl "https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem" --output /usr/local/share/ca-certificates/global-bundle.pem \
  && update-ca-certificates

ENV LANG C.UTF-8

ENV BUNDLE_PATH /gems
ENV BUNDLE_HOME /gems

ARG BUNDLE_JOBS=20
ENV BUNDLE_JOBS $BUNDLE_JOBS

ARG BUNDLE_RETRY=5
ENV BUNDLE_RETRY $BUNDLE_RETRY

ENV GEM_HOME /gems
ENV GEM_PATH /gems

ENV PATH /gems/bin:$PATH

RUN mkdir -p "$GEM_HOME" && chown $USER:$USER "$GEM_HOME"
RUN mkdir -p /app && chown $USER:$USER /app

WORKDIR /app

RUN mkdir -p tmp/cache && chown $USER:$USER tmp/cache

USER $USER

RUN gem install bundler
