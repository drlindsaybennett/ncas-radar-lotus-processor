# ncas-radar-lotus-processor

NCAS Radar LOTUS processor tools.

## Overview

This suite of scripts provides a repeatable batch processing system for
processing NCAS radar data on LOTUS.

The structure is as follows:

 1. Top-level ("run everything") script:
  - `convert-chilbolton-x-band-time-series.sh`
  - can be run on `jasmin-sci*` servers
  - runs for a date range (or *all dates*) and a scan type
  - can be re-run any number of times
  - for each day it calls the daily script (below)

 2. Daily script:
  - `convert-chilbolton-x-band-day.sh`
  - can be run on `jasmin-sci*` servers
  - takes a date and scan type as the arguments
  - breaks each day into "chunks" (of pre-configured size, in hours)
  - calls each "chunk" as an argument to the hourly script
  - the hourly script is invoked via `bsub` - to run on LOTUS

 3. Hourly script:
  - `convert-chilbolton-x-band-hour.sh`
  - typically run on LOTUS (to allow parallelisation)
  - takes one or more date/hour "YYYYMMDDHH" inputs to run on, and scan type
  - loops over each hour, finding all scans within that period
  - for each scan time:
    - ignores if already run
    - scans input directory to find relevant variable/scan files
    - attempts to convert/process input files
    - checks if output produced
    - checks if correct number of variables, i.e. count(input) == count(output)
    
