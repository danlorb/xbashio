#!/bin/bash

host=$1
user=$2
port=$3

if [ -z "$host" ]; then
  echo "Call add-host.sh <hostname> [user] [port]"
  exit 1
fi

if [ -z "$user" ]; then
  user="root"
fi

if [ -z "$port" ]; then
  port="22"
fi

if [ -n "$host" ]; then
  ssh-keygen -t rsa -b 4096 -C "$host" -f ~/.ssh/hosts/"$host" -P ""
  chmod 0600 ~/.ssh/hosts/*

cat >> ~/.ssh/config <<EOF
Host $host
  HostName $host
  User $user
  Port $port
  IdentityFile ~/.ssh/hosts/$host

EOF

cat >> ~/.ssh/hosts/all <<EOF
$host
EOF

  ssh-copy-id -o PreferredAuthentications=password -o PubkeyAuthentication=no -i ~/.ssh/hosts/"$host".pub "$user"@"$host"
fi


