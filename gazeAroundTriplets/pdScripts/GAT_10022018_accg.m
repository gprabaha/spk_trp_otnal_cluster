[cfg] = SPKTRP_getConfig();
IDStr = '10022018';
regionStr = 'accg';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_tripletsDuringGaze.mat', IDStr, regionStr));
[realGazeTriplets, shuffledGazeTriplets] = countTripletsDuringGazeFunc(IDStr, regionStr);
save(savePath, 'realGazeTriplets', 'shuffledGazeTriplets')
