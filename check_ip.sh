#!/bin/bash
while true; do
  curl -L --proxy 'socks5h://127.0.0.1:40000' https://checkip.amazonaws.com
done
