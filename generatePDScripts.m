function generatePDScripts(IDStr,regionStr, count)
%FINDTRIPLETS Summary of this function goes here
%   Detailed explanation goes here



try
    % Load the configuration file
    [cfg] = SPKTRP_getConfig();
    

    
    % Format the path for saving the triplets
    matPath = fullfile('pdScripts', sprintf('GST_%s_%s.m', IDStr, regionStr));
    shellPath = fullfile(pwd, sprintf('%s_GST.sh', num2str(count)));

    jobName = sprintf('PTP8_%s_%s_GenShuffles',IDStr, regionStr);
    
        % Find the triplets
        generatePerDayScript(IDStr, regionStr, matPath);
        
        generatePerDayShell(jobName, shellPath, matPath);
        
        
        fprintf('Finished: %s\n', matPath);
    
 
    
catch saveErr
    fprintf('Could not generate per-day script %s:\n\t--->\t%s!\n', IDStr, saveErr.message);
end

end

