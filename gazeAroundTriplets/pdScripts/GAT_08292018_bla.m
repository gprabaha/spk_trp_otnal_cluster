[cfg] = SPKTRP_getConfig();
IDStr = '08292018';
regionStr = 'bla';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_tripletsDuringGaze.mat', IDStr, regionStr));
[realGazeTriplets, shuffledGazeTriplets] = countTripletsDuringGazeFunc(IDStr, regionStr);
save(savePath, 'realGazeTriplets', 'shuffledGazeTriplets')