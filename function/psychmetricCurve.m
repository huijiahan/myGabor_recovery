function [rightTimes_L,rightTimesTotal_L,rightTimes_R,rightTimesTotal_R] = psychmetricCurve(RespMat,barDisFromGaborStartDeg);
    
    
    [rightTimes_L,rightTimes_R] = deal(zeros(length(barDisFromGaborStartDeg),1));
    [rightTimesTotal_L,rightTimesTotal_L,rightTimesTotal_R,rightTimesTotal_R] = deal(zeros(length(barDisFromGaborStartDeg),1));
    
    
    %%%------------------------------------------------------
    % response 'right'  delete  gabor break through trial
    %%%------------------------------------------------------
    for i = 1:length(RespMat)
        for barLoc = 1:length(barDisFromGaborStartDeg)
            % bar location 
            if str2double(RespMat(i,5)) == barDisFromGaborStartDeg(barLoc)
                switch RespMat(i,3)
                    % leftward response = 0
                    case  'upperRight_leftward'
                        % isnan == 0 means response left or right or break
                        % through
                        % isnan == 0  means not NaN 
                        % RespMat(i,7) = 0  left 
                        if  isnan(str2double(RespMat(i,7))) == 0  && str2double(RespMat(i,7)) < 2
                            rightTimesTotal_L(barLoc) = rightTimesTotal_L(barLoc) + 1;
                            rightTimes_L(barLoc) =  rightTimes_L(barLoc) + str2double(RespMat(i,7));
                        end
                        % rightward response = 1
                        % RespMat(i,7) = 1  right
                    case  'upperRight_rightward'
                        if  isnan(str2double(RespMat(i,7))) == 0 && str2double(RespMat(i,7)) < 2
                            rightTimesTotal_R(barLoc) = rightTimesTotal_R(barLoc) + 1;
                            rightTimes_R(barLoc) =  rightTimes_R(barLoc) + str2double(RespMat(i,7));
                        end
                end
            end
        end
    end