% show perceived location test , gabor trajactory and line adjustable
% experiment result in the same figure

clear all;
clear all;
addpath '../../function';
% decide analysis which distance
mark = 1;

% eachPercLoc = input('>>>> show each perceived location? (e.g.: n or y):  ','s');
eachPercLoc = 'y';
showwardmark = input('>>>> show rightward leftward or both? (e.g.: r or l or b):  ','s');


% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/percLocaTest'
    sbjnames = {'hehuixia'}; % 'huijiahan','lucy','xiahuan','gaoyige'   
elseif mark == 2
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP'
    sbjnames = {'huijiahan'};    
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
    lineAngleColumn = 7;
    
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
end

% plot centroid of each perceived location
if showwardmark == 'l'
    percLoca_L = plot(mean(dotXpos_L_Mat),mean(dotYpos_L_Mat),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
elseif showwardmark == 'r'
    percLoca_R = plot(mean(dotXpos_R_Mat),mean(dotYpos_R_Mat),'bo', 'MarkerFaceColor','b','MarkerSize', 10);
elseif showwardmark == 'b'
    percLoca_L = plot(mean(dotXpos_L_Mat),mean(dotYpos_L_Mat),'ro', 'MarkerFaceColor','r','MarkerSize', 10);
    hold on;
    percLoca_R = plot(mean(dotXpos_R_Mat),mean(dotYpos_R_Mat),'bo', 'MarkerFaceColor','b','MarkerSize', 10);
end


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
% set the origin on the left top
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');



% rightward    leftward
lineLengthDegree = 3.5;
lineLengthPixel = deg2pix(lineLengthDegree,viewingDistance,screenXpixels,displaywidth);
% [LineAngle_ave] = RespMat2LineAngle_ave(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
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
% set(gca,'box','off')
% xlabel('location of x axis on the screen','fontSize',30);
% ylabel('location of y axis on the screen','fontSize',30);
set(gca,'XColor','none','YColor','none')


h = [percLoca_L;percLoca_R;gaborTraj_L;gaborTraj_R;graph(1);graph(2)];
legend(h,'perceived location(motion leftward)','perceived location(motion rightward)','gabor trajactory(motion leftward)','gabor trajactory(motion rightward)','Location','northeast');
% [lgd, icons, plots, txt] = legend('show');
%
% ax = gca;
% ax.FontSize = 20;
