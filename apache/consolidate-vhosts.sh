#! /bin/sh
#
# Concatenate all Apache virtual hosts config files
# into single config file to use for Docker.

cat ~/vhosts/*.conf > vhosts.conf
