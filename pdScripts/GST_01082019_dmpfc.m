%Auto-generated at July 03, 2024  4:05:33.621 PM
[cfg] = SPKTRP_getConfig();
IDStr = '01082019';
regionStr = 'dmpfc';
sessionPath = fullfile(cfg.spkDataDir, IDStr);
savePath = fullfile(sessionPath, sprintf('%s_%s_shuffledTriplets.mat', IDStr, regionStr));
[shuffledTriplets] = generateShuffledTripletsFunc(IDStr, regionStr);
save(savePath, 'shuffledTriplets')
