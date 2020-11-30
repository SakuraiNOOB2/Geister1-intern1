#!/bin/bash

set -eux

USER_NAME="geister"
HOME_PATH="/home/${USER_NAME}"
RUBY_VERSION="2.3.1"
BUNDLER_VERSION="1.11.2"
MYSQL_VERSION="5.6"
MYSQL_ROOT_PASSWORD= # empty password
REPOSITORY_URL="https://github.com/dvd-dokidoki/intern-geister.git"

function setup_base() {
  # basic packages
  apt-get -y update
  apt-get -y install \
    software-properties-common \
    build-essential \
    git \
    debconf-utils \
    curl

  # firewall disabled
  ufw disable
}

function setup_mysql() {
  add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
  apt-get update

  local mysql_tmp_password="root"
  echo "mysql-server mysql-server/root_password password $mysql_tmp_password" | debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password $mysql_tmp_password" | debconf-set-selections

  apt-get install -y mysql-server-"${MYSQL_VERSION}" mysql-client-"${MYSQL_VERSION}"
  systemctl start mysql
  systemctl enable mysql.service

  sleep 3 # wait mysql daemon startup

  mysql -u root -p"$mysql_tmp_password" -e "use mysql; UPDATE user SET password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root'; flush privileges;"
}

function setup_ruby() {
  apt-get install -y libssl-dev libreadline-dev zlib1g-dev # for ruby-build

  local rbenv_dir="${HOME_PATH}/.rbenv"
  git clone https://github.com/rbenv/rbenv.git "$rbenv_dir"
  git clone https://github.com/rbenv/ruby-build.git "${rbenv_dir}/plugins/ruby-build"
  chown -R "$USER_NAME:$USER_NAME" "$rbenv_dir"

  local bash_profile="${HOME_PATH}/.bash_profile"
  echo "export PATH=\"\$HOME/.rbenv/bin:\$PATH\"" >> "$bash_profile"
  echo "eval \"\$(rbenv init -)\"" >> "$bash_profile"
  chown "$USER_NAME:$USER_NAME" "$bash_profile"

  su - "$USER_NAME" bash -lc "
    rbenv install ${RUBY_VERSION}
    rbenv global ${RUBY_VERSION}
    gem install bundler -v ${BUNDLER_VERSION}
  "
}

function setup_rails() {
  apt-get install libmysqlclient-dev # for mysql2 gem

  if [ -z "$REPOSITORY_URL" ];then
    exit 0
  fi

  su - "$USER_NAME" bash -lc "
    git clone ${REPOSITORY_URL} ${HOME_PATH}/intern-geister
    cd ${HOME_PATH}/intern-geister/server
    bundle install -j4
    bundle exec rails db:setup
    bundle exec rails db:environment:set
  "
}

setup_base
setup_mysql
setup_ruby
setup_rails
