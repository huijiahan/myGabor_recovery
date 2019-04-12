% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
clear all;
addpath '../../function';
% decide analysis which distance


mark = 1;
% for test flash apparent motion line adjust
if mark == 1
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP'
    sbjnames = {'linweiru'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
elseif mark == 2
    cd '../../data/GaborDrift/flash_lineAdjust/circle_control'
    sbjnames = {'guofanhua','huijiahan','lucy','hehuixia','linweiru'};
    lineAngleColumn = 7;
    
    % for test gabor line adjust
elseif mark == 3
    cd '../../data/GaborDrift/gabor_lineAdjust/1Ori1Dis'
    % 0.5 dva
    sbjnames = {'k2Ori'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
    lineAngleColumn = 7;
    
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
    [LineAngle_ave] = RespMat2LineAngle_ave(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
    
    %%%--------------------------------------------------
    %     plot the perceived proportion
    %%%--------------------------------------------------
    % angle devide the physical angle is the proportion of perceived
    % 0 is from physical endpoint  1 is from perceived endpoint
    for delay = 1: length(intervalTimesMatSingle)
        for j = 1:size(LineAngle_ave,2)
            if j == 1 % rightward
                Perc_prop_temp(delay,j) = 1/2 + LineAngle_ave(delay,j)/(ang2radi(meanSubIlluDegree(j)));
            elseif j == 2 % leftward
                Perc_prop_temp(delay,j) = 1/2 - LineAngle_ave(delay,j)/(ang2radi(meanSubIlluDegree(j)));
            end
        end
    end
    
    
    Perc_prop(:,sbjnum) = mean(Perc_prop_temp,2);
    Perc_prop_norm = mean(Perc_prop,2);
    
    
    %     if mark == 1   % main
    %         plot(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100,'color','r');
    %     elseif mark == 2   % control
    %         plot(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100,'color','b');
    %     end
    %     hold on;
    
end    
    if mark == 1  % main
        h1 = plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'-o','color','r');
        Perc_prop_ste = ste(Perc_prop*100,2);
        hold on;
        errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'r.');
%         legend([h1],'AP');
    elseif mark == 2   % control
        h2 = plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'-o','color','b');
        Perc_prop_ste = ste(Perc_prop*100,2);
        hold on;
        errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'b.');
%         legend([h2],'control');
    end
    hold on;

title('proportion of apparent motion perceived from the end of perceived path','FontSize',20);
axis([-10 400 -10 100]);
xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
ylabel('proportion from perceived endpoint','FontSize',20);
legend('AP','control')
% %     legend(sbjnames,'Location','northeast')
ax = gca;
ax.FontSize = 20;


%     title(sbjnames,'FontSize',40);
cd '../../../../analysis/flash_lineAdjust'
