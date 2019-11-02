% ----------------------------------------------------------------------
%  show the data with physical location of gabor trajactory, cue and
%  perceived location
%  represent the perceived location by tested perceived location divide the
%  supposed distance between physical and perceived location
%  % = tested perceived distance from the physical endpoint/ distance
%  between physical and supposed perceived endpoint
% ----------------------------------------------------------------------

clear all;
clear all;
addpath '../../function';

% whether peresent each location of subject reports
eachPercLoc = 'n';
% perc_loc = input('>>>> plot perceived location? (e.g.: y or n):  ','s');
perc_loc = 'n';
% 'newhuijiahan','guyang','huangjing','linweiru','lucy','qinxiwen','shariff','sunpu','zhaoyitong','zhengnan','zhoudaiyang'
sbjnames = {'newhuijiahan','guyang','huangjing','linweiru','lucy','qinxiwen','sunpu','zhaoyitong','zhengnan','zhoudaiyang'};
% for using white dot to test the endpoint of illusion
cd '../../data/GaborDrift/flash_lineAdjust/percLocaTest/added_gabor_location'
% cd '../../../data/GaborDrift/flash_lineAdjust/main_AP/added_gabor_location'



for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    
    Files = dir([s3]);
    load (Files.name);
    
    %----------------------------------------------------------------------
    %             calculate gaborLoc - rightward
    %----------------------------------------------------------------------
    
%         [gaborLoc] = gaborLocCal(gabor,xCenter,yCenter,gaborDistanceFromFixationPixel,viewingDistance,screenXpixels,displaywidth,framerate,meanSubIlluDegree);
    
    [gaborLoc] = gaborLocMath(meanSubIlluDegree,viewingDistance,screenXpixels,displaywidth,gaborLoc);
    %----------------------------------------------------------------------
    %             plot gabor trajactory
    %----------------------------------------------------------------------
    
%         [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborLoc.Start_L);
%         [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborLoc.Start_R);
%         [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborLoc.End_L);
%         [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborLoc.End_R);
%         [dotXpos_L_cue,dotYpos_L_cue] = findcenter(gaborLoc.Cue_L);
%         [dotXpos_R_cue,dotYpos_R_cue] = findcenter(gaborLoc.Cue_R);
    
    originX_L = [gaborLoc.Start_L_x,gaborLoc.End_L_x];
    originY_L = [gaborLoc.Start_L_y,gaborLoc.End_L_y];
    originX_R = [gaborLoc.Start_R_x,gaborLoc.End_R_x];
    originY_R = [gaborLoc.Start_R_y,gaborLoc.End_R_y];
    
%         originX_L = [dotXpos_L_st,dotXpos_L_end];
%         originY_L = [dotYpos_L_st,dotYpos_L_end];
%         originX_R = [dotXpos_R_st,dotXpos_R_end];
%         originY_R = [dotYpos_R_st,dotYpos_R_end];
    
    if perc_loc == 'y'
        gaborTraj_L = plot(originX_L,originY_L,'-o','color','r');
        hold on;
        gaborTraj_R = plot(originX_R,originY_R,'-o','color','b');
        
        %     if perc_loc == 'y'
        %----------------------------------------------------------------------
        %             plot cue location
        %----------------------------------------------------------------------
        cue_L = plot(dotXpos_L_cue,dotYpos_L_cue,'mo', 'MarkerFaceColor','m','MarkerSize', 10);
        cue_R = plot(dotXpos_R_cue,dotYpos_R_cue,'go', 'MarkerFaceColor','g','MarkerSize', 10);
        set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
        
    end
    
    %----------------------------------------------------------------------
    %             plot perceived location for each trial
    %----------------------------------------------------------------------
    
    cd '../../percLocaTest/added_gabor_location'
    if sbjnum > 1
        cd '../../percLocaTest/added_gabor_location'
    end
    
    Files = dir([s3]);
    load (Files.name);
    
    [dotXpos_L_Mat,dotYpos_L_Mat,dotXpos_R_Mat,dotYpos_R_Mat] = deal([]);
    
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
    
    
    %----------------------------------------------------------------------
    %             plot perceived location
    %----------------------------------------------------------------------
    if perc_loc == 'y'
        plot(dotXpos_L_ave(sbjnum),dotYpos_L_ave(sbjnum),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
        plot(dotXpos_R_ave(sbjnum),dotYpos_R_ave(sbjnum),'bo', 'MarkerFaceColor','b','MarkerSize', 10);
    end
    % end
    
    
    
    
    %----------------------------------------------------------------------
    %             percentage of tested perceived location
    %----------------------------------------------------------------------
    
    
%         real_perceiv_dist_L(sbjnum) = abs(dotXpos_L_ave(sbjnum) - dotXpos_L_end);
%         real_perceiv_dist_R(sbjnum) = abs(dotXpos_R_ave(sbjnum) - dotXpos_R_end);
%         full_dist_L(sbjnum) = abs(dotXpos_L_st - dotXpos_L_end) * 2;
%         full_dist_R(sbjnum) = abs(dotXpos_R_st - dotXpos_R_end) * 2;
%         perc_of_perceiv_L(sbjnum) = real_perceiv_dist_L(sbjnum)/full_dist_L(sbjnum);
%         perc_of_perceiv_R(sbjnum) = real_perceiv_dist_R(sbjnum)/full_dist_R(sbjnum);
%         ave_perc(sbjnum) = (perc_of_perceiv_L(sbjnum) + perc_of_perceiv_R(sbjnum))/2;
    
    [gaborLoc] = gaborLocMath(meanSubIlluDegree,viewingDistance,screenXpixels,displaywidth,gaborLoc);
    
    real_perceiv_dist_L(sbjnum) = abs(dotXpos_L_ave(sbjnum) - gaborLoc.End_L_x);
    real_perceiv_dist_R(sbjnum) = abs(dotXpos_R_ave(sbjnum) - gaborLoc.End_R_x);
    full_dist_L(sbjnum) = abs(gaborLoc.Start_L_x - gaborLoc.End_L_x) * 2;
    full_dist_R(sbjnum) = abs(gaborLoc.Start_R_x - gaborLoc.End_R_x) * 2;
    perc_of_perceiv_L(sbjnum) = real_perceiv_dist_L(sbjnum)/full_dist_L(sbjnum);
    perc_of_perceiv_R(sbjnum) = real_perceiv_dist_R(sbjnum)/full_dist_R(sbjnum);
    ave_perc(sbjnum) = (perc_of_perceiv_L(sbjnum) + perc_of_perceiv_R(sbjnum))/2;
    
    
    
    
    
end


perc = mean(ave_perc,2)

bar(1:sbjnum,ave_perc,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
ave_perc_ste = ste(ave_perc,1);
hold on;
errorbar(1:sbjnum,ave_perc,ave_perc_ste,'color',[0 .9 .9],'LineWidth',1.5,'LineStyle','none');

% title('the effective perceived endpoint is plotted as a proportion of distance to the perceived endpoint','FontSize',15);
axis([0 12 0 1]);
xticks([1:sbjnum]);
yline(perc,'-.k');
yticks([0 0.5 1]);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',30)
xlabel('Participant','fontSize',40);
% ylabel('proportion from supposed perceived endpoint');%,'FontSize',40);
% set(gca,'FontSize',35);

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