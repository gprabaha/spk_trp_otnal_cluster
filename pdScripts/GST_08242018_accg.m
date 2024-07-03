%Auto-generated at July 03, 2024  4:10:42.338 PM
[cfg] = SPKTRP_getConfig();
IDStr = '08242018';
regionStr = 'accg';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
[shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);
save(savePath, 'shuffledTriplets')
