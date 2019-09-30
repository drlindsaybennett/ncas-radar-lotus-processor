#!/bin/bash

# Load defaults
source defaults.cfg

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Parse command-line arguments
DATE_HOURS=$@

for dh in $DATE_HOURS; do
    if [[ ${#dh} -ne 10 ]] && [[ ! $dh =~ /\d{10}/ ]]; then
        echo "[ERROR] Date/hour must be 10 digits, not: '$dh'"
        exit 1
    fi
done


for dh in $DATE_HOURS; do
 
    echo "[INFO] Processing: $dh"

done
exit 0;

