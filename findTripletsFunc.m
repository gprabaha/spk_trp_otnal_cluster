function [triplets] = findTripletsFunc(IDStr, regionStr)

% % -------- Test Settings --------
% clear all
% clc
% IDStr = '01022019';
% regionStr = 'ofc';
% % --------------------------------

% Get the configuration file
[cfg] = SPKTRP_getConfig();

% Window size in ms
windowMs = 150;

% Create structure to hold triplet data
triplets = struct();

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
        
        c1_spikeMs = spikeTimes(c1).spikeMs;
        c2_spikeMs = spikeTimes(c2).spikeMs;
        c3_spikeMs = spikeTimes(c3).spikeMs;
        
        tc = 0; % Triplet Counts
        tm = nan(tc,7);
        
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
                
                tm(tc, 1:3) = tripletChans;
                tm(tc, 4:6) = tripletMs;
                tm(tc, 7) =  find(strcmp(tripletPermStrs, sprintf('%1d-%1d-%1d', tripletChans(1), tripletChans(2), tripletChans(3)) ));
                
            end

        end 
        
        triplets(cp).matrix = tm;
        triplets(cp).permStr = cpStr;
        triplets(cp).UUIDStr = uuidStr
        triplets(cp).c1_idx = c1;
        triplets(cp).c2_idx = c2;
        triplets(cp).c3_idx = c3;
        triplets(cp).c1_chan = spikeTimes(c1).chanStr;
        triplets(cp).c2_chan = spikeTimes(c2).chanStr;
        triplets(cp).c3_chan = spikeTimes(c3).chanStr;
        triplets(cp).c1_UUID = spikeTimes(c1).UUID;
        triplets(cp).c2_UUID = spikeTimes(c2).UUID;
        triplets(cp).c3_UUID = spikeTimes(c3).UUID;
        triplets(cp).IDStr = IDStr;
        triplets(cp).regionStr = regionStr;
        triplets(cp).windowMs = windowMs;
        
    end % END OF CHANNEL PERMUTATION PARFOR LOOP 
end




%end

