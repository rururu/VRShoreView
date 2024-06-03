#!/bin/sh

cd $(dirname $0)

sleep 20s
cd NMEA_CACHE
python3 ../nmea_cashe2.py --port 8081 &
cd ..


