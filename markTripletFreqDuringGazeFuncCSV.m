 function markTripletFreqDuringGazeFunc(tripletsPath,eventsPath,shuffPath)


 load(tripletsPath, 'triplets');
 load(eventsPath, 'simpleEvents');
 load(shuffPath, 'shuffledTriplets');




allLabels = simpleEvents.Label;
uniqueLabels = unique(simpleEvents.Label);
numUniqueLabels = size(uniqueLabels,1);

windowMs = 2000;


tripletPerms  = permn(1:3, 3);
tripletPermStrs = cell(size(tripletPerms,1),1);
numTripletPerms = size(tripletPerms,1);

for tp = 1:numTripletPerms
    tripletPermStrs{tp} = sprintf('%1d-%1d-%1d', tripletPerms(tp,1), tripletPerms(tp,2), tripletPerms(tp,3));
end

for c = 1:size(triplets,2)



    realTrps = triplets(c);
    shuffTrps = shuffledTriplets(c);

    realVals = realTrps.matrix(:,7);
    realTimes = realTrps.matrix(:,4);

    shuffVals = shuffTrps.shuffledMatrix(:,7,:);
    shuffTimes  = shuffTrps.shuffledMatrix(:,4,:);


    np =size(shuffVals,3);

    UEM = struct;



    for u = 1:numUniqueLabels

        thisLabel = uniqueLabels{u};

        eventIdxs = find(strcmp(allLabels, thisLabel));

        numEvents = size(eventIdxs,1);

        eventMatrix = nan(numEvents, 2, numTripletPerms);
        thisShuff_eventMatrix = nan(numEvents, 2, numTripletPerms, np);

        for e = 1:numEvents

            ei = eventIdxs(e);

            eventStartS = simpleEvents.StartS(ei);
            %eventStopS = simpleEvents.StopS(ei);


            eventStartMs = eventStartS*1e3;

            epochStartMs = eventStartMs - (windowMs/2);
            epochStopMs = eventStartMs + (windowMs/2);

            [eventTidxs,~] = find(realTimes >= epochStartMs &realTimes < epochStopMs);

            %eventTms_abs = realTimes(eventTidxs);
            eventTms_rel = realTimes(eventTidxs)-epochStartMs;
            eventTvals = realVals(eventTidxs);


            for tp = 1:numTripletPerms

                thisTPIdxs = find(eventTvals == tp);

                for i = 1:size(thisTPIdxs,1)

                    thisTPTime = round(eventTms_rel(thisTPIdxs(i)));

                    if thisTPTime < (windowMs/2)

                        eventMatrix(e, 1, tp) = 1;
                    else
                        eventMatrix(e, 2, tp) = 1;
                    end
                end
            end



            for s = 1:np

                thisShuff_Times = shuffTimes(:,s);
                %thisShuff_Vals = shuffVals(:,:,s);

                [thisShuff_eventTidxs,~] = find(thisShuff_Times >= epochStartMs &thisShuff_Times < epochStopMs);

                %thisShuff_eventTms_abs = realTimes(thisShuff_eventTidxs);%Index exceeds the number of array elements (42578).
                thisShuff_eventTms_rel = realTimes(thisShuff_eventTidxs)-epochStartMs;
                thisShuff_eventTvals = shuffVals(thisShuff_eventTidxs);

                for tp = 1:numTripletPerms

                    thisShuff_thisTPIdxs = find(thisShuff_eventTvals == tp);

                    for i = 1:size(thisShuff_thisTPIdxs,1)

                        thisShuff_thisTPTime = round(thisShuff_eventTms_rel(thisShuff_thisTPIdxs(i)));



                        if thisShuff_thisTPTime < (windowMs/2)

                            thisShuff_eventMatrix(e, 1, tp, s) = 1;
                        else
                            thisShuff_eventMatrix(e, 2, tp, s) = 1;
                        end


                    end

                end


            end

        end

        UEM(u).eventMatrix = eventMatrix;
        UEM(u).shuffMatrix = thisShuff_eventMatrix;

        clear thisShuff_eventMatrix eventMatrix

    end




    pre_HR = nan(numUniqueLabels, tp);
    post_HR = nan(numUniqueLabels, tp);

    shuff_pre_HR = nan(numUniqueLabels, tp, np);
    shuff_post_HR = nan(numUniqueLabels, tp, np);



    for tp = 1:numTripletPerms



        for u = 1:numUniqueLabels

            thisMatrix = UEM(u).eventMatrix(:,:,tp);

            sum = nansum(thisMatrix);

            numE = size(thisMatrix,1);

            meanSum = sum/numE;


            pre_HR(u, tp) = nanmean(meanSum(1));

            post_HR(u, tp) = nanmean(meanSum(2));


            for s = 1:np

                 thisShuffMatrix = squeeze(UEM(u).shuffMatrix(:,:,tp,s));


                 shuffSum = nansum(thisShuffMatrix);

                  shuffNumE = size(thisShuffMatrix,1);

                   shuffMeanSum = shuffSum/shuffNumE;

                    shuff_pre_HR(u, tp, s) = nanmean(shuffMeanSum(1));

                    shuff_post_HR(u, tp, s) = nanmean(shuffMeanSum(2));


            end

        end

    end




    for u = 1:numUniqueLabels


        IDStr = triplets(c).IDStr;
        regionStr = triplets(c).regionStr;
        c1_UUID = triplets(c).c1_UUID;
        c2_UUID = triplets(c).c2_UUID;
        c3_UUID = triplets(c).c3_UUID;


        gazeLabel = uniqueLabels{u};


        yVals = pre_HR(u, :);
        xVals = squeeze(shuff_pre_HR(u, :, :));
        for tp = 1:numTripletPerms
            yv = yVals(tp);


            shuffsGreaterThan = numel(find(yv>xVals(tp,:)));

            %if shuffsGreaterThan >= 95 || shuffsGreaterThan <= 5



                markTriplets(IDStr, regionStr, c1_UUID, c2_UUID, c3_UUID, gazeLabel, tp, shuffsGreaterThan, 'pre')

            %end

        end





              yVals = post_HR(u, :);
        xVals = squeeze(shuff_post_HR(u, :, :));
        for tp = 1:numTripletPerms
            yv = yVals(tp);


          shuffsGreaterThan = numel(find(yv>xVals(tp,:)));

           % if shuffsGreaterThan >= 95 || shuffsGreaterThan <= 5

                %shuffsGreaterThan = numel(find(yv>xVals(tp,:)));

                markTriplets(IDStr, regionStr, c1_UUID, c2_UUID, c3_UUID, gazeLabel, tp, shuffsGreaterThan, 'post')

           % end

        end


    end






end



 end


 function markTriplets(IDStr, regionStr, c1_UUID, c2_UUID, c3_UUID, gazeLabel, tp, shuffsGreaterThan, periodStr)




  C = {'NT', IDStr, regionStr, c1_UUID, c2_UUID, c3_UUID, gazeLabel, tp, shuffsGreaterThan, periodStr};
  writecell(C,'AMarkedTripletsCSV.csv', 'WriteMode', 'append')
 end
