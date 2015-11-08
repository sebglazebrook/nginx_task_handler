FROM debian:jessie

RUN apt-get update && \
    apt-get install -y ruby-full autoconf bison \
                       build-essential libssl-dev \
                       libyaml-dev libreadline6-dev \
                       zlib1g-dev libncurses5-dev \
                       libffi-dev libgdbm3 libgdbm-dev

RUN gem install bundler

COPY . /code

WORKDIR /code

RUN bundle install
