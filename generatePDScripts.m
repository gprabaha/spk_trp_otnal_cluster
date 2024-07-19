function generatePDScripts(IDStr, regionStr, count, jobFilePath)
    try
        [cfg] = SPKTRP_getConfig();
        % Format the path for saving the triplets
        matPath = fullfile('pdScripts', sprintf('GST_%s_%s.m', IDStr, regionStr));
        % Generate the MATLAB script
        generatePerDayScript(IDStr, regionStr, matPath);
        % Append the job file
        fidJobFile = fopen(jobFilePath, 'a');
        fprintf(fidJobFile, 'module load miniconda; module load MATLAB/2017a; matlab -nodisplay -nosplash -r "run(''%s'');"\n', matPath);
        fclose(fidJobFile);
        fprintf('Finished: %s\n', matPath);
    catch saveErr
        fprintf('Could not generate per-day script %s:\n\t--->\t%s!\n', IDStr, saveErr.message);
    end
end
