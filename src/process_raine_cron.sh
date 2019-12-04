#!/bin/bash
#convert sandwith gematronik files to cfradials

DATE=$(date -d "1 day ago" --utc +%Y%m%d)

/home/users/lbennett/lrose/ncas-radar-lotus-processor/src/convert-sandwith-x-band-day.sh -t vol $DATE
/home/users/lbennett/lrose/ncas-radar-lotus-processor/src/convert-sandwith-x-band-day.sh -t azi $DATE
/home/users/lbennett/lrose/ncas-radar-lotus-processor/src/convert-sandwith-x-band-day.sh -t ele $DATE

