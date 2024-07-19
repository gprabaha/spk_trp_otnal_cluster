#!/bin/bash
#SBATCH --partition=psych_week
#SBATCH --time=7-00:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16G
#SBATCH --mail-type=FAIL
#SBATCH --job-name="spk_shf_session_01072019"
#SBATCH --output=spike_shuffle_job_01072019_out
#SBATCH --error=spike_shuffle_job_01072019_err

# Load the necessary modules
module load MATLAB/2022b

# Run the MATLAB script
matlab -nodisplay -nosplash -r "run('runShuffleForSession_01072019.m');"

