#!/bin/bash
(
while [ ! -f /var/lib/cloudflare-warp/reg.json ]; do
	sleep $[($RANDOM % 10)]
	>&2 echo "Awaiting warp-svc become online and registered..."
	warp-cli --accept-tos register
done
warp-cli --accept-tos set-mode proxy
warp-cli --accept-tos set-proxy-port 40001
warp-cli --accept-tos connect
haproxy -f /etc/haproxy/haproxy.cfg
) &

(
INTERVAL="${RECONNECT_INTERVAL:-999999999}"
while true; do
	sleep $[( $RANDOM % $INTERVAL ) + $INTERVAL ]
	echo "Rotating keys and reconnecting"
	warp-cli --accept-tos rotate-keys
	warp-cli --accept-tos connect
done
) &

exec warp-svc
