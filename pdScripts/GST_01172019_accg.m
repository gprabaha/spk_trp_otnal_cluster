%Auto-generated at July 03, 2024  4:09:26.933 PM
[cfg] = SPKTRP_getConfig();
IDStr = '01172019';
regionStr = 'accg';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
[shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);
save(savePath, 'shuffledTriplets')
