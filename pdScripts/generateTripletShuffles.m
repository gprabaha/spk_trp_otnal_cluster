function generateTripletShuffles(IDStr,regionStr)
%FINDTRIPLETS Summary of this function goes here
%   Detailed explanation goes here

try
    % Load the configuration file
    [cfg] = SPKTRP_getConfig();

    % Putative directory with data for this session
    sessionPath = fullfile(cfg.spkDataDir, IDStr);

    % Format the path for saving the triplets
    savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));

    if ~isfile(savePath)

        fprintf('%s Does not exist; starting shuffle generation.\n', savePath);

        % Find the triplets
        [shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);

          fprintf('Finished shuffling: %s, attempting to save.\n', savePath);

        % Save the triplet structure
        save(savePath, 'shuffledTriplets', '-v7.3')

        fprintf('Finished saving: %s\n', savePath);

    else
        fprintf('Already exists: %s\n', savePath);
    end

catch saveErr
    fprintf('Could not save extracted spike triplets from %s:\n\t--->\t%s!\n', IDStr, saveErr.message);
end

end
