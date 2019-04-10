% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

function mainplot(mark)

addpath '../../function';
% decide analysis which distance
% mark = 1;

Perc_prop_mark = input('>>>> plot perceived proportion? (e.g.: n or y):  ','s');


% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP'
    % 0.5 dva
    sbjnames = {'huijiahan'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
elseif mark == 2
    % 1.5 dva
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
    sbjnames = {'huijiahan'};
    lineAngleColumn = 7;
    
    % for test gabor line adjust
elseif mark == 3
    cd '../../data/GaborDrift/gabor_lineAdjust/1Ori1Dis'
    % 0.5 dva
    sbjnames = {'k2Ori'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
    
end



for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    gaborDistanceFromFixationDegree = [10];
    LineDegree10dva_left = zeros(8,1);
    LineDegree10dva_right = zeros(8,1);
    
     
    
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
    
    [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborStartLocation_L);
    [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborEndLocation_L);
    [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborStartLocation_R);
    [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborEndLocation_R);
    
    
    originX_L = [dotXpos_L_st,dotXpos_L_end];
    originY_L = [dotYpos_L_st,dotYpos_L_end];
    originX_R = [dotXpos_R_st,dotXpos_R_end];
    originY_R = [dotYpos_R_st,dotYpos_R_end];
    
    % plot the gabor trajactory
    gaborTraj_L = plot(originX_L,originY_L,'r-','MarkerFaceColor','r');
    hold on;
    gaborTraj_R = plot(originX_R,originY_R,'b-','MarkerFaceColor','b');
    % set the origin on the left top
    set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
       
    
    [dotXpos_R_delay,dotYpos_R_end] = LineAngle2Posi(LineAngle_ave(:,1),dotXpos_R_st,dotYpos_R_end,lineLengthPixel);
    graph_R = scatter(dotXpos_R_delay,dotYpos_R_end);
    hold on;
    [dotXpos_L_delay,dotYpos_L_end] = LineAngle2Posi(LineAngle_ave(:,2),dotXpos_L_st,dotYpos_L_end,lineLengthPixel);
    graph_L = scatter(dotXpos_L_delay,dotYpos_L_end);%,'color',colorMap,'marker','o','MarkerFaceColor',colorMap);
    
    title('apparent motion detect -- control','FontSize',30);
    
 
    hold on;
end
end
%     proporPerc_ste = ste(proporPerc,1);
%     % bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
%     errorbar(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,proporPerc_ste*100,'r.');
%     axis([-10 400 -10 100]);








