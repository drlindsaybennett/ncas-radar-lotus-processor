#!/bin/bash

# Load defaults
source defaults.cfg

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Parse command-line arguments
DATE=$1

if [[ ! $DATE ]] || [[ ${#DATE} -ne 8 ]] && [[ ! $DATE =~ /\d{8}/ ]]; then
    echo "[ERROR] Date must be 8 digits, not: '$DATE'"
    exit 1
fi

# Check validity of date 
if [[ $DATE -lt $START_DATE ]] || [[ $DATE -gt $END_DATE ]]; then
    echo "[ERROR] Date is out of range: $DATE"
    echo "        Allowed range: $START_DATE - $END_DATE"
    exit 1
fi

n_chunks=$(expr 24 / $CHUNK_SIZE)

if [[ $n_chunks -lt 1 ]]; then
    echo "[ERROR] Please check CHUNK_SIZE in 'defaults.cfg' - must be 24 or less."
    exit 1
fi

YYYY=$(date +%Y)
MM=$(date +%m)
DD=$(date +%d)

output_basedir=$LOTUS_OUTPUTS_BASEDIR/$YYYY/$MM/$DD
mkdir -p $output_basedir

chunk=0

while [[ $chunk -lt 24 ]]; do

    ARGS=""

    for hour in $(seq $chunk $(expr $chunk + $CHUNK_SIZE - 1)); do

        DATE_HOUR=${DATE}$(printf %02d ${hour})
        ARGS="$ARGS $DATE_HOUR"

    done

    let chunk+=$CHUNK_SIZE
     
    echo "[INFO] Running for: $DATE_HOUR"

    wallclock=$(printf %02d ${CHUNK_SIZE}):00 
    
    output_base=$output_basedir/$(echo $ARGS | cut -d' ' -f1)

    script_cmd="bsub -q $QUEUE -W $wallclock -o ${output_base}.out -e ${output_base}.err $SCRIPT_DIR/convert-chilbolton-x-band-hour.sh $ARGS"
    echo "[INFO] Running: $script_cmd"
#    $script_cmd


done
exit 0;

