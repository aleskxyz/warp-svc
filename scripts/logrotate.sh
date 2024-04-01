#!/bin/bash

# Trap SIGTERM and SIGINT to handle graceful shutdown
trap 'kill ${sleep_pid}; exit 0' SIGTERM SIGINT

# Remove write access for group and others.
chmod go-w /var/lib/cloudflare-warp

# Main loop
while true; do
  logrotate /etc/logrotate.conf
  # Sleep in a way that allows us to interrupt it
  sleep 60 &
  sleep_pid=$!
  wait $sleep_pid
done
