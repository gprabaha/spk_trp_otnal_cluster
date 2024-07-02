clear all
clc
[cfg] = SPKTRP_getConfig();

dataDirStruct= dir(cfg.spkDataDir);

for i = 1:size(dataDirStruct,1)

    if dataDirStruct(i).name(1) ~= '.'


        IDStr = dataDirStruct(i).name;



        shuffTripsStruct = dir(fullfile(cfg.spkDataDir, IDStr, '*shuffledTriplets.mat'));

        eventsPath = fullfile(cfg.spkDataDir, IDStr, sprintf('%s_simpleEvents.mat', IDStr));


        for r = 1:size(shuffTripsStruct,1)

            shuffPath = fullfile(shuffTripsStruct(r).folder, shuffTripsStruct(r).name);

            tripletsPath = strrep(shuffPath, 'shuffledTriplets', 'triplets');


          fprintf('Attempting %s/%s/%s.....', eventsPath, tripletsPath, shuffPath)

           %if isfile(eventsPath) && isfile(tripletsPath) && isfile(shuffPath)
           %(filename, 'file') == 2
           if exist(eventsPath) == 2 && exist(tripletsPath) == 2 && exist(shuffPath) == 2
               try
                 fprintf(' Found! marking triplets...')

                markTripletFreqDuringGazeFuncCSV(tripletsPath,eventsPath,shuffPath)

               catch err
                 try
                   %saveErr(err);

                   errSavePath = fullfile(fullfile(pwd,'errors'), sprintf('Error_%s.mat',  datestr(clock,'YYYY-mm-dd-HH-MM-SS-FFF')));

                   save(errSavePath, 'err');

                 catch sErr
                   sErr
                 end
               end
           else
              fprintf('Not Found!');
           end
           fprintf('\n');

        end
    end
end
