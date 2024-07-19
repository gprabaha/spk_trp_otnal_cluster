function collateShuffledTriplets(IDStr, regionStr)
    [cfg] = SPKTRP_getConfig();
    sessionPath = fullfile(cfg.spkDataDir, IDStr);
    chanPerms = nchoosek(1:numel(spktms), 3);
    numChanPerms = size(chanPerms,1);
    shuffledTriplets = struct();
    for cp = 1:numChanPerms
        resultFilePath = fullfile(sessionPath, sprintf('shuffledTriplets_cp%05d.mat', cp));
        if exist(resultFilePath, 'file')
            load(resultFilePath, 'stm', 'cpStr', 'uuidStr', 'c1', 'c2', 'c3', 'spikeTimes', 'IDStr', 'regionStr', 'windowMs');
            shuffledTriplets(cp).shuffledMatrix = stm;
            shuffledTriplets(cp).permStr = cpStr;
            shuffledTriplets(cp).UUIDStr = uuidStr;
            shuffledTriplets(cp).c1_idx = c1;
            shuffledTriplets(cp).c2_idx = c2;
            shuffledTriplets(cp).c3_idx = c3;
            shuffledTriplets(cp).c1_chan = spikeTimes(c1).chanStr;
            shuffledTriplets(cp).c2_chan = spikeTimes(c2).chanStr;
            shuffledTriplets(cp).c3_chan = spikeTimes(c3).chanStr;
            shuffledTriplets(cp).c1_UUID = spikeTimes(c1).UUID;
            shuffledTriplets(cp).c2_UUID = spikeTimes(c2).UUID;
            shuffledTriplets(cp).c3_UUID = spikeTimes(c3).UUID;
            shuffledTriplets(cp).IDStr = IDStr;
            shuffledTriplets(cp).regionStr = regionStr;
            shuffledTriplets(cp).windowMs = windowMs;
        else
            warning('Result file for cp %d does not exist: %s', cp, resultFilePath);
        end
    end
    % Save the final collated result
    finalSavePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
    save(finalSavePath, 'shuffledTriplets');
end
