

% Define the session and region
IDStr = '01072019'; % Session ID that did not finish
regionStr = 'bla';  % Region string for the session
% Step 1: Call breakChanPermsIntoJobsForOneSession
breakChanPermsIntoJobsForOneSession(IDStr, regionStr);
% Step 2: Periodically check if all jobs are completed
jobListPath = fullfile(pwd, 'pdScripts', sprintf('joblist_%s_%s.txt', IDStr, regionStr));
jobStatusDir = fullfile(pwd, 'slurm_output');
isCompleted = false;
while ~isCompleted
    % Pause for 30 minutes
    pause(30 * 60);
    % Check if all jobs are completed
    isCompleted = checkAllJobsCompleted(jobStatusDir);
end
% Step 3: Call collateShuffledTriplets once all jobs are completed
collateShuffledTriplets(IDStr, regionStr);


% Function to check if all jobs are completed
function isCompleted = checkAllJobsCompleted(jobStatusDir)
    isCompleted = true;
    % Check for the presence of any .out or .err files indicating incomplete jobs
    outFiles = dir(fullfile(jobStatusDir, '*.out'));
    errFiles = dir(fullfile(jobStatusDir, '*.err'));
    for i = 1:length(outFiles)
        outFile = outFiles(i).name;
        if ~contains(fileread(fullfile(jobStatusDir, outFile)), 'MATLAB is finished')
            isCompleted = false;
            return;
        end
    end
    for i = 1:length(errFiles)
        errFile = errFiles(i).name;
        if ~contains(fileread(fullfile(jobStatusDir, errFile)), 'MATLAB is finished')
            isCompleted = false;
            return;
        end
    end
end
