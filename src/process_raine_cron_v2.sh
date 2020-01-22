#!/bin/bash
#convert gematronik files to cfradials

DATE=$(date -d "1 day ago" --utc +%Y%m%d)

cd /home/users/lbennett/lrose/ncas-radar-lotus-processor/src/
./convert-raine-x-band-day.sh -t vol -d $DATE
./convert-raine-x-band-day.sh -t azi -d $DATE
./convert-raine-x-band-day.sh -t ele -d $DATE
