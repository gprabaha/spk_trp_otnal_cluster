clear all
clc
[cfg] = SPKTRP_getConfig();


dataDirStruct= dir(cfg.spkDataDir);

parfor i = 1:size(dataDirStruct,1)
    
    if dataDirStruct(i).name(1) ~= '.'
    
        try
            
            IDStr = dataDirStruct(i).name;
            sessionPath = fullfile(cfg.spkDataDir, IDStr);
            
            sessionPathDir = dir(fullfile(sessionPath,'*spiketimes.mat'));
            
            for j = 1:size(sessionPathDir,1)
                
                filePath = fullfile(sessionPathDir(j).folder, sessionPathDir(j).name);
                
                loadStruct = load(filePath);
                
                regionStr = loadStruct(1).spktms(1).region;
                
                findStructuredTriplets(IDStr, regionStr);
                
            end
        catch
            
        end
    end
end

