function generateShuffledTripletsForChanPerm(IDStr, regionStr, cp)
    [cfg] = SPKTRP_getConfig();
    sessionPath = fullfile(cfg.spkDataDir, IDStr);
    spikePath = fullfile(sessionPath, sprintf('%s_%s_spiketimes.mat', IDStr, regionStr));
    load(spikePath, 'spktms');
    spikeTimes = spktms;
    % Original generateShuffledTripletsFunc logic for a single channel permutation
    windowMs = 150;
    np = 100;
    circShiftMaxMs = 300;
    circShiftMinMs = windowMs;
    chanPerms = nchoosek(1:numel(spikeTimes), 3);
    tripletPerms  = permn(1:3, 3);
    tripletPermStrs = cell(size(tripletPerms,1),1);
    for tp = 1:size(tripletPerms,1)
        tripletPermStrs{tp} = sprintf('%1d-%1d-%1d', tripletPerms(tp,1), tripletPerms(tp,2), tripletPerms(tp,3));
    end
    c1 = chanPerms(cp,1);
    c2 = chanPerms(cp,2);
    c3 = chanPerms(cp,3);
    cpStr = sprintf('%s-%s-%s', spikeTimes(c1).chanStr, spikeTimes(c2).chanStr, spikeTimes(c3).chanStr);
    uuidStr = sprintf('%05d-%05d-%05d', spikeTimes(c1).UUID, spikeTimes(c2).UUID, spikeTimes(c3).UUID);
    stm = nan(0,7, np);
    parfor p = 1:np
        stm(:,:,p) = generateShuffledTriplet(spikeTimes, c1, c2, c3, windowMs, circShiftMaxMs, circShiftMinMs, tripletPermStrs);
    end
    % Save the result for this channel permutation
    resultFilePath = fullfile(sessionPath, sprintf('shuffledTriplets_cp%05d.mat', cp));
    save(resultFilePath, 'stm', 'cpStr', 'uuidStr', 'c1', 'c2', 'c3', 'spikeTimes', 'IDStr', 'regionStr', 'windowMs');
end


function stm = generateShuffledTriplet(spikeTimes, c1, c2, c3, windowMs, circShiftMaxMs, circShiftMinMs, tripletPermStrs)
    c1_spikeMs = spikeTimes(c1).spikeMs;
    c2_spikeMs = spikeTimes(c2).spikeMs;
    c3_spikeMs = spikeTimes(c3).spikeMs;
    chanRand = randi(3, 1);
    firstChanShiftMs = ((circShiftMaxMs - circShiftMinMs) * rand(1,1, 'double')) + circShiftMinMs;
    secondChanShiftMs = ((circShiftMaxMs - circShiftMinMs) * rand(1,1, 'double')) + circShiftMinMs;
    if chanRand == 1
        [c2_spikeMs] = circularShuffleSpikeTimes(c2_spikeMs, firstChanShiftMs);
        [c3_spikeMs] = circularShuffleSpikeTimes(c3_spikeMs, secondChanShiftMs);
    elseif chanRand == 2
        [c1_spikeMs] = circularShuffleSpikeTimes(c1_spikeMs, firstChanShiftMs);
        [c3_spikeMs] = circularShuffleSpikeTimes(c3_spikeMs, secondChanShiftMs);
    elseif chanRand == 3
        [c1_spikeMs] = circularShuffleSpikeTimes(c1_spikeMs, firstChanShiftMs);
        [c2_spikeMs] = circularShuffleSpikeTimes(c2_spikeMs, secondChanShiftMs);
    end
    tc = 0; % Triplet Counts
    allSpikeMs = sort([c1_spikeMs, c2_spikeMs, c3_spikeMs]);
    stm = nan(0, 7);
    for ms = allSpikeMs
        binStartMs = ms;
        binStopMs = ms + windowMs;
        c1_binSpikeMs = c1_spikeMs( c1_spikeMs >= binStartMs & c1_spikeMs < binStopMs);
        c2_binSpikeMs = c2_spikeMs( c2_spikeMs >= binStartMs & c2_spikeMs < binStopMs);
        c3_binSpikeMs = c3_spikeMs( c3_spikeMs >= binStartMs & c3_spikeMs < binStopMs);
        if sum([numel(c1_binSpikeMs), numel(c2_binSpikeMs), numel(c3_binSpikeMs)]) >= 3
            allChanSpikeMs = [c1_binSpikeMs, c2_binSpikeMs, c3_binSpikeMs];
            allChanSpikeChanIdxs = [ones(size(c1_binSpikeMs))*1, ones(size(c2_binSpikeMs))*2, ones(size(c3_binSpikeMs))*3];
            [sortedMs, sortedIdxs] = sort(allChanSpikeMs);
            sortedChans = allChanSpikeChanIdxs(sortedIdxs);
            tripletChans = sortedChans(1:3);
            tripletMs = sortedMs(1:3);
            tc = tc + 1;
            stm(tc, 1:3) = tripletChans;
            stm(tc, 4:6) = tripletMs;
            stm(tc, 7) =  find(strcmp(tripletPermStrs, sprintf('%1d-%1d-%1d', tripletChans(1), tripletChans(2), tripletChans(3))));
        end
    end
end
