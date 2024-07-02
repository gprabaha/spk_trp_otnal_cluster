function findStructuredTriplets(IDStr, regionStr)
%FINDSTRUCTUREDTRIPLETS Summary of this function goes here
%   Detailed explanation goes here

% IDStr = '01022019';
% regionStr = 'ofc';

[cfg] = SPKTRP_getConfig();

windowMs = 150;

sessionPath = fullfile(cfg.spkDataDir, IDStr);
spikePath = fullfile(sessionPath, sprintf('%s_%s_spiketimes.mat', IDStr, regionStr));

if exist(spikePath, 'file')
    
    spikeLoad = load(spikePath, 'spktms');
    
    spikeTimes = spikeLoad.spktms;
    
    triplets = struct();
    
    
    numChans = size(spikeTimes,2);
    
    maxMs = max([spikeTimes.spikeMs]);
    
    chanPerms = nchoosek(1:numChans, 3);
    numChanPerms = size(chanPerms,1);
    
    tripletPerms  = permn(1:3, 3);
    
    tripletPermStrs = cell(size(tripletPerms,1),1);
    
    for tp = 1:size(tripletPerms,1)
        tripletPermStrs{tp} = sprintf('%1d-%1d-%1d', tripletPerms(tp,1), tripletPerms(tp,2), tripletPerms(tp,3));
    end
    
    for cp = 1:numChanPerms
        
        c1 = chanPerms(cp,1);
        c2 = chanPerms(cp,2);
        c3 = chanPerms(cp,3);
        
        c1_spikeMs = spikeTimes(c1).spikeMs;
        c2_spikeMs = spikeTimes(c2).spikeMs;
        c3_spikeMs = spikeTimes(c3).spikeMs;
        
        tc = 0; % Triplet Counts
        tm = nan(tc,7);
        
        allSpikeMs = sort([c1_spikeMs, c2_spikeMs, c3_spikeMs]);
        
        for ms = allSpikeMs  
            
            binStartMs = ms;
            binStopMs = ms+windowMs;
            

            
            permStr = sprintf('%s-%s-%s', spikeTimes(c1).chanStr, spikeTimes(c2).chanStr, spikeTimes(c3).chanStr);
            
            
            c1_binSpikeMs = c1_spikeMs( c1_spikeMs >= binStartMs & c1_spikeMs < binStopMs);
            c2_binSpikeMs = c2_spikeMs( c2_spikeMs >= binStartMs & c2_spikeMs < binStopMs);
            c3_binSpikeMs = c3_spikeMs( c3_spikeMs >= binStartMs & c3_spikeMs < binStopMs);
            
            
            if sum([numel(c1_binSpikeMs) numel(c2_binSpikeMs) numel(c3_binSpikeMs)]) >= 3
                

                allChanSpikeMs = [c1_binSpikeMs, c2_binSpikeMs, c3_binSpikeMs];
                allChanSpikeChanIdxs = [ones(size(c1_binSpikeMs))*1, ones(size(c2_binSpikeMs))*3, ones(size(c3_binSpikeMs))*3];
                
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
        triplets(cp).permStr = permStr;
        triplets(cp).c1 = c1;
        triplets(cp).c2 = c2;
        triplets(cp).c3 = c3;
        
        
        
    end
    
    
    
    
end

try
   
   
    savePath = fullfile(sessionPath, sprintf('%s_%s_triplets.mat', IDStr, regionStr));
    save(savePath, 'triplets')
    
catch saveErr
    fprintf('Could not save extracted spike triplets from %s at %s\n!', IDStr, savePath), 
end


%end

