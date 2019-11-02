% show perceived location, gabor trajactory and line adjustable
% experiment result in the same figure

clear all;
clear all;
addpath '../../function';

% eachPercLoc = input('>>>> show each perceived location? (e.g.: n or y):  ','s');
eachPercLoc = 'y';
% showwardmark = input('>>>> show rightward leftward or both? (e.g.: r or l or b):  ','s');
showwardmark = 'b';
% decide analysis which distance
mark = 1;
% 'newhuijiahan','guyang','huangjing','linweiru','lucy','qinxiwen','shariff','sunpu','zhaoyitong','zhengnan'
sbjnames = {'huangjing'};  % 'huijiahan','lucy','hehuixia','guofanhua','linweiru' huijiahan-2019-4-22-9-59
% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/percLocaTest/added_gabor_location'
elseif mark == 2
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP/added_gabor_cue_location'
elseif mark == 3
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
elseif mark == 4
    cd '../../data/GaborDrift/flash_lineAdjust/onewhiteflash_lineAdjust_1000ms'
end

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    %     intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    gaborDistanceFromFixationDegree = [10];
    
    if mark == 1 || mark == 2 || mark == 4
        dotXpos_L_Mat = [];
        dotYpos_L_Mat = [];
        dotXpos_R_Mat = [];
        dotYpos_R_Mat = [];
        [dotXpos_L_Mat_Phy,dotXpos_L_Mat_Mid,dotXpos_L_Mat_Perc] = deal([]);
        [dotYpos_L_Mat_Phy,dotYpos_L_Mat_Mid,dotYpos_L_Mat_Perc] = deal([]);
        [dotXpos_R_Mat_Phy,dotXpos_R_Mat_Mid,dotXpos_R_Mat_Perc] = deal([]);
        [dotYpos_R_Mat_Phy,dotYpos_R_Mat_Mid,dotYpos_R_Mat_Perc] = deal([]);
        
        %----------------------------------------------------------------------
        %             plot perceived location for each trial
        %----------------------------------------------------------------------
        for i = 1 : length(RespMat)
            switch RespMat(i,3)
                % left 1   right 0
                % record the apparent motion from real path
                case 'upperRight_leftward'
                    dotXpos_L_now =  str2double(RespMat(i,6));
                    dotYpos_L_now =  str2double(RespMat(i,7));
                    if eachPercLoc == 'y'
                        plot(dotXpos_L_now,dotYpos_L_now,'ro','MarkerSize', 5);
                    end
                    hold on;
                    dotXpos_L_Mat = [dotXpos_L_Mat;dotXpos_L_now];
                    dotYpos_L_Mat = [dotYpos_L_Mat;dotYpos_L_now];
                case 'upperRight_rightward'
                    dotXpos_R_now =  str2double(RespMat(i,6));
                    dotYpos_R_now =  str2double(RespMat(i,7));
                    if eachPercLoc == 'y'
                        plot(dotXpos_R_now,dotYpos_R_now,'bo','MarkerSize', 5);
                    end
                    
                    dotXpos_R_Mat = [dotXpos_R_Mat;dotXpos_R_now];
                    dotYpos_R_Mat = [dotYpos_R_Mat;dotYpos_R_now];
                    hold on;
            end
            
        end
    end
    %----------------------------------------------------------------------
    %             plot centerd  perceived location
    %----------------------------------------------------------------------
    
    %     plot centroid of each perceived location
    if showwardmark == 'l'
        %         percLoca = percLoca_L;
        dotXpos_Mat = dotXpos_L_Mat;
        dotYpos_Mat = dotYpos_L_Mat;
        dotcolor = 'ro';
        facecolor =  'r';
    elseif showwardmark == 'r'
        %         percLoca = percLoca_R;
        dotXpos_Mat = dotXpos_R_Mat;
        dotYpos_Mat = dotYpos_R_Mat;
        dotcolor = 'bo';
        facecolor =  'b';
    end
    hold on;
    if  showwardmark == 'l'
        percLoca_L = plot(mean(dotXpos_L_Mat),mean(dotYpos_L_Mat),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
    elseif showwardmark == 'r'
        percLoca_R = plot(mean(dotXpos_R_Mat),mean(dotYpos_R_Mat),'bo', 'MarkerFaceColor','b','MarkerSize', 10);
    elseif showwardmark == 'b'
        percLoca_L = plot(mean(dotXpos_L_Mat),mean(dotYpos_L_Mat),'ro', 'MarkerFaceColor','r','MarkerSize', 15);
        percLoca_R = plot(mean(dotXpos_R_Mat),mean(dotYpos_R_Mat),'bo', 'MarkerFaceColor','b','MarkerSize', 15);
    end
    % percLoca_R_Phy = plot(mean(dotXpos_R_Mat_Phy),mean(dotYpos_R_Mat_Phy),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
    % percLoca_R_Mid = plot(mean(dotXpos_R_Mat_Mid),mean(dotYpos_R_Mat_Mid),'go', 'MarkerFaceColor','g','MarkerSize', 10);
    % percLoca_R_Perc = plot(mean(dotXpos_R_Mat_Perc),mean(dotYpos_R_Mat_Perc),'mo', 'MarkerFaceColor','m','MarkerSize', 10);
    
end

%----------------------------------------------------------------------
%             plot gabor trajactory
%----------------------------------------------------------------------
%
% gaborStartLocation_L = gaborLoc.Start_L;
% gaborEndLocation_L = gaborLoc.End_L;
% gaborStartLocation_R = gaborLoc.Start_R;
% gaborEndLocation_R = gaborLoc.End_R;

% [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborStartLocation_L);
% [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborEndLocation_L);
% [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborStartLocation_R);
% [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborEndLocation_R);

[gaborLoc] = gaborLocCal(gabor,xCenter,yCenter,gaborDistanceFromFixationPixel,viewingDistance,screenXpixels,displaywidth,framerate,meanSubIlluDegree);

% [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborLoc.Start_L);
% [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborLoc.Start_R);
% [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborLoc.End_L);
% [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborLoc.End_R);
% [dotXpos_L_cue,dotYpos_L_cue] = findcenter(gaborLoc.Cue_L);
% [dotXpos_R_cue,dotYpos_R_cue] = findcenter(gaborLoc.Cue_R);


originX_L = [gaborLoc.Start_L_x,gaborLoc.Start_L_y];
originY_L = [gaborLoc.End_L_x,gaborLoc.End_L_y];
originX_R = [gaborLoc.Start_R_x,gaborLoc.Start_R_y];
originY_R = [gaborLoc.End_R_x,gaborLoc.End_R_y];




% plot the gabor trajactory
if showwardmark == 'l'
    gaborTraj_L = plot(originX_L,originY_L,'-o','color','r');
elseif showwardmark == 'r'
    gaborTraj_R = plot(originX_R,originY_R,'-o','color','b');
elseif showwardmark == 'b'
    gaborTraj_L = plot(originX_L,originY_L,'-o','color','r');
    hold on;
    gaborTraj_R = plot(originX_R,originY_R,'-o','color','b');
end


%----------------------------------------------------------------------
%         plot the cue location
%----------------------------------------------------------------------

cue_L = plot(gaborLoc.Cue_L_x,gaborLoc.Cue_L_y,'-o','color','y');
cue_R = plot(gaborLoc.Cue_R_x,gaborLoc.Cue_R_y,'-o','color','k');

%----------------------------------------------------------------------
%         turn line angle to position and plot mean result
%----------------------------------------------------------------------

% rightward    leftward
if mark == 2  || mark == 3 || mark == 4
    lineLengthDegree = 3.5;
    lineLengthPixel = deg2pix(lineLengthDegree,viewingDistance,screenXpixels,displaywidth);
    [LineAngle_ave] = RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
    [dotXpos_R_delay,dotYpos_R_end] = LineAngle2Posi(LineAngle_ave(:,1),dotXpos_R_st,dotYpos_R_end,lineLengthPixel);
    [dotXpos_L_delay,dotYpos_L_end] = LineAngle2Posi(LineAngle_ave(:,2),dotXpos_L_st,dotYpos_L_end,lineLengthPixel);
    
    
    % change line angle to position location x,y
    % from darker to lighter = delay 0 to 350
    if showwardmark == 'r'
        colorMap = mycolorMap(sum(LineAngle_ave(:,1)~=0),1);
        graph(1) = scatter(dotXpos_R_delay,dotYpos_R_end,60,colorMap,'filled');
    elseif showwardmark =='l'
        colorMap = mycolorMap(sum(LineAngle_ave(:,1)~=0),3);
        graph(2) = scatter(dotXpos_L_delay,dotYpos_L_end,60,colorMap,'filled');
        %         legend;
        %         legend('0s','250ms');
    elseif showwardmark == 'b'
        %         delay = 1:8;
        % from dark to light   1 red
        % colorMap  1  dark     5 light
        colorMap = mycolorMap(sum(LineAngle_ave(:,1)~=0),1); % sum(LineAngle_ave(:,1)~=0)
        graph(1) = scatter(dotXpos_R_delay,dotYpos_R_end,60,colorMap,'filled');
        % 3 grey
        colorMap = mycolorMap(sum(LineAngle_ave(:,1)~=0),3); % sum(LineAngle_ave(:,1)~=0)
        graph(2) = scatter(dotXpos_L_delay,dotYpos_L_end,60,colorMap,'filled');
    end
    
    
    % xlabel('location of x axis on the screen','fontSize',30);
    % ylabel('location of y axis on the screen','fontSize',30);
    % axis([0 600 0 400]);
    % h = [percLoca_L;percLoca_R;gaborTraj_L;gaborTraj_R;graph(1);graph(2)];
    % legend(h,'perceived location(motion leftward)','perceived location(motion rightward)','gabor trajactory(motion leftward)','gabor trajactory(motion rightward)','Location','northeast');
    % [lgd, icons, plots, txt] = legend('show');
    %
    % ax = gca;
    % ax.FontSize = 20;
end

% legend(graph(2),'0s', '250ms', '500ms', '750ms', '1s');
% set(gca,'box','off');
% axis equal;
set(gca,'Visible','off');
% set(gca,'XColor','none','YColor','none')
set(gca,'XTick',[], 'YTick', []);
set(gcf,'color','w');
% set the origin on the left top
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
% if mark == 4;
% saveas(figure(1),[pwd '/lucy.bmp']);
% end
