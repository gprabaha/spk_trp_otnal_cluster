function generateAndSubmitDsqShell(jobFilePath)
    outputDir = fullfile(pwd, 'slurm_output');
    
    % Create the slurm_output directory if it does not exist
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % Generate the dsq batch file using dsq
    dsqBatchFilePath = fullfile(pwd, 'pdScripts', 'dsq_batchfile.sh');
    system(sprintf('bash -c "module load dSQ; module load miniconda; dsq --job-file %s --batch-file %s -o %s --status-dir %s --partition psych_week --cpus-per-task 28 --mem-per-cpu 2048 --time 7-00:00:00 --mail-type ALL"', ...
                   jobFilePath, dsqBatchFilePath, outputDir, outputDir));

    % Submit the dsq batch file using sbatch
    system(sprintf('bash -c "module load miniconda; sbatch --job-name=shuffle_triplet_jobs_dsq --output=%s/shuffle_triplet_session_%%a.out --error=%s/shuffle_triplet_session_%%a.err %s"', ...
                   outputDir, outputDir, dsqBatchFilePath));

end
