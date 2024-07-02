function  saveErr(err)
%SAVEERR Summary of this function goes here
%   Detailed explanation goes here

if ~isfolder(fullfile(pwd,'errors')), mkdir(fullfile(pwd,'errors')), end

    try
        
        savePath = fullfile(fullfile(pwd,'errors'), sprintf('Error_%s.mat',  datestr(clock,'YYYY-mm-dd-HH-MM-SS-FFF')));
        
        save(savePath, 'err');

    catch saveErr

    end


end

