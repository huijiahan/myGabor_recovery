% randomize the given matrix into sequence order(subData) and random order(blockData)


function [blockData,subData]=randCondi(gaborDistanceFromFixationDegree,gaborMatSingle,...
    intervalTimesMatSingle,cueVerDisDegree,trialNumber);



k = 0;

% trial repeatTimes of each combined condition
repeatTimes = trialNumber/(length(gaborMatSingle)*length(intervalTimesMatSingle)...
    *length(gaborDistanceFromFixationDegree)*length(cueVerDisDegree));

factor1 = [1:length(gaborDistanceFromFixationDegree)]; % blockData 1
factor2 = [1:length(gaborMatSingle)]; % blockData 2
factor3 = [1:length(intervalTimesMatSingle)]; % blockData 3
factor4 = [1:length(cueVerDisDegree)];% blockData 4

for i1 = 1:length(factor1)
    for i2 = 1:length(factor2)
        for i3 = 1:length(factor3)
            for i4 = 1:length(factor4)
                k = k + 1;
                pickupData(k,:) = [factor1(i1),factor2(i2),factor3(i3),factor4(i4)];
            end
        end
    end
end

subData = repmat(pickupData,repeatTimes,1);
blockData = [subData(Shuffle(1:length(subData)),:)];
end