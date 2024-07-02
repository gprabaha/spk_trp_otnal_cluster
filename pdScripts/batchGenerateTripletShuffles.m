function batchGenerateTripletShuffles()
%BATCHFINDTRIPLETS Summary of this function goes here
%   Detailed explanation goes here

[cfg] = SPKTRP_getConfig();


dataDirStruct= dir(cfg.spkDataDir);

parfor i = 1:size(dataDirStruct,1)
    
    if dataDirStruct(i).name(1) ~= '.'
        
        try
            
            IDStr = dataDirStruct(i).name;
            sessionPath = fullfile(cfg.spkDataDir, IDStr);
            
            sessionPathDir = dir(fullfile(sessionPath,'*triplets.mat'));
            
            for j = 1:size(sessionPathDir,1)
                
                filePath = fullfile(sessionPathDir(j).folder, sessionPathDir(j).name);
                
                loadStruct = load(filePath);
                
                regionStr = loadStruct(1).triplets(1).regionStr;
                
                generateTripletShuffles(IDStr, regionStr);
                
            end
        catch err
            try
                saveErr(err);
            catch
                
            end
        end
    end
    
    
    
end

