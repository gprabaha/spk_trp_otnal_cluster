#!/bin/bash
#SBATCH --partition=verylong
#SBATCH --time=168:00:00
#SBATCH --job-name=PTP8_10102018_ofc_TripletGaze
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=28
#SBATCH --mem-per-cpu=8192
#SBATCH --mail-type=ALL
module load MATLAB/2017a
matlab -nodisplay -nosplash -r "run('/gpfs/milgram/pi/chang/CHANG_LAB/ptp8/spkTrp/spkTrpCode/gazeAroundTriplets/pdScripts/GAT_10102018_ofc.m');"