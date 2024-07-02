function [shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr)

% % -------- Test Settings --------
% clear all
% clc
% IDStr = '01022019';
% regionStr = 'ofc';
% % --------------------------------

fprintf('***** Beginning shuffle generation for: %s - %s *****\n', IDStr, regionStr);

% Get the configuration file
[cfg] = SPKTRP_getConfig();

% Window size in ms
windowMs = 150;

np = 100;

circShiftMaxMs = 300;
circShiftMinMs = windowMs;

% Create structure to hold triplet data
shuffledTriplets = struct();

% Putative directory with data for this session
sessionPath = fullfile(cfg.spkDataDir, IDStr);

% Putative datafile with spike times for this session and region
spikePath = fullfile(sessionPath, sprintf('%s_%s_spiketimes.mat', IDStr, regionStr));

if exist(spikePath, 'file')

    spikeLoad = load(spikePath, 'spktms');

    spikeTimes = spikeLoad.spktms;

    numChans = size(spikeTimes,2);

    maxMs = max([spikeTimes.spikeMs]);

    chanPerms = nchoosek(1:numChans, 3);

    numChanPerms = size(chanPerms,1);

    tripletPerms  = permn(1:3, 3);

    tripletPermStrs = cell(size(tripletPerms,1),1);

    for tp = 1:size(tripletPerms,1)
        tripletPermStrs{tp} = sprintf('%1d-%1d-%1d', tripletPerms(tp,1), tripletPerms(tp,2), tripletPerms(tp,3));
    end

    parfor cp = 1:numChanPerms

        c1 = chanPerms(cp,1);
        c2 = chanPerms(cp,2);
        c3 = chanPerms(cp,3);

        cpStr = sprintf('%s-%s-%s', spikeTimes(c1).chanStr, spikeTimes(c2).chanStr, spikeTimes(c3).chanStr);
        uuidStr = sprintf('%05d-%05d-%05d', spikeTimes(c1).UUID, spikeTimes(c2).UUID, spikeTimes(c3).UUID);

        fprintf('\tStarting shuffle generation of --> %s\n', uuidStr);

        %Shuffled triplet matrix
        stm = nan(0,7, np);

        for p = 1:np

            c1_spikeMs = spikeTimes(c1).spikeMs;
            c2_spikeMs = spikeTimes(c2).spikeMs;
            c3_spikeMs = spikeTimes(c3).spikeMs;

            chanRand = randi(3, 1);

            firstChanShiftMs= ((circShiftMaxMs-circShiftMinMs)*rand(1,1, 'double'))+circShiftMinMs;
            secondChanShiftMs= ((circShiftMaxMs-circShiftMinMs)*rand(1,1, 'double'))+circShiftMinMs;

            if chanRand == 1

                [c2_spikeMs] = circularShuffleSpikeTimes(c2_spikeMs,firstChanShiftMs)
                [c3_spikeMs] = circularShuffleSpikeTimes(c3_spikeMs,secondChanShiftMs)


            elseif chanRand == 2

               [c1_spikeMs] = circularShuffleSpikeTimes(c1_spikeMs,firstChanShiftMs)
                [c3_spikeMs] = circularShuffleSpikeTimes(c3_spikeMs,secondChanShiftMs)


            elseif chanRand == 3

                 [c1_spikeMs] = circularShuffleSpikeTimes(c1_spikeMs,firstChanShiftMs)
                [c2_spikeMs] = circularShuffleSpikeTimes(c2_spikeMs,secondChanShiftMs)

            end

            tc = 0; % Triplet Counts


            allSpikeMs = sort([c1_spikeMs, c2_spikeMs, c3_spikeMs]);

            for ms = allSpikeMs

                binStartMs = ms;
                binStopMs = ms+windowMs;


                c1_binSpikeMs = c1_spikeMs( c1_spikeMs >= binStartMs & c1_spikeMs < binStopMs);
                c2_binSpikeMs = c2_spikeMs( c2_spikeMs >= binStartMs & c2_spikeMs < binStopMs);
                c3_binSpikeMs = c3_spikeMs( c3_spikeMs >= binStartMs & c3_spikeMs < binStopMs);


                if sum([numel(c1_binSpikeMs) numel(c2_binSpikeMs) numel(c3_binSpikeMs)]) >= 3


                    allChanSpikeMs = [c1_binSpikeMs, c2_binSpikeMs, c3_binSpikeMs];
                    allChanSpikeChanIdxs = [ones(size(c1_binSpikeMs))*1, ones(size(c2_binSpikeMs))*2, ones(size(c3_binSpikeMs))*3];

                    [sortedMs, sortedIdxs] = sort(allChanSpikeMs);

                    sortedChans = allChanSpikeChanIdxs(sortedIdxs);

                    tripletChans = sortedChans(1:3);

                    tripletMs = sortedMs(1:3);

                    tc = tc+1;

                    stm(tc, 1:3, p) = tripletChans;
                    stm(tc, 4:6, p) = tripletMs;
                    stm(tc, 7, p) =  find(strcmp(tripletPermStrs, sprintf('%1d-%1d-%1d', tripletChans(1), tripletChans(2), tripletChans(3)) ));

                end

            end

        end
        shuffledTriplets(cp).shuffledMatrix = stm;
        shuffledTriplets(cp).permStr = cpStr;
        shuffledTriplets(cp).UUIDStr = uuidStr
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

        fprintf('\tFinished shuffle generation --> %s\n', uuidStr)

    end % END OF CHANNEL PERMUTATION PARFOR LOOP


end


fprintf('***** Finished shuffle generation for: %s - %s ***** \n', IDStr, regionStr);
%end
