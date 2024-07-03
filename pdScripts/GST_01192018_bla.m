%Auto-generated at July 03, 2024  4:09:33.641 PM
[cfg] = SPKTRP_getConfig();
IDStr = '01192018';
regionStr = 'bla';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
[shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);
save(savePath, 'shuffledTriplets')
