#!/bin/bash
#apply calibration offsets to uncalibrated cfradials

source ~/lrose/ncas-radar-lotus-processor/src/defaults.cfg

opts=("$@")
params_file=${opts[0]}
files=${opts[@]:1}

YYYY=$(date +%Y)
MM=$(date +%m)
DD=$(date +%d)

logdir=/home/users/lbennett/logs/
lotus_outdir=$LOTUS_OUTPUTS_BASEDIR/$YYYY/$MM/$DD

mkdir -p $lotus_output_basedir

wallclock=04:00

script_cmd="bsub -q $QUEUE -W $wallclock -o $lotus_outdir/%J.out -e $lotus_outdir/%J.err RadxConvert -v -params ${params_file} -f $files"

echo $script_cmd
 
