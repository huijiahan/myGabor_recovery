% show perceived location test , gabor trajactory and line adjustable
% experiment result in the same figure

clear all;
clear all;
addpath '../../function';

% eachPercLoc = input('>>>> show each perceived location? (e.g.: n or y):  ','s');
eachPercLoc = 'n';


% decide analysis which distance
mark = 3;
sbjnames = {'huijiahan','hehuixia','guofanhua','linweiru'};  % 'huijiahan','lucy','hehuixia','guofanhua','linweiru'
% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/percLocaTest'
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
    intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    gaborDistanceFromFixationDegree = [10];
    
    if mark == 1
        [angle_R_all(:,sbjnum),angle_L_all(:,sbjnum)] = RespMat2LineAngle_ave_forBaseline(RespMat,gaborStartLocation_L,...
            gaborEndLocation_L,gaborStartLocation_R,gaborEndLocation_R,gaborCueLoca_L,gaborCueLoca_R);
        
        % physical endpoint
        [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborStartLocation_L);
        [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborEndLocation_L);
        [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborStartLocation_R);
        [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborEndLocation_R);
        [cueXpos_L,cueYpos_L] = findcenter(gaborCueLoca_L);
        [cueXpos_R,cueYpos_R] = findcenter(gaborCueLoca_R);
        
        %         cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
        %         cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);
        
        cueVerDisPix = dotYpos_L_end - cueYpos_L;
        
        opposite_phy_L = (dotXpos_L_end - dotXpos_L_st);
        adjacent_phy_L = cueVerDisPix;
        phyAngle_L(sbjnum) = atan(opposite_phy_L/adjacent_phy_L);
        
        opposite_phy_R = (dotXpos_R_st - dotXpos_R_end);
        adjacent_phy_R = cueVerDisPix;
        phyAngle_R(sbjnum) = - atan(opposite_phy_R/adjacent_phy_R);
             
        
    elseif mark == 2||3 % load main_AP folder
        [LineAngle_ave(:,:,sbjnum),LineDegree10dva_right_ave(:,sbjnum),LineDegree10dva_left_ave(:,sbjnum)]...
            = RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
    end
    
    if eachPercLoc == 'y'
        if mark == 1
            angle_R_all_ave = mean(angle_R_all);
            angle_L_all_ave = mean(angle_L_all);
            % load PercLocaTest folder
            % plot the angle where subject perceive the endpoint of illusion
%             yline(mean(angle_R_all_ave));
            hold on;
            yline(mean(angle_L_all_ave));
        elseif mark == 2||3
            ave_subLineAngle_R = mean(LineDegree10dva_right_ave,2);
            ave_subLineAngle_L = mean(LineDegree10dva_left_ave,2);
            
%             plot(intervalTimesMatSingle*1000,ave_subLineAngle_R);
            hold on;
            plot(intervalTimesMatSingle*1000,ave_subLineAngle_L);
            
        end
    end
end

% perceived endpoint
if mark == 1
    angle_R_all_ave = mean(angle_R_all);
    angle_L_all_ave = mean(angle_L_all);
    % load PercLocaTest folder
    % plot the angle where subject perceive the endpoint of illusion
%     yline(mean(angle_R_all_ave),'b');
    hold on;
    yline(mean(angle_L_all_ave),'g','lineWidth',1.5);
%     yline(mean(phyAngle_R),'g');
    hold on;
    yline(mean(phyAngle_L),'m','lineWidth',1.5);
    
elseif mark == 2||3
    ave_subLineAngle_R = mean(LineDegree10dva_right_ave,2);
    ave_subLineAngle_L = mean(LineDegree10dva_left_ave,2);
    % r for leftward   blue for rightward  green for rightward control  m
    % for leftward control
%     plot(intervalTimesMatSingle*1000,ave_subLineAngle_R,'-o','color','b','lineWidth',2);
    hold on;
    ave_subLineAngle_R_ste = ste(LineDegree10dva_right_ave,2);
%     errorbar(intervalTimesMatSingle*1000,ave_subLineAngle_R,ave_subLineAngle_R_ste,'b.');
    

%     ave_subLineAngleDegree_L = radi2ang(ave_subLineAngle_L);
    plot(intervalTimesMatSingle*1000,ave_subLineAngle_L,'-o','color','b','lineWidth',2);
    ave_subLineAngle_L_ste = ste(LineDegree10dva_left_ave,2);
    errorbar(intervalTimesMatSingle*1000,ave_subLineAngle_L,ave_subLineAngle_L_ste,'b.');
    
    
    xlabel('time delays','fontSize',30);
    ylabel('perceived angle of apparent motion','fontSize',30);
    
    
    
    
end
set(gca,'box','off');
set(gcf,'color','w');
axis([-20 370 -0.4 0.4]);

% h = [percLoca_L;percLoca_R;gaborTraj_L;gaborTraj_R;graph(1);graph(2)];
% legend(h,'perceived location(motion leftward)','perceived location(motion rightward)','gabor trajactory(motion leftward)','gabor trajactory(motion rightward)','Location','northeast');
% [lgd, icons, plots, txt] = legend('show');
%
% ax = gca;
% ax.FontSize = 20;

% set(gca,'XColor','none','YColor','none')