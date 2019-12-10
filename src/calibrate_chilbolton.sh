#!/bin/bash
#apply calibration offsets to uncalibrated cfradials

#Load defaults
SCRIPT_DIR=/home/users/lbennett/lrose/ncas-radar-lotus-processor/src/
source $SCRIPT_DIR/defaults.cfg

opts=("$@")
params_index=${opts[0]}
chunk_index=${opts[1]}
files=${opts[@]:2}

YYYY=$(date +%Y)
MM=$(date +%m)
DD=$(date +%d)
HH=$(date +%H)
NN=$(date +%M)
SS=$(date +%S)

lotus_outdir=$LOTUS_OUTPUTS_BASEDIR/$YYYY/$MM/$DD

mkdir -p $lotus_outdir

wallclock=04:00

logfile=$YYYY$MM$DD\_$HH$NN\_$(printf %03d ${chunk_index})

ARGS="${params_index} $files"

#script_cmd="bsub -q $QUEUE -W $wallclock -o $lotus_outdir/${logfile}.out -e $lotus_outdir/${logfile}.err RadxConvert -v -params ${params_file} -f $files"
script_cmd="bsub -q $QUEUE -W $wallclock -o $lotus_outdir/${logfile}.out -e $lotus_outdir/${logfile}.err $SCRIPT_DIR/calibrate_chilbolton_chunk.sh $ARGS"
#output info not including big list of arguments
script_cmd_noARGS="bsub -q $QUEUE -W $wallclock -o $lotus_outdir/${logfile}.out -e $lotus_outdir/${logfile}.err $SCRIPT_DIR/calibrate_chilbolton_chunk.sh"
echo "[INFO] Running: $script_cmd_noARGS"
$script_cmd

exit 0; 
