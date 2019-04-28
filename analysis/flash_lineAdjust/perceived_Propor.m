% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
clear all;
addpath '../../function';
% decide analysis which distance


mark = 3;

sbjnames = {'lucy'}; % ,'guyang','linweiru2','lucy','qinxiwen'

% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP'
    %     sbjnames = {'guofanhua','huijiahan','lucy','hehuixia','linweiru'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    
elseif mark == 2
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
    %     sbjnames = {'guofanhua','huijiahan','lucy','hehuixia','linweiru'};
    % for test gabor line adjust
elseif mark == 3
    cd '../../data/GaborDrift/flash_lineAdjust/onewhiteflash_lineAdjust'
    %     sbjnames = {'lucy'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    
end



for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
    if mark == 3
        intervalTimesMatSingle = [0 0.25 0.5 0.75 1];
    else
        intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
    end
    gaborDistanceFromFixationDegree = [10];
    [LineAngle_ave,LineDegree10dva_right_ave,LineDegree10dva_left_ave] = ...
        RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
    
    Perc_prop_temp_L = [];
    Perc_prop_temp_R = [];
    %%%--------------------------------------------------
    %     plot the perceived proportion
    %%%--------------------------------------------------
    % angle devide the physical angle is the proportion of perceived
    % 0 is from physical endpoint  1 is from perceived endpoint
    for delay = 1: length(intervalTimesMatSingle)
        Perc_prop_temp_L(delay) = 1/2 - LineDegree10dva_left_ave(delay)/(ang2radi(meanSubIlluDegree(2)));
    end
    
    for delay = 1: length(intervalTimesMatSingle)
        Perc_prop_temp_R(delay) = 1/2 + LineDegree10dva_right_ave(delay)/(ang2radi(meanSubIlluDegree(1)));
    end
    
    plot(intervalTimesMatSingle*1000,Perc_prop_temp_L*100);
    plot(intervalTimesMatSingle*1000,Perc_prop_temp_R*100);
    
    Perc_prop_L(sbjnum,:) = Perc_prop_temp_L;
    Perc_prop_norm_L = mean(Perc_prop_L,1);
    Perc_prop_R(sbjnum,:) = Perc_prop_temp_R;
    Perc_prop_norm_R = mean(Perc_prop_R,1);
    Perc_prop(sbjnum,:) = (Perc_prop_temp_L + Perc_prop_temp_R)/2;
    Perc_prop_norm = mean(Perc_prop,1);
    
    
    % end
    %%%--------------------------------------------------
    %     plot each subject's proportion
    %%%--------------------------------------------------
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
if mark == 1  % main
    
    color = 'r';
    color_error = 'r.';
elseif mark ~= 1
    color = 'b';
    color_error = 'b.';
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
axis([-10 1000 0 100]);
xlabel('interval time between illusion and test gabor(ms)','fontSize',10);
ylabel('proportion from perceived endpoint %','FontSize',10);
legend('internal motion leftward','internal motion rightward','best')
% %     legend(sbjnames,'Location','northeast')
% ax = gca;
% ax.FontSize = 20;
set(gcf,'color','w');
set(gca,'box','off');
%     title(sbjnames,'FontSize',40);
% cd '../../../../analysis/flash_lineAdjust'
saveas(figure(1),[pwd '/avdrage.png']);