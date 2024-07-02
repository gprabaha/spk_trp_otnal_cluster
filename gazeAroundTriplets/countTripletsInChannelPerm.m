function [channelP_RealGazeTriplets,channelP_shuffledGazeTriplets] = countTripletsInChannelPerm(realTrips,shuffledTrips, behaviorEvents, windowMs)
%COUNTTRIPLETSINCHANNELPERM Summary of this function goes here
%   Detailed explanation goes here

%% Extract information about behaviors
allBehaviors = behaviorEvents.Label;
uniqueBehaviors = unique(behaviorEvents.Label);
numUniqueBehaviors= size(uniqueBehaviors,1);

%% Extract the real values and times of the triplets
realVals = realTrips.matrix(:,7);
realTimes = realTrips.matrix(:,4);

%% Extract the shuffled values and times of the triplets
shuffledVals = shuffledTrips.shuffledMatrix(:,7,:);
shuffledTimes  = shuffledTrips.shuffledMatrix(:,4,:);

%% Calcuate the permutations of triplet orderings that are possible
tripletOrderPerms  = permn(1:3, 3);
tripletOrderPermStrs = cell(size(tripletOrderPerms,1),1);
numTripletOrderPerms = size(tripletOrderPerms,1);

for to = 1:numTripletOrderPerms
    tripletOrderPermStrs{to} = sprintf('%1d_%1d_%1d', tripletOrderPerms(to,1), tripletOrderPerms(to,2), tripletOrderPerms(to,3));
end



%% Extract the number of shuffles for this dataset
numShuffles = size(shuffledTrips.shuffledMatrix,3);

%% Create 3-dimensional matrix for real output
%TRIPLET-ORDERING x BEHAVIORS x PRE/POST
channelP_RealGazeTriplets = nan(numTripletOrderPerms, numUniqueBehaviors, 2);

%% Create 4-dimensional matrix for shuffled output
% TRIPLET-ORDERING x BEHAVIORS x PRE/POST x SHUFFLES
channelP_shuffledGazeTriplets = nan(numTripletOrderPerms, numUniqueBehaviors, 2, numShuffles);



%% Triplet ordering loop
for to = 1:numTripletOrderPerms
    
    fprintf('\t%2d:\t%s\n',to, tripletOrderPermStrs{to});
    
    % Find the index that match this triplet ordering
    thisOrderingVal = to;
    thisOrderingIdxs = find(realVals == thisOrderingVal);
    
    %% Loop through each behavior we are comparing
    for b = 1:numUniqueBehaviors
        
        % Find the indexs that match this unique behavior
        thisBehavior = uniqueBehaviors{b};
        behaviorIdxs = find(strcmp(allBehaviors, thisBehavior));
        numBehaviorEvents = size(behaviorIdxs,1);
        fprintf('\t\t%2d-->\t%s\n',b, thisBehavior);
        
        % Create two arrays to hold the real counts of this triplet pre/post event
        realPreBehaviorCount = nan(1,numBehaviorEvents);
        realPostBehaviorCount = nan(1,numBehaviorEvents);
        
        %% Loop through each event in this behavior
        for e = 1:numBehaviorEvents
            
            % Find the time for this invdividual behavioral event
            ei = behaviorIdxs(e);
            eventStartS = behaviorEvents.StartS(ei);
            eventStartMs = eventStartS*1e3;
            
            % Find the start and stop of the epoch around behavior
            epochStartMs = eventStartMs - (windowMs/2);
            epochStopMs = eventStartMs + (windowMs/2);
            
            % Find all the triplets (of any ordering) in this epoch
            [eventTimeIdxs,~] = find(realTimes >= epochStartMs &realTimes < epochStopMs);
            
            % the intersection of triplets around the event and this ordering's indices are what we want
            thisOrderingEventIdxs = intersect(eventTimeIdxs, thisOrderingIdxs);
            
            % Convert the time to be relative to the start of the event window
            orderEventTimesRelative = realTimes(thisOrderingEventIdxs)-epochStartMs;
            
            % Store the re and post counts in the arrays
            realPreBehaviorCount(1, e) =  numel(find(orderEventTimesRelative < (windowMs/2)));
            realPostBehaviorCount(1, e) =  numel(find(orderEventTimesRelative > (windowMs/2)));
            
        end % End of behavior event loops
        
        %% Loop through the shuffled triplets to compare the real triplets
        
        % Create two arrays to hold the shuffled counts of this triplet pre/post event
        shuffledPreBehaviorCount = nan(numShuffles,numBehaviorEvents);
        shuffledPostBehaviorCount = nan(numShuffles,numBehaviorEvents);
        
        for s = 1:numShuffles
            
            theseShuffledTimes = shuffledTimes(:,s);
            theseShuffledVals = shuffledVals(:,s);
            
            thisShuffledOrderingIdxs = find(theseShuffledVals == thisOrderingVal);
            
            %% Loop through each event in this behavior
            for e = 1:numBehaviorEvents
                
                % Find the time for this invdividual behavioral event
                ei = behaviorIdxs(e);
                eventStartS = behaviorEvents.StartS(ei);
                eventStartMs = eventStartS*1e3;
                
                % Find the start and stop of the epoch around behavior
                epochStartMs = eventStartMs - (windowMs/2);
                epochStopMs = eventStartMs + (windowMs/2);
                
                % Find all the triplets (of any ordering) in this epoch
                [eventTimeIdxs,~] = find(theseShuffledTimes >= epochStartMs & theseShuffledTimes < epochStopMs);
                
                % the intersection of triplets around the event and this ordering's indices are what we want
                thisOrderingEventIdxs = intersect(eventTimeIdxs, thisShuffledOrderingIdxs);
         
                % Convert the time to be relative to the start of the event window
                orderEventTimesRelative = theseShuffledTimes(thisOrderingEventIdxs)-epochStartMs;
                
                % Store the re and post counts in the arrays
                shuffledPreBehaviorCount(s, e) =  numel(find(orderEventTimesRelative < (windowMs/2)));
                shuffledPostBehaviorCount(s, e) =  numel(find(orderEventTimesRelative > (windowMs/2)));
                
            end % End of behavior event loops
            
        end % End of shuffle loop
        
        %% Save the real and shuffled results
        
        % Real mean for pre-behavioral event
        channelP_RealGazeTriplets(to, b, 1) = mean(realPreBehaviorCount);
        
        % Real mean for post-behavioral event
        channelP_RealGazeTriplets(to, b, 2) = mean(realPostBehaviorCount);
        
        % Shuffled means for pre-behavioral event
        channelP_shuffledGazeTriplets(to, b, 1, :) = mean(shuffledPreBehaviorCount,2);
        
        % Shuffled means for post-behavioral event
        channelP_shuffledGazeTriplets(to, b, 2, :) = mean(shuffledPostBehaviorCount,2);
        
    end % End of unique behavior loop
    
end% End of triplet ordering loop

end % End of function

