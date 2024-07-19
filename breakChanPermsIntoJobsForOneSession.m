function breakChanPermsIntoJobsForOneSession(IDStr, regionStr)
    [cfg] = SPKTRP_getConfig();
    sessionPath = fullfile(cfg.spkDataDir, IDStr);
    spikePath = fullfile(sessionPath, sprintf('%s_%s_spiketimes.mat', IDStr, regionStr));
    if exist(spikePath, 'file')
        spikeLoad = load(spikePath, 'spktms');
        spikeTimes = spikeLoad.spktms;
        numChans = size(spikeTimes,2);
        chanPerms = nchoosek(1:numChans, 3);
        numChanPerms = size(chanPerms,1);
        % Create the job list file for this session
        jobFilePath = fullfile(pwd, 'pdScripts', sprintf('joblist_%s_%s.txt', IDStr, regionStr));
        fidJobFile = fopen(jobFilePath, 'w');
        fclose(fidJobFile);
        % Generate individual jobs for each channel permutation
        for cp = 1:numChanPerms
            generateSingleChanPermJob(IDStr, regionStr, cp, jobFilePath);
        end
        % Generate and submit the dsq submission script for this session
        generateAndSubmitDsqShell(jobFilePath);
    else
        error('Spike times file does not exist: %s', spikePath);
    end
end

