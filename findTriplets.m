function findTriplets(IDStr,regionStr)
%FINDTRIPLETS Summary of this function goes here
%   Detailed explanation goes here



try
    % Load the configuration file
    [cfg] = SPKTRP_getConfig();
    
    % Putative directory with data for this session
    sessionPath = fullfile(cfg.spkDataDir, IDStr);
    
    % Find the triplets
    [triplets] = findTripletsFunc(IDStr, regionStr);
    
    % Format the path for saving the triplets
    savePath = fullfile(sessionPath, sprintf('%s_%s_triplets.mat', IDStr, regionStr));
    
    % Save the triplet structure
    save(savePath, 'triplets')
    
catch saveErr
    fprintf('Could not save extracted spike triplets from %s:\n\t--->\t%s!\n', IDStr, saveErr.message);
end

end

