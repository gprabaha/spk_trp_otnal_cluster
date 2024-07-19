function generateSingleChanPermJob(IDStr, regionStr, cp, jobFilePath)
    % Generate the MATLAB script for this channel permutation
    scriptPath = fullfile('pdScripts', sprintf('GST_%s_%s_cp%05d.m', IDStr, regionStr, cp));
    generateSingleChanPermScript(IDStr, regionStr, cp, scriptPath);
    % Append the job to the job file
    fidJobFile = fopen(jobFilePath, 'a');
    fprintf(fidJobFile, 'module load miniconda; module load MATLAB/2017a; matlab -nodisplay -nosplash -r "run(''%s'');"\n', scriptPath);
    fclose(fidJobFile);
end