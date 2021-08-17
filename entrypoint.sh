#!/bin/bash
(
sleep $[($RANDOM % 10)]
while ! warp-cli --accept-tos register; do
	sleep 1
	>&2 echo "Awaiting warp-svc become online..."
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
