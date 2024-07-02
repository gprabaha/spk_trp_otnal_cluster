
    %% Plot the results if specified 
    if plotResults
        figH = figure(1);
        clf;
        
        
        realPreMeans =  squeeze(realGazeTriplets(cp, :, :, 1));
        realPostMeans =  squeeze(realGazeTriplets(cp, :, :, 2));
        
        shuffledPreMeans =  squeeze(shuffledGazeTriplets(cp, :, :, 1, :));
        shuffledPostMeans =  squeeze(shuffledGazeTriplets(cp, :, :, 2, :));
        
        orderingMeans = mean(realPreMeans,2)+mean(realPostMeans,2);
        
        [~,sortedIdxs] = sort(orderingMeans, 'descend');
        
 
        for b = 1:numUniqueBehaviors
            
            thisBehaviorRealPreMeans = realPreMeans(:,b);
            thisBehaviorRealPostMeans = realPostMeans(:,b);
            
            thisBehaviorShuffledPreMeans = squeeze(shuffledPreMeans(:,b,:));
            thisBehaviorShuffledPostMeans = squeeze(shuffledPreMeans(:,b,:));
            
        
            realPreMeanPlot = thisBehaviorRealPreMeans(sortedIdxs);
             realPostMeanPlot = thisBehaviorRealPostMeans(sortedIdxs);
             
           
             figH = figure(1);
              options.handle= figH;
           options.color_area= behaviorColors(b,:);
           options.color_line = behaviorColors(b,:);
           options.alpha = 0.2;
           options.line_width =.00001;                      %
           options.error = 'c95';
             
            ax(1) = subplot(2,numUniqueBehaviors,b);
            hold on;
           plot(realPreMeanPlot, 'Color', behaviorColors(b,:), 'LineWidth', 4);
           set(gca, 'YScale', 'log')
           
          
           plot_areaerrorbar(thisBehaviorShuffledPreMeans(sortedIdxs,:)', options)
            
            ax(2) = subplot(2,numUniqueBehaviors,b+numUniqueBehaviors);
            hold on;
           plot(realPostMeanPlot, 'Color', behaviorColors(b,:), 'LineWidth', 4);
           set(gca, 'YScale', 'log')
           plot_areaerrorbar(thisBehaviorShuffledPostMeans(sortedIdxs,:)', options)
           
           for toc = 1:numTripletOrderPerms
               
               to = sortedIdxs(toc);
               
               outsideNullRange = numShuffles*twoSidedAlpha;
               
               realPreValue = thisBehaviorRealPreMeans(to);
               shuffledPreValues = thisBehaviorShuffledPreMeans(to,:);
               
               realPreNumAbove = numel(find(realPreValue >= shuffledPreValues));
               realPreNumBelow = numel(find(realPreValue <= shuffledPreValues));
               
               if realPreNumAbove > numShuffles-outsideNullRange
                   
                   subplot(2,numUniqueBehaviors,b);
                   hold on;
                   scatter(toc, (realPreValue+(realPreValue*.1)), '*', 'MarkerEdgeColor',behaviorColors(b,:),...
              'MarkerFaceColor',behaviorColors(b,:),...
              'LineWidth',1.5)
                   
               elseif realPreNumBelow < numShuffles-outsideNullRange
                   
                   subplot(2,numUniqueBehaviors,b);
                   hold on;
                   scatter(toc, (realPreValue-(realPreValue*.1)), 'pentagram', 'MarkerEdgeColor',behaviorColors(b,:),...
              'MarkerFaceColor',behaviorColors(b,:),...
              'LineWidth',1.5)
               end
               
               
               
                realPostValue = thisBehaviorRealPostMeans(to);
               shuffledPostValues = thisBehaviorShuffledPostMeans(to,:);
               
               realPostNumAbove = numel(find(realPostValue >= shuffledPostValues));
               realPostNumBelow = numel(find(realPostValue <= shuffledPostValues));
               
                if realPostNumAbove > numShuffles-outsideNullRange
                   
                   subplot(2,numUniqueBehaviors,b+numUniqueBehaviors);
                   hold on;
                   scatter(toc, (realPostValue+(realPostValue*.1)), '*', 'MarkerEdgeColor',behaviorColors(b,:),...
              'MarkerFaceColor',behaviorColors(b,:),...
              'LineWidth',1.5)
                   
               elseif realPostNumBelow < numShuffles-outsideNullRange
                   
                   subplot(2,numUniqueBehaviors,b+numUniqueBehaviors);
                   hold on;
                   scatter(toc, (realPostValue-(realPostValue*.1)), 'pentagram', 'MarkerEdgeColor',behaviorColors(b,:),...
              'MarkerFaceColor',behaviorColors(b,:),...
              'LineWidth',1.5)
               end
               
               
               
               
               
               
           end
           
        end
        
        linkaxes(ax)
        
        pause
    else
        
    end