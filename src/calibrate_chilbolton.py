# vim: et ts=4
import sys
import glob
import os

#must be given in this format yyyymmddhhmmss
start_time=sys.argv[1]
end_time=sys.argv[2]
start_date=start_time[0:8]
end_date=end_time[0:8]

scan_type=sys.argv[3]
params_index=sys.argv[4]

datadir = '/gws/nopw/j04/ncas_radar_vol2/data/xband/chilbolton/cfradial/uncalib_v1/' + scan_type
params_file= '/home/users/lbennett/lrose/ingest_params/RadxConvert.chilbolton.calib.0' + params_index

daydir=os.listdir(datadir)

files = []
for day in daydir:
    if day >= start_date and day <= end_date:
         for each in glob.glob(datadir + '/' + day + '/*.nc'):
             filetime = os.path.basename(each).split('_')[2].replace('-','')
             if start_time <= filetime and end_time >= filetime:
                 files.append(each)

def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    for i in xrange(0, len(l), n):
        yield l[i:i + n]

print len(files)

for file_chunk in chunks(files,72):
    #print len(file_chunk)
    os.system(' '.join(['~/lrose/ncas-radar-lotus-processor/src/calibrate_chilbolton.sh', params_file] + file_chunk))
    #print(' '.join(['~/lrose/ncas-radar-lotus-processor/calibrate_chilbolton.sh'] + file_chunk))
    break;


