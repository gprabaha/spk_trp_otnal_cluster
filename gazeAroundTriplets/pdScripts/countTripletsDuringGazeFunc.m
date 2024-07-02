function [realGazeTriplets, shuffledGazeTriplets] = countTripletsDuringGazeFunc(IDStr, regionStr)
%COUNTTRIPLETSDURINGGAZEFUNC Summary of this function goes here
%   Detailed explanation goes here

fprintf('------------------------------------------------------------------------\n')
fprintf('\tStarting triplet counting around gaze for %s %s\n', IDStr, regionStr)
fprintf('------------------------------------------------------------------------\n\n\n\n')

[cfg] = SPKTRP_getConfig();

tripletPath = fullfile(cfg.spkDataDir, IDStr, sprintf('%s_%s_triplets.mat',IDStr, regionStr));
shuffledPath = fullfile(cfg.spkDataDir, IDStr, sprintf('%s_%s_shuffledTriplets.mat',IDStr, regionStr));
behaviorPath = fullfile(cfg.spkDataDir, IDStr, sprintf('%s_simpleEvents.mat',IDStr));

if exist(tripletPath, 'file') && exist(shuffledPath, 'file') && exist(behaviorPath, 'file')

    fprintf('################################################################################\n')
    fprintf('\tFiles found for %s %s, starting countTripletsInDataset function! \n', IDStr, regionStr)
    fprintf('################################################################################\n\n\n')


    [realGazeTriplets, shuffledGazeTriplets] = countTripletsInDataset(tripletPath,shuffledPath, behaviorPath);

    fprintf('################################################################################\n')
    fprintf('\tFunction countTripletsInDataset finished, returning vars to be saved! \n')
    fprintf('################################################################################\n\n\n')

else
    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n')
    fprintf('\tFiles NOT FOUND for %s %s, ENDING :( \n', IDStr, regionStr)
    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n')
end
end
