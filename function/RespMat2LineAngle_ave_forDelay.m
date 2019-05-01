% RespMat to Line angle ave have to be the data from which response is
% adjustable line

function  [LineAngle_ave,LineDegree10dva_right_ave,LineDegree10dva_left_ave] = RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,...
    gaborDistanceFromFixationDegree)



LineDegree10dva_left = zeros(8,1);
LineDegree10dva_right = zeros(8,1);
% LineDegree7dva_left = zeros(8,1);
% LineDegree7dva_right = zeros(8,1);

lineAngleColumn = 7;


for i = 1 : length(RespMat)
    
    if str2double(RespMat(i,5)) == 7
        
        for delay1 = 1 :length(intervalTimesMatSingle)
            
            if  str2double(RespMat(i,4)) == intervalTimesMatSingle(delay1)
                
                switch RespMat(i,3)
                    % left 1   right 0
                    % record the apparent motion from perceived path
                    % leftward perceived end  lingAngle is < 0
                    case 'upperRight_leftward'
                        LineDegree7dva_left(delay1) = LineDegree7dva_left(delay1) + str2double(RespMat(i,lineAngleColumn));
                        % rightward perceived end  lingAngle is > 0
                    case 'upperRight_rightward'
                        LineDegree7dva_right(delay1) = LineDegree7dva_right(delay1) + str2double(RespMat(i,lineAngleColumn));
                end
            end
        end
    elseif str2double(RespMat(i,5)) == 10
        for delay2 = 1:length(intervalTimesMatSingle)
            if  str2double(RespMat(i,4)) == intervalTimesMatSingle(delay2)
                switch RespMat(i,3)
                    % left 1   right 0
                    % record the apparent motion from real path
                    case 'upperRight_leftward'
                        LineDegree10dva_left(delay2) = LineDegree10dva_left(delay2) + str2double(RespMat(i,lineAngleColumn));
                    case 'upperRight_rightward'
                        LineDegree10dva_right(delay2) = LineDegree10dva_right(delay2) + str2double(RespMat(i,lineAngleColumn));
                end
            end
        end
    end
end
% end

trialNumPerCondition = length(RespMat)/(length(intervalTimesMatSingle)*length(gaborDistanceFromFixationDegree));
LineAngle_ave = [LineDegree10dva_right LineDegree10dva_left]/(trialNumPerCondition/2);
LineDegree10dva_right_ave = LineDegree10dva_right/(trialNumPerCondition/2);
LineDegree10dva_left_ave = LineDegree10dva_left/(trialNumPerCondition/2);

end