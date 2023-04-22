#!/bin/bash
set -m
mkdir -p /var/lib/cloudflare-warp
cd /var/lib/cloudflare-warp
ln -s /dev/null cfwarp_daemon_dns.txt
ln -s /dev/null cfwarp_service_boring.txt
ln -s /dev/null cfwarp_service_dns_stats.txt
ln -s /dev/null cfwarp_service_log.txt
ln -s /dev/null cfwarp_service_stats.txt
cd /
warp-svc | grep -v DEBUG &
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