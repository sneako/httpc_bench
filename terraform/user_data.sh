#!/usr/bin/env bash

echo "* hard nofile 102400" >> /etc/security/limits.conf
echo "* soft nofile 102400" >> /etc/security/limits.conf
sysctl -w fs.file-max=102400
sysctl -p

export LANG=en_US.UTF-8
export LANGUAGE=en_US
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

mkdir -p /tmp

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum update -y -q

yum upgrade -y -q --enablerepo=epel

yum install -y -q git wget unzip make gcc htop wxGTK-devel ncurses-compat-libs unixODBC-devel

wget --no-verbose -P /tmp/ "https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_${erlang_version}-1~centos~7_amd64.rpm"
rpm -Uvh "/tmp/esl-erlang_${erlang_version}-1~centos~7_amd64.rpm"
rm "/tmp/esl-erlang_${erlang_version}-1~centos~7_amd64.rpm"

wget --no-verbose -P /tmp/ "https://repo.hex.pm/builds/elixir/v${elixir_version}.zip"
unzip "/tmp/v${elixir_version}.zip" -d /usr/local
rm "/tmp/v${elixir_version}.zip"

export HOME=/home/ec2-user
export SERVER_HOST=${server_host}
cd /home/ec2-user
git clone --single-branch --branch finch https://github.com/sneako/httpc_bench.git
cd httpc_bench
mix local.hex --force
mix local.rebar --force
mix deps.get
mix compile
chown -R ec2-user:ec2-user /home/ec2-user

${after_setup}
