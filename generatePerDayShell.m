function  generatePerDayShell(jobName, savePath, matPath)
%GENERATEPERDAYSHELL Summary of this function goes here
%   Detailed explanation goes here

FID = fopen(savePath, 'w');

fprintf(FID, '%s\n', '#!/bin/bash');
fprintf(FID, '%s\n', '#SBATCH --partition=verylong');
fprintf(FID, '%s\n', '#SBATCH --time=168:00:00');
fprintf(FID, '#SBATCH --job-name=%s\n', jobName);
fprintf(FID, '%s\n', '#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=28');
fprintf(FID, '%s\n', '#SBATCH --mem-per-cpu=8192');
fprintf(FID, '%s\n', '#SBATCH --mail-type=ALL');
fprintf(FID, '%s\n', 'module load MATLAB/2017a');
fprintf(FID, 'matlab -nodisplay -nosplash -r "run(''%s'');"\n', matPath);
fclose(FID);




end

