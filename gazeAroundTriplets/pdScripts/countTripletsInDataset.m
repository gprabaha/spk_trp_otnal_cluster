
function [realGazeTriplets, shuffledGazeTriplets] = countTripletsInDataset(tripletPath,shuffledPath, behaviorPath)
%
% if exist('shuffledTriplets', 'var') && exist('triplets', 'var') && exist('simpleEvents', 'var')
%     keep shuffledTriplets triplets simpleEvents
% else
%     clearvars
%     clc
%     load('/Users/putnampt/Dropbox (ChangLab)/ptp/spikeTriplets/brainsData/interactiveTask/01192018/01192018_accg_shuffledTriplets.mat')
%     load('/Users/putnampt/Dropbox (ChangLab)/ptp/spikeTriplets/brainsData/interactiveTask/01192018/01192018_accg_triplets.mat')
%     load('/Users/putnampt/Dropbox (ChangLab)/ptp/spikeTriplets/brainsData/interactiveTask/01192018/01192018_simpleEvents.mat')
% end

load(tripletPath, 'triplets');
load(shuffledPath, 'shuffledTriplets');
load(behaviorPath, 'simpleEvents');

fprintf('========================= DATA LOADED ========================\n');

%% Settings
windowMs = 2000; % Total window (in ms) around each behavioral event

%% Find the number of channel permutations that exist for this dataset
numChannelPerms = size(triplets,2);


%% Find the unique behavioral events that we are looking at
behaviorEvents = simpleEvents;

%% Extract information about behaviors
uniqueBehaviors = unique(behaviorEvents.Label);
numUniqueBehaviors= size(uniqueBehaviors,1);



%% Calcuate the permutations of triplet orderings that are possible
tripletOrderPerms  = permn(1:3, 3);
tripletOrderPermStrs = cell(size(tripletOrderPerms,1),1);
numTripletOrderPerms = size(tripletOrderPerms,1);

for to = 1:numTripletOrderPerms
    tripletOrderPermStrs{to} = sprintf('%1d_%1d_%1d', tripletOrderPerms(to,1), tripletOrderPerms(to,2), tripletOrderPerms(to,3));
end

% This should match all subsequent data in the structure
numShuffles = size(shuffledTriplets(1).shuffledMatrix,3);


%% Create 4-dimensional matrix for real output
% CHANNEL-PERMUTATIONS x TRIPLET-ORDERING x BEHAVIORS x PRE/POST
realGazeTriplets = nan(numChannelPerms, numTripletOrderPerms, numUniqueBehaviors, 2);

%% Create 5-dimensional matrix for shuffled output
% CHANNEL-PERMUTATIONS x TRIPLET-ORDERING x BEHAVIORS x PRE/POST x SHUFFLES
shuffledGazeTriplets = nan(numChannelPerms, numTripletOrderPerms, numUniqueBehaviors, 2, numShuffles);


%poolobj = parpool(feature('NumCores'));
%addAttachedFiles(poolobj,{tripletPath, shuffledPath, simpleEvents});

fprintf('========================= LOOPING ========================\n');

%% Channel permutation loop
for cp = 1:numChannelPerms


    % Extract the real triplet values and times
    realTrips = triplets(cp);

    % Extract the shuffled triplet values and times
    shuffledTrips = shuffledTriplets(cp);

    % Get the string of UUIDs for this channel permutation
    UUIDStr =  realTrips.UUIDStr;

    fprintf('%04d/%04d\tChannel permutation: %s\n',cp,numChannelPerms, UUIDStr);

    % Run the function to count the triplets around behavioral events
    [channelP_RealGazeTriplets,channelP_shuffledGazeTriplets] = countTripletsInChannelPerm(realTrips,shuffledTrips, behaviorEvents, windowMs);

    fprintf('========================== DONE ==========================\n\n\n\n');

    % Store the output in the matrix
    realGazeTriplets(cp,:,:,:) = channelP_RealGazeTriplets;
    shuffledGazeTriplets(cp,:,:,:,:) = channelP_shuffledGazeTriplets;

end% End of Channel permutation loop

%save(savePath, 'realGazeTriplets',  'shuffledGazeTriplets');

fprintf('===========================================================\n');
fprintf('========================= FINISHED ========================\n');
fprintf('===========================================================\n\n\n\n');
