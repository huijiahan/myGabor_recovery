% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
clear all;
addpath '../../function';
% decide analysis which distance


Perc_prop_mark = input('>>>> plot each perceived proportion? (e.g.: n or y):  ','s');
Perc_loca_mark = input('>>>> scatter perceived location? (e.g.: n or y):  ','s');

mark = 2;
% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP'
    % 0.5 dva
    sbjnames = {'guofanhua'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
elseif mark == 2
    % 1.5 dva
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
    sbjnames = {'guofanhua'};
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
    
    %%%--------------------------------------
    %     plot the gabor trajactory
    %%%--------------------------------------
    
    if Perc_loca_mark == 'y'       
        gaborTraj_L = plot(originX_L,originY_L,'r-','MarkerFaceColor','r');
        hold on;
        gaborTraj_R = plot(originX_R,originY_R,'b-','MarkerFaceColor','b');
        % set the origin on the left top
        set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
    end
    
    %%%--------------------------------------------------
    %     plot the perceived location caculated by angle
    %%%--------------------------------------------------
    if Perc_loca_mark == 'y'
        [dotXpos_R_delay,dotYpos_R_end] = LineAngle2Posi(LineAngle_ave(:,1),dotXpos_R_st,dotYpos_R_end,lineLengthPixel);
        graph_R = scatter(dotXpos_R_delay,dotYpos_R_end,'bo');
        % make the control plot different color
        if mark == 2
            graph_R = scatter(dotXpos_R_delay,dotYpos_R_end,'marker','o','MarkerFaceColor','g');
        end
        hold on;
        [dotXpos_L_delay,dotYpos_L_end] = LineAngle2Posi(LineAngle_ave(:,2),dotXpos_L_st,dotYpos_L_end,lineLengthPixel);
        graph_L = scatter(dotXpos_L_delay,dotYpos_L_end,'ro');%,'color',colorMap,'marker','o','MarkerFaceColor',colorMap);
        if mark == 2
            graph_L = scatter(dotXpos_L_delay,dotYpos_L_end,'marker','o','MarkerFaceColor','m');
        end
        if mark == 1
            title('apparent motion location detect','FontSize',30);
        elseif mark ==  2
            title('apparent motion location detect -- control','FontSize',30);
        end
    end
%     legend(['S' num2str(sbjnum)]);
    legend('S2');
    %%%--------------------------------------------------
    %     plot the perceived proportion
    %%%--------------------------------------------------
    % angle devide the physical angle is the proportion of perceived
    % 0 is from physical endpoint  1 is from perceived endpoint
    for delay = 1: length(intervalTimesMatSingle)
        for j = 1:size(LineAngle_ave,2)
            if j == 1 % rightward
                Perc_prop_temp(delay,j) = 1/2 + LineAngle_ave(delay,j)/(ang2radi(meanSubIlluDegree(j)));
            elseif j == 2 % leftward
                Perc_prop_temp(delay,j) = 1/2 - LineAngle_ave(delay,j)/(ang2radi(meanSubIlluDegree(j)));
            end
        end
    end
    
    
    Perc_prop(:,sbjnum) = mean(Perc_prop_temp,2);
    Perc_prop_norm = mean(Perc_prop,2);
    
    figure;
    if Perc_prop_mark == 'y'
        if mark == 1
            plot(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100,'color','r');            
        elseif mark == 2
            plot(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100,'color','b');
        end
        hold on;
        %         set(gca,'XAxisLocation','top','YAxisLocation','left','ydir');
    
    end

end

if Perc_prop_mark == 'n'
    if mark == 1
        h1 = plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'color','r');
        hold on;
        Perc_prop_ste = ste(Perc_prop*100,2);
        errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'r.');
        legend([h1],'AP');
    elseif mark == 2
        h2 = plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'color','b');
        Perc_prop_ste = ste(Perc_prop*100,2);
        errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'b.');
        legend([h2],'control');
    end
end
    title('proportion of apparent motion perceived from the end of perceived path','FontSize',20);
    axis([-10 400 -10 100]);
    xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
    ylabel('proportion from perceived endpoint','FontSize',20);

    % %     legend(sbjnames,'Location','northeast')
ax = gca;
ax.FontSize = 20;
hold on;


%     hold on;
%     plot(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,'r','LineWidth',3);
%     % plot(meanReactionTime);

%     proporPerc_ste = ste(proporPerc,1);
%     % bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
%     errorbar(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,proporPerc_ste*100,'r.');
%     axis([-10 400 -10 100]);

%     legend(sbjnames);
%     title(sbjnames,'FontSize',40);
cd '../../../../analysis/flash_lineAdjust'




