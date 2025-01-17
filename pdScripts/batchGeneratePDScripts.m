function batchGeneratePDScripts()
    [cfg] = SPKTRP_getConfig();
    dataDirStruct = dir(cfg.spkDataDir);
    count = 0;
    jobFilePath = fullfile(pwd, 'pdScripts', 'shuffle_triplet_joblist.txt');
    % Create or clear the job file
    fidJobFile = fopen(jobFilePath, 'w');
    fclose(fidJobFile);
    for i = 1:size(dataDirStruct, 1)
        if dataDirStruct(i).name(1) ~= '.'
            try
                IDStr = dataDirStruct(i).name;
                sessionPath = fullfile(cfg.spkDataDir, IDStr);
                sessionPathDir = dir(fullfile(sessionPath, '*triplets.mat'));
                for j = 1:size(sessionPathDir, 1)
                    filePath = fullfile(sessionPathDir(j).folder, sessionPathDir(j).name);
                    loadStruct = load(filePath);
                    regionStr = loadStruct(1).triplets(1).regionStr;
                    count = count + 1;
                    generatePDScripts(IDStr, regionStr, count, jobFilePath);
                end
            catch err
                try
                    saveErr(err);
                catch
                end
            end
        end
    end
    % Generate and submit the dsq submission script
    generateAndSubmitDsqShell(jobFilePath);
end
