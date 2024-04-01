#!/bin/bash

# Trap SIGTERM and SIGINT to handle graceful shutdown
trap 'kill ${sleep_pid}; exit 0' SIGTERM SIGINT

# Main loop
while true; do
  # Check if the Cloudflare WARP service is working
  if ! curl --retry 3 -m 3 -sSLx socks5h://127.0.0.1:40000 https://www.cloudflare.com/cdn-cgi/trace/ | grep -q "warp=on" &> /dev/null; then
    # Restart the warp-svc service if WARP is not working
    echo "WARP service is not working. Restarted warp-svc."
    supervisorctl restart warp-svc
  fi
  # Sleep in a way that allows interruption
  sleep 60 &
  sleep_pid=$!
  wait $sleep_pid
done