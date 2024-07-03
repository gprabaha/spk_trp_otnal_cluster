#!/bin/bash
#SBATCH --output /gpfs/milgram/pi/chang/pg496/repositories/spk_trp_otnal_cluster/slurm_output
#SBATCH --array 0-54
#SBATCH --job-name dsq-shuffle_triplet_joblist
#SBATCH --partition psych_week --cpus-per-task 28 --mem-per-cpu 2048 --time 7-00:00:00 --mail-type ALL

# DO NOT EDIT LINE BELOW
/gpfs/milgram/apps/hpc.rhel7/software/dSQ/1.05/dSQBatch.py --job-file /gpfs/milgram/pi/chang/pg496/repositories/spk_trp_otnal_cluster/pdScripts/shuffle_triplet_joblist.txt --status-dir /gpfs/milgram/pi/chang/pg496/repositories/spk_trp_otnal_cluster/slurm_output

