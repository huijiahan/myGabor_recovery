% show perceived location, gabor trajactory and line adjustable
% experiment result in the same figure
% flip the perceived location over the physical trajactory


clear all;
clear all;
addpath '../../../function';

% eachPercLoc = input('>>>> show each perceived location? (e.g.: n or y):  ','s');
eachPercLoc = 'y';
% showwardmark = input('>>>> show rightward leftward or both? (e.g.: r or l or b):  ','s');
showwardmark = 'b';
% decide analysis which distance
mark = 1;
sbjnames = {'newhuijiahan'};  % 'huijiahan','lucy','hehuixia','guofanhua','linweiru' huijiahan-2019-4-22-9-59
% for test flash apparent motion line adjust
if mark == 1
    cd '../../../data/GaborDrift/flash_lineAdjust/percLocaTest/added_gabor_location'
elseif mark == 2
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP'
elseif mark == 3
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
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
                    % seprate result with different flash location
                    % 1 physical  2 mid  3 perceived location
                    %                     if str2double(RespMat(i,9)) == 1
                    %                         plot(dotXpos_L_now,dotYpos_L_now,'ro');
                    %                         dotXpos_L_Mat_Phy = [dotXpos_L_Mat_Phy;dotXpos_L_now];
                    %                         dotYpos_L_Mat_Phy = [dotYpos_L_Mat_Phy;dotYpos_L_now];
                    %                     elseif str2double(RespMat(i,9)) == 2
                    %                         plot(dotXpos_L_now,dotYpos_L_now,'go');
                    %                         dotXpos_L_Mat_Mid = [dotXpos_L_Mat_Mid;dotXpos_L_now];
                    %                         dotYpos_L_Mat_Mid = [dotYpos_L_Mat_Mid;dotYpos_L_now];
                    %                     elseif str2double(RespMat(i,9)) == 3
                    %                         plot(dotXpos_L_now,dotYpos_L_now,'bo');
                    %                         dotXpos_L_Mat_Perc = [dotXpos_L_Mat_Perc;dotXpos_L_now];
                    %                         dotYpos_L_Mat_Perc = [dotYpos_L_Mat_Perc;dotYpos_L_now];
                    %                     end
                    %                     plot(dotXpos_L_now,dotYpos_L_now,'ro');
                end
                hold on;
                dotXpos_L_Mat = [dotXpos_L_Mat;dotXpos_L_now];
                dotYpos_L_Mat = [dotYpos_L_Mat;dotYpos_L_now];
            case 'upperRight_rightward'
                dotXpos_R_now =  str2double(RespMat(i,6));
                dotYpos_R_now =  str2double(RespMat(i,7));
                if eachPercLoc == 'y'
                    %     plot(dotXpos_R_now,dotYpos_R_now,'bo');
                    % 1 physical  2 mid  3 perceived location
                    %                     if str2double(RespMat(i,9)) == 1
                    %                         plot(dotXpos_R_now,dotYpos_R_now,'ro');
                    %                         dotXpos_R_Mat_Phy = [dotXpos_R_Mat_Phy;dotXpos_R_now];
                    %                         dotYpos_R_Mat_Phy = [dotYpos_R_Mat_Phy;dotYpos_R_now];
                    %                     elseif str2double(RespMat(i,9)) == 2
                    %                         plot(dotXpos_R_now,dotYpos_R_now,'go');
                    %                         dotXpos_R_Mat_Mid = [dotXpos_R_Mat_Mid;dotXpos_R_now];
                    %                         dotYpos_R_Mat_Mid = [dotYpos_R_Mat_Mid;dotYpos_R_now];
                    %                     elseif str2double(RespMat(i,9)) == 3
                    %                         plot(dotXpos_R_now,dotYpos_R_now,'mo');
                    %                         dotXpos_R_Mat_Perc = [dotXpos_R_Mat_Perc;dotXpos_R_now];
                    %                         dotYpos_R_Mat_Perc = [dotYpos_R_Mat_Perc;dotYpos_R_now];
                    %                     end
                    %                 plot(dotXpos_R_now,dotYpos_R_now,'bo');
                end
                
                dotXpos_R_Mat = [dotXpos_R_Mat;dotXpos_R_now];
                dotYpos_R_Mat = [dotYpos_R_Mat;dotYpos_R_now];
                hold on;
        end
        
    end
    % end
    %----------------------------------------------------------------------
    %             plot centred  perceived location
    %----------------------------------------------------------------------
    
    % plot centroid of each perceived location
    % if showwardmark == 'l'
    %     percLoca = percLoca_L;
    %     dotXpos_Mat = dotXpos_L_Mat;
    %     dotYpos_Mat = dotYpos_L_Mat;
    %     dotcolor = 'ro';
    %     facecolor =  'r';
    % elseif showwardmark == 'r'
    %     percLoca = percLoca_R;
    %     dotXpos_Mat = dotXpos_R_Mat;
    %     dotYpos_Mat = dotYpos_R_Mat;
    %     dotcolor = 'bo';
    %     facecolor =  'b';
    % end
    % hold on;
    
    percLoca_L = plot(mean(dotXpos_L_Mat),mean(dotYpos_L_Mat),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
    
    percLoca_R = plot(mean(dotXpos_R_Mat),mean(dotYpos_R_Mat),'bo', 'MarkerFaceColor','b','MarkerSize', 10);
    % percLoca_R_Phy = plot(mean(dotXpos_R_Mat_Phy),mean(dotYpos_R_Mat_Phy),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
    % percLoca_R_Mid = plot(mean(dotXpos_R_Mat_Mid),mean(dotYpos_R_Mat_Mid),'go', 'MarkerFaceColor','g','MarkerSize', 10);
    % percLoca_R_Perc = plot(mean(dotXpos_R_Mat_Perc),mean(dotYpos_R_Mat_Perc),'mo', 'MarkerFaceColor','m','MarkerSize', 10);
    
end

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
%         rotate leftward trajactory to rightward trajactory
%----------------------------------------------------------------------
% create a matrix of these points, which will be useful in future calculations
origin = [originX_L; originY_L];
% choose a point which will be the center of rotation
x_rotaCenter = (dotXpos_L_st + dotXpos_L_end)/2;
y_rotaCenter = (dotYpos_L_st + dotYpos_L_end)/2;
% meanSubIlluDegree(1)  rightward    2 leftward
theta = -(meanSubIlluDegree(1) + meanSubIlluDegree(2))/2*pi/180;
% rotate leftward trajactory to rightward trajactory
[x_rotated,y_rotated] = rotate_line_about_fix_center(originX_L,originY_L,theta,x_rotaCenter,y_rotaCenter);

% gaborTraj_L = plot(neworiginX_L,newooriginY_L,'-o','color','b');
plot(originX_L,originY_L, 'k-', x_rotated, y_rotated, 'r-', x_rotaCenter, y_rotaCenter, 'bo');

[xdot_rotated,ydot_rotated] = rotate_line_about_fix_center(mean(dotXpos_L_Mat),mean(dotYpos_L_Mat),theta,x_rotaCenter,y_rotaCenter);
plot(xdot_rotated,ydot_rotated,'ko', 'MarkerFaceColor','k','MarkerSize', 10);


% camroll(100);
%----------------------------------------------------------------------
%         turn line angle to position and plot mean result
%----------------------------------------------------------------------

% rightward    leftward
if mark == 2  || mark == 3
    lineLengthDegree = 3.5;
    lineLengthPixel = deg2pix(lineLengthDegree,viewingDistance,screenXpixels,displaywidth);
    [LineAngle_ave] = RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
    [dotXpos_R_delay,dotYpos_R_end] = LineAngle2Posi(LineAngle_ave(:,1),dotXpos_R_st,dotYpos_R_end,lineLengthPixel);
    [dotXpos_L_delay,dotYpos_L_end] = LineAngle2Posi(LineAngle_ave(:,2),dotXpos_L_st,dotYpos_L_end,lineLengthPixel);
    
    
    % change line angle to position location x,y
    % from darker to lighter = delay 0 to 350
    if showwardmark == 'r'
        colorMap = mycolorMap(size(LineAngle_ave,1),5);
        graph(1) = scatter(dotXpos_R_delay,dotYpos_R_end,60,colorMap,'filled');
    elseif showwardmark =='l'
        colorMap = mycolorMap(size(LineAngle_ave,1),1);
        graph(2) = scatter(dotXpos_L_delay,dotYpos_L_end,60,colorMap,'filled');
    elseif showwardmark == 'b'
        colorMap = mycolorMap(size(LineAngle_ave,1),5);
        graph(1) = scatter(dotXpos_R_delay,dotYpos_R_end,60,colorMap,'filled');
        colorMap = mycolorMap(size(LineAngle_ave,1),1);
        graph(2) = scatter(dotXpos_L_delay,dotYpos_L_end,60,colorMap,'filled');
    end
    
    
    % xlabel('location of x axis on the screen','fontSize',30);
    % ylabel('location of y axis on the screen','fontSize',30);
    % axis([0 600 0 400]);
    % h = [percLoca_L;percLoca_R;gaborTraj_L;gaborTraj_R;graph(1);graph(2)];
    % legend(h,'perceived location(motion leftward)','perceived location(motion rightward)',...
    %     'gabor trajactory(motion leftward)','gabor trajactory(motion rightward)','Location','northeast');
    % [lgd, icons, plots, txt] = legend('show');
    %
    % ax = gca;
    % ax.FontSize = 20;
end
%----------------------------------------------------------------------
%         figure propreties
%----------------------------------------------------------------------
set(gca,'Visible','off');
axis equal;
% set(gca,'XColor','none','YColor','none')
set(gca,'XTick',[], 'YTick', []);
set(gcf,'color','w');
% set the origin on the left top
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');