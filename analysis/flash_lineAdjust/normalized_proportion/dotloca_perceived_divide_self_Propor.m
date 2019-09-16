% ----------------------------------------------------------------------
%  test 1 cd '../../data/GaborDrift/flash_lineAdjust/onewhiteflash_lineAdjust'
% ----------------------------------------------------------------------
% perceived location : percLocaTest
% calculated location: white dot time delay location test
% ----------------------------------------------------------------------
%  test 2 cd '../main_AP/added_gabor_location'
% ----------------------------------------------------------------------
% perceived location : percLocaTest
% calculated location: main_AP  for apparent motion test

% analysis subject's perception from the end of the perceived or from the
% end of physical




clear all;
clear all;
addpath '../../../function';
% decide analysis which distance

eachPercLoc = 'n';

% ,'guyang','linweiru','lucy','qinxiwen','newhuijiahan'
sbjnames = {'newhuijiahan'}; 
% for using white dot to test the endpoint of illusion
cd '../../../data/GaborDrift/flash_lineAdjust/percLocaTest/added_gabor_location'


% show the physical path to check the result
physical_path_mark = 'n';

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    if sbjnum > 1
        cd '../../percLocaTest/added_gabor_location'
    end
    Files = dir([s3]);
    load (Files.name);
    %     gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    
    %     intervalTimesMatSingle = [0 0.25 0.5 0.75 1];
    gaborDistanceFromFixationDegree = [10];
    
    %----------------------------------------------------------------------
    %             plot perceived location for each trial
    %----------------------------------------------------------------------
    dotXpos_L_Mat = [];
    dotYpos_L_Mat = [];
    dotXpos_R_Mat = [];
    dotYpos_R_Mat = [];
    
    for i = 1 : length(RespMat)
        switch RespMat(i,3)
            % left 1   right 0
            % record the apparent motion from real path
            case 'upperRight_leftward'
                dotXpos_L_now =  str2double(RespMat(i,6));
                dotYpos_L_now =  str2double(RespMat(i,7));
                if eachPercLoc == 'y'
                    plot(dotXpos_L_now,dotYpos_L_now,'ro');
                end
                hold on;
                dotXpos_L_Mat = [dotXpos_L_Mat;dotXpos_L_now];
                dotYpos_L_Mat = [dotYpos_L_Mat;dotYpos_L_now];
            case 'upperRight_rightward'
                dotXpos_R_now =  str2double(RespMat(i,6));
                dotYpos_R_now =  str2double(RespMat(i,7));
                if eachPercLoc == 'y'
                    plot(dotXpos_R_now,dotYpos_R_now,'bo');
                end
                dotXpos_R_Mat = [dotXpos_R_Mat;dotXpos_R_now];
                dotYpos_R_Mat = [dotYpos_R_Mat;dotYpos_R_now];
                hold on;
        end
        
    end
    
    %%%------------------------------------------------------------------
    %    average location for all trials
    %%%------------------------------------------------------------------
    
    dotXpos_L_ave(sbjnum) = mean(dotXpos_L_Mat);
    dotYpos_L_ave(sbjnum) = mean(dotYpos_L_Mat);
    dotXpos_R_ave(sbjnum) = mean(dotXpos_R_Mat);
    dotYpos_R_ave(sbjnum) = mean(dotYpos_R_Mat);
    
    if physical_path_mark == 'y'
        %----------------------------------------------------------------------
        %             plot gabor trajactory
        %----------------------------------------------------------------------
        %
        gaborStartLocation_L = gaborLoc.Start_L;
        gaborEndLocation_L = gaborLoc.End_L;
        gaborStartLocation_R = gaborLoc.Start_R;
        gaborEndLocation_R = gaborLoc.End_R;
        
        [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborStartLocation_L);
        [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborEndLocation_L);
        [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborStartLocation_R);
        [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborEndLocation_R);
        
        
        
        originX_L = [dotXpos_L_st,dotXpos_L_end];
        originY_L = [dotYpos_L_st,dotYpos_L_end];
        originX_R = [dotXpos_R_st,dotXpos_R_end];
        originY_R = [dotYpos_R_st,dotYpos_R_end];
        
        % plot the gabor trajactory
        
        gaborTraj_L = plot(originX_L,originY_L,'-o','color','r');
        hold on;
        gaborTraj_R = plot(originX_R,originY_R,'-o','color','b');
        
    end
    
    
    
    %%%------------------------------------------------------------------
    %     load the time delay document to calculate the cue location
    %%%------------------------------------------------------------------
    
    
    cd '../../../../../analysis/flash_lineAdjust'
%       cd '../../data/GaborDrift/flash_lineAdjust/main_AP/added_gabor_location'
    cd '../../data/GaborDrift/flash_lineAdjust/onewhiteflash_lineAdjust_1000ms'
    
    Files = dir([s3]);
    load (Files.name);
    
    
    %     intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];
    %     gaborLoc.Cue_L = gaborCueLoca_L;
    %     gaborLoc.Cue_R = gaborCueLoca_R;
    
    [gaborLoc] = gaborLocCal(gabor,xCenter,yCenter,gaborDistanceFromFixationPixel,viewingDistance,screenXpixels,displaywidth,framerate);
    
    
    [dotXpos_L_cue(sbjnum),dotYpos_L_cue(sbjnum)] = findcenter(gaborLoc.Cue_L);
    [dotXpos_R_cue(sbjnum),dotYpos_R_cue(sbjnum)] = findcenter(gaborLoc.Cue_R);
    
    if physical_path_mark == 'y'
        %----------------------------------------------------------------------
        %             plot cue location
        %----------------------------------------------------------------------
        plot(dotXpos_L_cue(sbjnum),dotYpos_L_cue(sbjnum),'mo', 'MarkerFaceColor','m','MarkerSize', 10);
        plot(dotXpos_R_cue(sbjnum),dotYpos_R_cue(sbjnum),'go', 'MarkerFaceColor','g','MarkerSize', 10);
        set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
        %----------------------------------------------------------------------
        %             plot perceived location
        %----------------------------------------------------------------------
        
        plot(dotXpos_L_ave(sbjnum),dotYpos_L_ave(sbjnum),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
        plot(dotXpos_R_ave(sbjnum),dotYpos_R_ave(sbjnum),'bo', 'MarkerFaceColor','b','MarkerSize', 10);
    end
    %----------------------------------------------------------------------
    %             calculate perceived angle
    %----------------------------------------------------------------------
    
    illuSize_L(sbjnum) = atan((dotXpos_L_ave(sbjnum) - dotXpos_L_cue(sbjnum))/(dotYpos_L_ave(sbjnum) - dotYpos_L_cue(sbjnum)));
    illuSize_R(sbjnum) = atan((dotXpos_R_ave(sbjnum) - dotXpos_R_cue(sbjnum))/(dotYpos_R_ave(sbjnum) - dotYpos_R_cue(sbjnum)));
    
    PercIlluDegree(sbjnum,:) = [illuSize_R(sbjnum),illuSize_L(sbjnum)];
    
    
    
    %%%--------------------------------------------------
    %     plot the perceived proportion
    %%%--------------------------------------------------
    % angle devide the physical angle is the proportion of perceived
    % 0 is from physical endpoint  1 is from perceived endpoint
    % meanSubIlluDegree (rightward  leftward
    Perc_prop_temp_L = [];
    Perc_prop_temp_R = [];
    
    [LineAngle_ave,LineDegree10dva_right_ave,LineDegree10dva_left_ave] = RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,...
        gaborDistanceFromFixationDegree);
    
    
    % porportion: perceived angle(time delay)from physical endpoint devide perceived endpoint angle
    for delay = 1: length(intervalTimesMatSingle)
        Perc_prop_temp_L(delay) = (ang2radi(1/2*meanSubIlluDegree(2)) - LineDegree10dva_left_ave(delay))/(ang2radi(1/2 * meanSubIlluDegree(2)) - PercIlluDegree(sbjnum,2));
    end
    
    for delay = 1: length(intervalTimesMatSingle)
        Perc_prop_temp_R(delay) = (ang2radi(1/2*meanSubIlluDegree(1)) + LineDegree10dva_right_ave(delay))/(ang2radi(1/2 * meanSubIlluDegree(1)) + PercIlluDegree(sbjnum,1));
    end
    
    %%%--------------------------------------------------
    %     plot each subject's perceived proportion
    %%%--------------------------------------------------
    %         plot(intervalTimesMatSingle*1000,Perc_prop_temp_L*100);
    %         hold on;
    %         plot(intervalTimesMatSingle*1000,Perc_prop_temp_R*100); % ,'-o','color','b'
    
    Perc_prop_L(sbjnum,:) = Perc_prop_temp_L;
    Perc_prop_norm_L = mean(Perc_prop_L,1);
    Perc_prop_R(sbjnum,:) = Perc_prop_temp_R;
    Perc_prop_norm_R = mean(Perc_prop_R,1);
    Perc_prop(sbjnum,:) = (Perc_prop_temp_L + Perc_prop_temp_R)/2;
    Perc_prop_norm = mean(Perc_prop,1);
    
end


% plot(intervalTimesMatSingle*1000,(Perc_prop_L' * 100),'-o');
% plot(intervalTimesMatSingle*1000,(Perc_prop_R' * 100),'-o');

if physical_path_mark == 'n'
    %%%--------------------------------------------------
    %     plot the result of leftward
    %%%--------------------------------------------------
    %
    %     plot(intervalTimesMatSingle*1000,(Perc_prop_norm_L * 100),'-o','color','r');
    %     Perc_prop_ste_L = ste(Perc_prop_L*100,1);
    %     hold on;
    %     errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm_L * 100),Perc_prop_ste_L,'color','r');
    %     %%%--------------------------------------------------
    %     %     plot the result of leftward
    %     %%%--------------------------------------------------
    %     plot(intervalTimesMatSingle*1000,(Perc_prop_norm_R * 100),'-o','color','b');
    %     Perc_prop_ste_R = ste(Perc_prop_R*100,1);
    %     hold on;
    %     errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm_R * 100),Perc_prop_ste_R,'color','b');
    %%%--------------------------------------------------
    %     plot the result of all
    %%%--------------------------------------------------
%     plot(intervalTimesMatSingle*1000,(Perc_prop_norm),'-o','color','g');
    bar(intervalTimesMatSingle*1000,(Perc_prop_norm),'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
    Perc_prop_ste = ste(Perc_prop,1);
    hold on;
    errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm),Perc_prop_ste,'color',[0 .9 .9],'LineWidth',1.5,'LineStyle','none');
    %     name = {'0','50','100','150','200','250','300','350'};
    %     set(gca,'xticklabel',name);
    %     set(gca, 'XTick', 1:length(name),'XTickLabel',name);
    yline(1,'-.k');
    % [p,tbl,stats] = anova1(Perc_prop_L);
    
end


% title('proportion of apparent motion perceived from the end of perceived path','FontSize',15);
% axis([-30 400 0 2]);
xlabel('probe delay(ms)');%,'fontSize',40);
% ylabel('proportion from perceived endpoint');%,'FontSize',40);
set(gca,'FontSize',35);
% xticks([0 250 500 750 1000]);
% yticklabels({'0 from physical','1 from perceived'});
% xticklabels({'x = 0','x = 5','x = 10'})
% legend('internal motion leftward','internal motion rightward','location','best')
% %     legend(sbjnames,'Location','northeast')
% ax = gca;
% ax.FontSize = 20;
set(gcf,'color','w');
set(gca,'box','off');
%     title(sbjnames,'FontSize',40);
% cd '../../../../analysis/flash_lineAdjust'
% saveas(figure(1),[pwd '/avdrage.png']);