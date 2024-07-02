%function batchGeneratePDScripts()
clear all
clc
%BATCHFINDTRIPLETS Summary of this function goes here
%   Detailed explanation goes here
%
[cfg] = SPKTRP_getConfig();


% load('/Users/putnampt/dev/pastdoc/spiketriplets/SPKTRP.cfg','-mat')

dataDirStruct= dir(cfg.spkDataDir);

count = 0;

for i = 1:size(dataDirStruct,1)

    if dataDirStruct(i).name(1) ~= '.'

        try

            IDStr = dataDirStruct(i).name;
            sessionPath = fullfile(cfg.spkDataDir, IDStr);

            sessionPathDir = dir(fullfile(sessionPath,'*triplets.mat'));

            for j = 1:size(sessionPathDir,1)

                filePath = fullfile(sessionPathDir(j).folder, sessionPathDir(j).name);
                
                [~, temp,~ ] = fileparts(filePath);
                
                [i] = regexp(temp,'_*_');
                
                regionStr = temp(i(1)+1:i(2)-1);
                
%                 pause
% 
%                 loadStruct = load(filePath);
% 
%                 regionStr = loadStruct(1).triplets(1).regionStr;

                count = count+1;

                generatePDScripts(IDStr,regionStr, count);

            end
        catch err
            try
                saveErr(err);
            catch

            end
        end
    end



end