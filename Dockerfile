FROM phusion/baseimage:latest
ENV DEBIAN_FRONTEND noninteractive

ENV RUBY_VERSION 2.2.3

# Install basic stuff
RUN apt-get -qq update
RUN apt-get -qqy upgrade
RUN apt-get -qqy install autoconf bison build-essential git-core libffi-dev \
  libgdbm-dev libgdbm3 libncurses5-dev libpq-dev libreadline6-dev \
  libssl-dev libxml2-dev libxslt1-dev libyaml-dev zlib1g-dev

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
ENV PATH /root/.rbenv/bin:/root/.rbenv/shims:$PATH

# Update rbenv and ruby-build definitions
RUN bash -c 'cd /root/.rbenv/ && git pull'
RUN bash -c 'cd /root/.rbenv/plugins/ruby-build/ && git pull'

# Install ruby and gems
RUN rbenv install $RUBY_VERSION
RUN rbenv global $RUBY_VERSION

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

RUN gem install bundler --no-ri --no-rdoc
RUN rbenv rehash

# Clean up APT when done.
RUN apt-get autoremove -y && apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set $HOME
RUN echo "/root" > /etc/container_environment/HOME
