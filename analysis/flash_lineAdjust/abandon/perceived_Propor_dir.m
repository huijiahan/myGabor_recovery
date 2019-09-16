% plot the proportion of AP from perceived endpoint
clear all;
clear all;
addpath '../../function';

% list = dir('data/GaborDrift/flash_lineAdjust/main_AP/huijiahan-2019-4-2-15-9')
% % for test flash apparent motion line adjust
% cd '../../data/GaborDrift/flash_lineAdjust'
sbjnames = {'huijiahan','guofanhua'}; % 'linweiru','guofanhua','wangzetong','huijiahan664'，'sunliwei'
foldername = [];

% for sbjnum = 1:length(sbjnames)
%     s1 = string(sbjnames(sbjnum));
%     s2 = '*.mat';
%     s3 = strcat(s1,s2);

BasePath = '/Users/jia/Documents/matlab/DD_illusion/myGabor/data/GaborDrift/flash_lineAdjust'; % Wherever you want
% Warn user if there is no such folder.
if ~exist(BasePath, 'dir')
    message = sprintf('This folder does not exist:\n%s', BasePath);
    uiwait(errordlg(message));
    return;
end
% Get a list of all files, including folders.
DirList  = dir(BasePath);
% Extract only the folders, not regular files.
DirList  = DirList([DirList.isdir]);  % Folders only
% Get rid of first two folders: dot and dot dot.
DirList = DirList(3:(end-1));
% Warn user if there are no subfolders.
if isempty(DirList)
    message = sprintf('This folder does not contain any subfolders:\n%s', BasePath);
    uiwait(errordlg(message));
    return;
end
% Count the number of subfolders.
numberOfFolders = numel(DirList);
% Loop over all subfolders, processing each one.
for k = 1 : numberOfFolders
    thisDir = fullfile(BasePath, DirList(k).name);
    %         foldername = strcat(foldername, DirList(k).name);
    fprintf('Processing folder %d of %d: %s\n', k, numberOfFolders, thisDir);
    cd(thisDir);
    for sbjnum = 1:length(sbjnames)
        s1 = string(sbjnames(sbjnum));
        s2 = '*.mat';
        s3 = strcat(s1,s2);
        Files = dir([s3]);
        load (Files.name);
        
        
        gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
        intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
        gaborDistanceFromFixationDegree = [10];
        
        
        [LineAngle_ave] = RespMat2LineAngle_ave_forDelay(RespMat,intervalTimesMatSingle,gaborDistanceFromFixationDegree);
        
        
        
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
        
        colorMap = mycolorMap(20,3);
        
        Perc_prop(:,sbjnum) = mean(Perc_prop_temp,2);

        Perc_prop_norm(:,k) = mean(Perc_prop,2);

        % plot each subject
        %         if k == 2  %  main
        %             plot(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100,'-o','color','r');
        %         else   % control
        %             plot(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100,'-o','color','b');
        %         end
        
        %         b = bar(intervalTimesMatSingle*1000,(Perc_prop(:,sbjnum))*100);
        %         b.FaceColor = 'flat'; b.EdgeColor= [0 .9 .9]; b.LineWidth = 1.5;
        hold on;
    end
end
Perc_prop_norm = mean(Perc_prop,2);
if k == 2 % main
    h2 = plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'color','r');
else  % control
    h2 = plot(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),'color','b');
end

%     Perc_prop_ste = ste(Perc_prop*100,2);
%     errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm * 100),Perc_prop_ste,'b.');
%     legend(sbjnames(sbjnum));






title('proportion of apparent motion perceived from the end of perceived path','FontSize',20);
axis([-10 400 -10 100]);
xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
ylabel('proportion from perceived endpoint','FontSize',20);

% %     legend(sbjnames,'Location','northeast')
ax = gca;
ax.FontSize = 20;