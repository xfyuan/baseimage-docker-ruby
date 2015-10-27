# Use phusion/baseimage as base image. To make your builds reproducible,
# make sure you lock down to a specific version, not to `latest`!
FROM phusion/baseimage:0.9.17

ENV HOME /root
ENV RUBY_VERSION 2.2.3

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ===================
# Install basic stuff
# ===================
RUN apt-get -qq update
RUN apt-get -y install git-core build-essential
  # libffi-dev autoconf bison \
  # libgdbm-dev libgdbm3 libncurses5-dev libreadline6-dev \
  # libssl-dev libyaml-dev zlib1g-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev
# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb
# for js runtime
RUN apt-get install -y nodejs

# =============
# Install ruby
# =============

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

# =======================
# Clean up APT when done.
# =======================
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ===============
# Set bundle path
# ===============
ENV BUNDLE_PATH /rubygems
