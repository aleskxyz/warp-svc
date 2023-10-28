#!/bin/bash
set -m
warp-svc &
sleep 2
warp-cli --accept-tos register
warp-cli --accept-tos set-proxy-port 40000
warp-cli --accept-tos set-mode proxy
warp-cli --accept-tos disable-dns-log
warp-cli --accept-tos set-families-mode "${FAMILIES_MODE}"
if [[ -n $WARP_LICENSE ]]; then
  warp-cli --accept-tos set-license "${WARP_LICENSE}"
fi
warp-cli --accept-tos connect
socat tcp-listen:1080,reuseaddr,fork tcp:localhost:40000 &
fg %1
