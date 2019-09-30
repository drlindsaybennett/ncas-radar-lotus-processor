#!/bin/bash

# Load defaults
source defaults.cfg

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

MIN_START=$START_DATE
MAX_END=$END_DATE

# Parse command-line arguments
while getopts "s:e:" OPTION; do
    case $OPTION in
    s)
        START_DATE=$OPTARG
        [[ ${#START_DATE} -ne 8 ]] && [[ ! $START_DATE =~ /\d{8}/ ]] && {
            echo "[ERROR] Start date must be 8 digits"
            exit 1
        }
        ;;
    e)
        END_DATE=$OPTARG
        [[ ${#END_DATE} -ne 8 ]] && [[ ! $END_DATE =~ /\d{8}/ ]] && {
            echo "[ERROR] End date must be 8 digits"
            exit 1
        }
        ;;
    *)
        echo "[ERROR] Incorrect options provided"
        exit 1
        ;;
    esac
done

# Check validity of range
if [[ $START_DATE -gt $END_DATE ]] || [[ $START_DATE -lt $MIN_START ]] || [[ $END_DATE -gt $MAX_END ]]; then
    echo "[ERROR] Please check date range. At least one date is out of range:"
    echo "        $START_DATE - $END_DATE"
    exit 1
fi

echo "[INFO] Running for period: $START_DATE - $END_DATE"

CURRENT_DATE=$START_DATE
while [[ $CURRENT_DATE -le $END_DATE ]]; do

    echo "[INFO] Running for: $CURRENT_DATE"
    CURRENT_DATE=$(date '+%Y%m%d' -d "${CURRENT_DATE}+1 day")

    script_cmd="$SCRIPT_DIR/convert-chilbolton-x-band-day.sh $CURRENT_DATE"
    echo "[INFO] Running: $script_cmd"
    $script_cmd

done
exit 0;

