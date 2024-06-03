#!/bin/sh

cd $(dirname $0)

PORT=8448
MYBOAT=$1
MODEL=$2

fuser -k 8448/tcp

sleep 20s

python3 DisplayServer.py ${PORT} ${MYBOAT} ${MODEL} &

python3 -m webbrowser -t "http://localhost:${PORT}/chart" &

python3 -m webbrowser -t "http://localhost:${PORT}/view3d" &

#clips/clips -f clp/run.bat


