# vim: et ts=4
#!/bin/bash

#Load defaults
SCRIPT_DIR=/home/users/lbennett/lrose/ncas-radar-lotus-processor/src/
source $SCRIPT_DIR/defaults.cfg

#input file has this form
#/gws/nopw/j04/ncas_radar_vol2/data/xband/chilbolton/cfradial/uncalib_v1/sur/20161101/ncas-mobile-x-band-radar-1_chilbolton_20161101-093004_SUR_v1.nc

#parse arguments from calibrate_chilbolton.sh
opts=("$@")
params_index=${opts[0]}
input_files=${opts[@]:1}

params_file=/home/users/lbennett/lrose/ingest_params/RadxConvert.chilbolton.calib.0$params_index

failure_count=0

for ncfile in $input_files; do

    ncdate=${ncfile:76:8}
    YYYY=${ncdate:0:4}
    MM=${ncdate:4:2}
    DD=${ncdate:6:2}

    failure_dir=$LOG_BASEDIR/calib/failure/$YYYY/$MM/$DD
    success_dir=$LOG_BASEDIR/calib/success/$YYYY/$MM/$DD
    mkdir -p $success_dir $failure_dir

    # Test if too many failures have happened and if so, exit
    if [ $failure_count -ge $EXIT_AFTER_N_FAILURES ]; then
        echo "[WARN] Exiting after failure count reaches limit: $EXIT_AFTER_N_FAILURES"
        exit 1
    fi

    fname=$(basename $ncfile)
    success_file=$success_dir/${fname}
    failure_file=$failure_dir/${fname}

    # Remove previous error files (if present)
    rm -f $failure_file

    if [ -f $success_file ]; then 
        echo "[INFO] Already ran: $ncfile"
        echo "       Success file found: $success_file"
        continue
    fi

    # Process the uncalibrated data
	script_cmd="RadxConvert -v -params ${params_file} -f $ncfile"
    echo "[INFO] Running: $script_cmd"
    $script_cmd

	expected_file=${ncfile:0:61}${ncfile:64 -1}
    #echo $expected_file
    echo "[INFO] Checking that the output file has been produced."

	if [ ! -f $expected_file ]; then
	    echo "[ERROR] Failed to generate output file: $expected_file"
        let failure_count+=1
        touch $failure_file
        continue
    else
        echo "[INFO] Found expected file: $expected_file"
    fi 

    touch $success_file
done

exit 0;
