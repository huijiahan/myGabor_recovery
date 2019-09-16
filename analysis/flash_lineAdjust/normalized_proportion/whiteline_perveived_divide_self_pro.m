% ----------------------------------------------------------------------
%          test 1 (mark = 4;)  cd '../main_AP/added_gabor_location'
% ----------------------------------------------------------------------
% perceived location : 5 of whitedot test (1s)
% calculated location: main_AP  for apparent motion test



clear all;
clear all;
addpath '../../../function';

% eachPercLoc = input('>>>> show each perceived location? (e.g.: n or y):  ','s');
eachPercLoc = 'y';

% decide analysis which distance
mark = 2;
sbjnames = {'lucy'};  % 'huijiahan','lucy','hehuixia','guofanhua','linweiru' huijiahan-2019-4-22-9-59
% for test flash apparent motion line adjust
if mark == 1
    cd '../../../data/GaborDrift/flash_lineAdjust/percLocaTest/'
elseif mark == 2
    cd '../../../data/GaborDrift/flash_lineAdjust/main_AP/added_gabor_cue_location'
elseif mark == 3
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
elseif mark == 4
    cd '../../../data/GaborDrift/flash_lineAdjust/onewhiteflash_lineAdjust'
end

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    % for second loop go back to original folder
    if sbjnum > 1
        cd '../../onewhiteflash_lineAdjust'
    end
    Files = dir([s3]);
    load (Files.name);
    
    %----------------------------------------------------------------------
    %         turn line angle to position and plot mean result
    %----------------------------------------------------------------------
    
    % rightward    leftward
    if mark == 2  || mark == 3 || mark == 4
        lineLengthDegree = 3.5;
        lineLengthPixel = deg2pix(lineLengthDegree,viewingDistance,screenXpixels,displaywidth);
        [LineAngle_ave_angletest,LineDegree10dva_right_ave_angletest,LineDegree10dva_left_ave_angletest] = RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
        
        PercIlluDegree(sbjnum,:) = [LineDegree10dva_right_ave_angletest(5),LineDegree10dva_left_ave_angletest(5)];
    else
        [angle_R_all,angle_L_all] = RespMat2LineAngle_ave_forBaseline(RespMat,gaborLoc.Start_L,...
            gaborLoc.End_L,gaborLoc.Start_R,gaborLoc.End_R,gaborLoc.Cue_L,gaborLoc.Cue_R);
        PercIlluDegree(sbjnum,:) = [angle_R_all,angle_L_all];
    end
    
    %%%------------------------------------------------------------------
    %     load the time delay document to calculate the cue location
    %%%------------------------------------------------------------------
%     cd '../main_AP/added_gabor_location'
        cd '../../../../../analysis/flash_lineAdjust/normalized_proportion'
        cd '../../../data/GaborDrift/flash_lineAdjust/onewhiteflash_lineAdjust_1000ms'
    
    Files = dir([s3]);
    load (Files.name);
    
    
    %%%--------------------------------------------------
    %     plot the perceived proportion
    %%%--------------------------------------------------
    % angle devide the physical angle is the proportion of perceived
    % 0 is from physical endpoint  1 is from perceived endpoint
    % meanSubIlluDegree (rightward  leftward
    Perc_prop_temp_L = [];
    Perc_prop_temp_R = [];
    [LineAngle_ave,LineDegree10dva_right_ave,LineDegree10dva_left_ave] = ...
        RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
    % porportion: perceived angle(time delay)from physical endpoint devide perceived endpoint angle
    for delay = 1: length(intervalTimesMatSingle)
        Perc_prop_temp_L(delay) = (ang2radi(1/2*meanSubIlluDegree(2)) - LineDegree10dva_left_ave(delay))/...
            (ang2radi(1/2 * meanSubIlluDegree(2)) - PercIlluDegree(sbjnum,2));
    end
    
    for delay = 1: length(intervalTimesMatSingle)
        Perc_prop_temp_R(delay) = (ang2radi(1/2*meanSubIlluDegree(1)) + LineDegree10dva_right_ave(delay))/...
            (ang2radi(1/2 * meanSubIlluDegree(1)) + PercIlluDegree(sbjnum,1));
    end
    
    %%%--------------------------------------------------
    %     plot each subject's perceived proportion
    %%%--------------------------------------------------
    graph(1) = plot(intervalTimesMatSingle*1000,Perc_prop_temp_L * 100);
    hold on;
    graph(2) = plot(intervalTimesMatSingle*1000,Perc_prop_temp_R * 100); % ,'-o','color','b'
    
    Perc_prop_L(sbjnum,:) = Perc_prop_temp_L;
    Perc_prop_norm_L = mean(Perc_prop_L,1);
    Perc_prop_R(sbjnum,:) = Perc_prop_temp_R;
    Perc_prop_norm_R = mean(Perc_prop_R,1);
    Perc_prop(sbjnum,:) = (Perc_prop_temp_L + Perc_prop_temp_R)/2;
    Perc_prop_norm = mean(Perc_prop,1);
    
    
end
% bar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
% Perc_prop_ste = ste(Perc_prop*100,1);
% hold on;
% errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'color',[0 .9 .9],'LineWidth',1.5,'LineStyle','none');
xlabel('time delay(ms)','fontSize',20);
ylabel('proportion from perceived endpoint %','FontSize',20);
% legend;
legend('leftward','rightward','Location','northeast')
% ax = gca;
% ax.FontSize = 20;
set(gcf,'color','w');
set(gca,'box','off');
% if mark == 4;
saveas(figure(1),[pwd '/lucynewjiajia.bmp']);
% end
