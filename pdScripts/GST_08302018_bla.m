%Auto-generated at July 03, 2024  4:12:25.416 PM
[cfg] = SPKTRP_getConfig();
IDStr = '08302018';
regionStr = 'bla';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
[shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);
save(savePath, 'shuffledTriplets')
