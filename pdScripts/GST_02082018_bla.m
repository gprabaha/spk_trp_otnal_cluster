%Auto-generated at July 03, 2024  4:10:41.107 PM
[cfg] = SPKTRP_getConfig();
IDStr = '02082018';
regionStr = 'bla';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
[shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);
save(savePath, 'shuffledTriplets')
