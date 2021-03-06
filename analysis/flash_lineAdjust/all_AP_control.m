% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
clear all;
addpath '../../function';
% decide analysis which distance


Perc_prop_mark = input('>>>> plot each perceived proportion? (e.g.: n or y):  ','s');
Perc_loca_mark = input('>>>> scatter perceived location? (e.g.: n or y):  ','s');

% for test flash apparent motion line adjust
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP'
    % 0.5 dva
    sbjnames = {'guofanhua'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'

   
for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    gaborDistanceFromFixationDegree = [10];

       
    [LineAngle_ave] = RespMat2LineAngle_ave(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
    
    
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
%         if mark == 2
%             graph_R = scatter(dotXpos_R_delay,dotYpos_R_end,'marker','o','MarkerFaceColor','g');
%         end
        hold on;
        [dotXpos_L_delay,dotYpos_L_end] = LineAngle2Posi(LineAngle_ave(:,2),dotXpos_L_st,dotYpos_L_end,lineLengthPixel);
        graph_L = scatter(dotXpos_L_delay,dotYpos_L_end,'ro');%,'color',colorMap,'marker','o','MarkerFaceColor',colorMap);
%         if mark == 2
%             graph_L = scatter(dotXpos_L_delay,dotYpos_L_end,'marker','o','MarkerFaceColor','m');
%         end
    
            title('apparent motion location detect','FontSize',30);
%         elseif mark ==  2
%             title('apparent motion location detect -- control','FontSize',30);
%         end
    end
%     legend(['S' num2str(sbjnum)]);
    legend('S2');
    


cd '../../../../analysis/flash_lineAdjust'
%     cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
%     sbjnames = {'guofanhua'};
%     lineAngleColumn = 7;




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




