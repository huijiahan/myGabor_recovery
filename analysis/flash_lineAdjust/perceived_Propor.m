% plot the proportion of AP from perceived endpoint


clear all;
clear all;
addpath '../../function';


FileName = fullfile({List.folder}, {List.name});
for k = 1:numel(FileName)
    disp(FileName{k})

end

filePattern = fullfile(pwd)
list = dir (filePattern);
fullFileName = fullfile(pwd, list(i).name);
A(:,i) = importdata(fullFileName);


list = dir('../../data/GaborDrift/flash_lineAdjust/main_AP/huijiahan*.mat')

list = dir('data/GaborDrift/flash_lineAdjust/main_AP/huijiahan-2019-4-2-15-9')
% for test flash apparent motion line adjust
    cd '../../data/GaborDrift/flash_lineAdjust/main_AP'
    % 0.5 dva
    sbjnames = {'guofanhua'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'

   
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
    
    figure;
%     if Perc_prop_mark == 'y'
%         if mark == 1
            plot(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100,'color','r');            
%         elseif mark == 2
%             plot(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100,'color','b');
%         end
        hold on;
        %         set(gca,'XAxisLocation','top','YAxisLocation','left','ydir');
    
    end

% end

% if Perc_prop_mark == 'n'
%     if mark == 1
%         h1 = plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'color','r');
%         hold on;
%         Perc_prop_ste = ste(Perc_prop*100,2);
%         errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'r.');
%         legend([h1],'AP');
%     elseif mark == 2
        h2 = plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'color','b');
        Perc_prop_ste = ste(Perc_prop*100,2);
        errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'b.');
        legend(sbjnames(sbjnum));
%     end
% end
    title('proportion of apparent motion perceived from the end of perceived path','FontSize',20);
    axis([-10 400 -10 100]);
    xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
    ylabel('proportion from perceived endpoint','FontSize',20);

    % %     legend(sbjnames,'Location','northeast')
ax = gca;
ax.FontSize = 20;
hold on;