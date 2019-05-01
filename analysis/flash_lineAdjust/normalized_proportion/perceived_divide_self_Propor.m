
% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
clear all;
addpath '../../../function';
% decide analysis which distance

eachPercLoc = 'n';
mark = 2;

sbjnames = {'newhuijiahan','lucy'}; % ,'guyang','linweiru2','lucy','qinxiwen'

% for test flash apparent motion line adjust
if mark == 1
    cd '../../../../data/GaborDrift/flash_lineAdjust/main_AP'
    %     sbjnames = {'guofanhua','huijiahan','lucy','hehuixia','linweiru'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    
elseif mark == 2
    cd '../../../data/GaborDrift/flash_lineAdjust/percLocaTest'
    %     sbjnames = {'guofanhua','huijiahan','lucy','hehuixia','linweiru'};
    % for test gabor line adjust
elseif mark == 3
    cd '../../../data/GaborDrift/flash_lineAdjust/onewhiteflash_lineAdjust'
    %     sbjnames = {'lucy'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    
end



for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    
    intervalTimesMatSingle = [0 0.25 0.5 0.75 1];
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
    
    dotXpos_L_ave = mean(dotXpos_L_Mat);
    dotYpos_L_ave = mean(dotYpos_L_Mat);
    dotXpos_R_ave = mean(dotXpos_R_Mat);
    dotYpos_R_ave = mean(dotYpos_R_Mat);
    
    
    %%%------------------------------------------------------------------
    %     load the time delay document for calculate the cue location
    %%%------------------------------------------------------------------
    
    
    cd '../../../../analysis/flash_lineAdjust'
    cd '../../data/GaborDrift/flash_lineAdjust/onewhiteflash_lineAdjust'
    Files = dir([s3]);
    load (Files.name);
    
    [dotXpos_L_cue,dotYpos_L_cue] = findcenter(gaborLoc.Cue_L);
    [dotXpos_R_cue,dotYpos_R_cue] = findcenter(gaborLoc.Cue_R);
    
    
    illuSize_L = atan(dotYpos_L_ave - dotYpos_L_cue)/(dotXpos_L_ave - dotXpos_L_cue);
    illuSize_R = atan(dotYpos_R_ave - dotYpos_R_cue)/(dotXpos_R_ave - dotXpos_R_cue);
    
    SubIlluDegree = [illuSize_R,illuSize_L];
    
    
    
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
    
    
    for delay = 1: length(intervalTimesMatSingle)
        Perc_prop_temp_L(delay) = 1/2 - LineDegree10dva_left_ave(delay)/(SubIlluDegree(2));
    end
    
    for delay = 1: length(intervalTimesMatSingle)
        Perc_prop_temp_R(delay) = 1/2 + LineDegree10dva_right_ave(delay)/(SubIlluDegree(1));
    end
    
    %%%--------------------------------------------------
    %     plot each subject's perceived proportion
    %%%--------------------------------------------------    
    plot(intervalTimesMatSingle*1000,Perc_prop_temp_L*100);
    plot(intervalTimesMatSingle*1000,Perc_prop_temp_R*100);
    
    Perc_prop_L(sbjnum,:) = Perc_prop_temp_L;
    Perc_prop_norm_L = mean(Perc_prop_L,1);
    Perc_prop_R(sbjnum,:) = Perc_prop_temp_R;
    Perc_prop_norm_R = mean(Perc_prop_R,1);
    Perc_prop(sbjnum,:) = (Perc_prop_temp_L + Perc_prop_temp_R)/2;
    Perc_prop_norm = mean(Perc_prop,1);
    
    
    % end

    %     if mark == 1   % main
    %         color_single = 'r';
    %     elseif mark == 2   % control
    %         color_single = 'g';
    %     elseif mark == 3  % one white flash
    %         color_single = 'm';
    %     end
    
    
    %     plot(intervalTimesMatSingle*1000,(Perc_prop(sbjnum,:))*100); % ,'color',color_single
    %     hold on;
    
end


% plot(intervalTimesMatSingle*1000,(Perc_prop_L' * 100),'-o');
% plot(intervalTimesMatSingle*1000,(Perc_prop_R * 100),'-o');


%%%--------------------------------------------------
%     plot the result of leftward
%%%--------------------------------------------------

plot(intervalTimesMatSingle*1000,(Perc_prop_norm_L * 100),'-o','color','r');
Perc_prop_ste_L = ste(Perc_prop_L*100,1);
hold on;
% errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm_L * 100),Perc_prop_ste_L,color_error,'color','r');
%%%--------------------------------------------------
%     plot the result of leftward
%%%--------------------------------------------------
plot(intervalTimesMatSingle*1000,(Perc_prop_norm_R * 100),'-o','color','b');
Perc_prop_ste_R = ste(Perc_prop_R*100,1);
hold on;
% errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm_R * 100),Perc_prop_ste_R,'color','b');
%%%--------------------------------------------------
%     plot the result of all
%%%--------------------------------------------------
% plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'-o','color','g');
% Perc_prop_ste = ste(Perc_prop*100,1);
% hold on;
% errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'g.');

% [p,tbl,stats] = anova1(Perc_prop_L);




title('proportion of apparent motion perceived from the end of perceived path','FontSize',15);
% axis([-10 1000 0 100]);
xlabel('interval time between illusion and test gabor(ms)','fontSize',10);
ylabel('proportion from perceived endpoint %','FontSize',10);
% legend('internal motion leftward','internal motion rightward','best')
% %     legend(sbjnames,'Location','northeast')
% ax = gca;
% ax.FontSize = 20;
set(gcf,'color','w');
set(gca,'box','off');
%     title(sbjnames,'FontSize',40);
% cd '../../../../analysis/flash_lineAdjust'
saveas(figure(1),[pwd '/avdrage.png']);