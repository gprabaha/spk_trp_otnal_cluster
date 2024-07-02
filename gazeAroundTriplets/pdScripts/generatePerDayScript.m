function  generatePerDayScript(IDStr, regionStr, savePath)
%GENERATEPERDAYSCRIPT Summary of this function goes here
%   Detailed explanation goes here

FID = fopen(savePath, 'w');

fprintf(FID, '%Auto-generated at %s\n', datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM'));
fprintf(FID, '%s\n', '[cfg] = SPKTRP_getConfig();');
fprintf(FID, 'IDStr = ''%s'';\n', IDStr);
fprintf(FID, 'regionStr = ''%s'';\n', regionStr);
fprintf(FID, '%s\n', 'sessionPath = fullfile(cfg.spkDataDir, IDStr);');
fprintf(FID, '%s\n', 'savePath = fullfile(sessionPath, sprintf(''%s_%s_tripletsDuringGaze.mat'', IDStr, regionStr));');
fprintf(FID, '%s\n', '[realGazeTriplets, shuffledGazeTriplets] = countTripletsDuringGazeFunc(IDStr, regionStr);');
fprintf(FID, '%s\n', 'save(savePath, ''realGazeTriplets'', ''shuffledGazeTriplets'')');


fclose(FID);




end
