#!/bin/sh
set -eu
nohup python3 -m http.server 8080 --bind 127.0.0.1 > "$HOME/server.log" 2>&1 &
echo "started fixture server"
