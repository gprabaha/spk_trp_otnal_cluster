%Auto-generated at July 03, 2024  4:07:13.011 PM
[cfg] = SPKTRP_getConfig();
IDStr = '01132019';
regionStr = 'dmpfc';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
[shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);
save(savePath, 'shuffledTriplets')
