%Auto-generated at July 03, 2024  4:10:40.207 PM
[cfg] = SPKTRP_getConfig();
IDStr = '02062018';
regionStr = 'ofc';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
[shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);
save(savePath, 'shuffledTriplets')
