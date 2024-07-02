function [shuffledMs] = circularShuffleSpikeTimes(spikeMs,shuffMs)
%CIRCULARSHUFFLESPIKETIMES Summary of this function goes here
%   Detailed explanation goes here


             aboveMs = spikeMs(spikeMs > shuffMs) ;
             belowMs = spikeMs(spikeMs <= shuffMs);
             
             aboveMsOffset = aboveMs - shuffMs;
             belowMsOffset = belowMs + ( max(spikeMs) - shuffMs );
             
             shuffledMs = [aboveMsOffset, belowMsOffset];


end

