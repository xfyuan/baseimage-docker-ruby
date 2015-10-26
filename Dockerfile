# 使用phusion/baseimage作为基础镜像,去构建你自己的镜像,需要下载一个明确的版本,千万不要使用`latest`.
# 查看https://github.com/phusion/baseimage-docker/blob/master/Changelog.md,可用看到版本的列表.
FROM phusion/baseimage:0.9.17

# 设置正确的环境变量.
ENV HOME /root
ENV RUBY_VERSION 2.2.3

# 初始化baseimage-docker系统
CMD ["/sbin/my_init"]

# ===================
# Install basic stuff
# ===================
RUN apt-get -qq update
RUN apt-get -qqy upgrade
RUN apt-get -qqy install autoconf bison build-essential \
  curl wget git-core libffi-dev \
  libgdbm-dev libgdbm3 libncurses5-dev libpq-dev libreadline6-dev \
  libssl-dev libxml2-dev libxslt1-dev libyaml-dev zlib1g-dev

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
