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

YYYY=$(echo $DATE_HOURS | cut -c1-4)
MM=$(echo $DATE_HOURS | cut -c5-6)
DD=$(echo $DATE_HOURS | cut -c7-8)
DATE=$YYYY$MM$DD

success_dir=$LOG_BASEDIR/success/$YYYY/$MM/$DD
failure_dir=$LOG_BASEDIR/failure/$YYYY/$MM/$DD
bad_num_dir=$LOG_BASEDIR/bad_num/$YYYY/$MM/$DD

mkdir -p $success_dir $failure_dir $bad_num_dir


for dh in $DATE_HOURS; do

    echo "[INFO] Processing: $dh"
    
    # Get input files
    input_files=$($SCRIPT_DIR/get-input-files.sh $dh | sort -u)
    
    for dbz_file in $input_files; do 

        input_dir=$(dirname $dbz_file)
        fname=$(basename $dbz_file)
        success_file=$success_dir/${dbz_file}
        
        if [ -f $success_file ]; then 
            echo "[INFO] Already ran: $dbz_file"
            continue
        fi
        
        cd $input_dir/
        fname_base=$(echo $fname | cut -c1-16)
        time_digits=$(echo $fname | cut -c9-14)
        
        expected_vars=$(ls ${fname_base}*.vol | cut -c1-16 | sed 's/\.vol$//g;')
        n_vars=$(echo $expected_vars | wc -w)
        
        # Process the uncalibrated data
        source $SCRIPT_DIR/setup-env.sh
        script_cmd="RadxConvert -v -params $PARAMS_FILE -f $dbz_file"
        echo $script_cmd
        $script_cmd
        
        # NOTE: output written to: export DATA_DIR=/gws/nopw/j04/ncas_radar_vol2/data/xband/
        #    chilbolton/cfradial/uncalib_v1/

        expected_file=$DATA_DIR/chilbolton/cfradial/uncalib_v1/sur/$DATE/ncas-mobile-x-band-radar-1_chilbolton_${DATE}-${time_digits}_SUR_v1.nc
 ##/gws/nopw/j04/ncas_obs/amf/raw_data/ncas-mobile-x-band-radar-1/data/chilbolton/chilbolton03_data.vol/2018-05-13/2018051323483900dBZ.vol

        if [ ! -f $expected_file ]; then
            echo "[ERROR] Failed to generate output file: $expected_file"
            exit 1
        fi 
        
        found_vars=$(ncdump -h $expected_file | grep -P "\(time, range\)" | cut -d\( -f1 | cut -d' ' -f2)
        
        if [ "$found_vars" -ne "$expected_vars" ]; then
            echo "[ERROR] Output variables are NOT the same as input files: $found_vars != $expected_vars"
            exit 1
        fi 
        
    done

done
exit 0;

