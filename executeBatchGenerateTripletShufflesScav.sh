#!/bin/bash

#SBATCH --partition=scavenge
#SBATCH --time=168:00:00
#SBATCH --job-name=PTP_GenerateTripletShuffles
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=28
#SBATCH --mem-per-cpu=8192
#SBATCH --mail-type=ALL
#SBATCH --requeue

module load MATLAB/2017a
matlab -nodisplay -nosplash -r "run('batchGenerateTripletShuffles.m');"