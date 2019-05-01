% analysis subject's perception from the end of the perceived or from the
% end of physical  and use function  RespMat2propor

clear all;
addpath '../../function';
% decide analysis which distance
mark = 1;

if mark == 1
    cd '../../data/GaborDrift/simplified2loca/flash1_direc_3vertiDist'
    % 0.5 dva
    sbjnames = {'k'};
elseif mark ~= 1
    % 1.5 dva
    cd '../data/GaborDrift/illusionDegreeSpec/1.5dva'
    sbjnames = {'huijiahan2','kevin','marvin','mert2','shriff2','sunliwei3','liuchengwen','nate'};
end

gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
%     intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];% [0 50 100 150 200 250 300 350]* 0.001;
intervalTimesMatSingle = [0 0.25 0.5 0.75 1];
gaborDistanceFromFixationDegree = [10];
cueVerDisDegree = [0 1.5 3.5];
%     Resp7dva = zeros(8,1);
[Resp_L,Resp_R]  = deal(zeros(length(intervalTimesMatSingle),1));

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    
    % left 1   right 0
    % record the apparent motion from real path
    
    
    for i = 1 : length(RespMat)
        for delay = 1:length(intervalTimesMatSingle)
            if  str2double(RespMat(i,4)) == intervalTimesMatSingle(delay)
                switch RespMat(i,3)
                    % response left 1   right 0
                    % record the apparent motion from perceived endpoint
                    case 'upperRight_leftward'
                        % RespMat(i,6) == 0 direction right  from perceived endpoint
                        % RespMat(i,6) == 1 direction left  from physical endpoint
                        if  str2double(RespMat(i,6)) == 0
                            Resp_L(delay) = Resp_L(delay) + 1;
                        end
                    case 'upperRight_rightward'
                        % RespMat(i,6) == 0 direction right  from physical endpoint
                        % RespMat(i,6) == 1 direction left  from perceived endpoint
                        if  str2double(RespMat(i,6)) == 1
                            Resp_R(delay) = Resp_R(delay) + 1;
                        end
                end
            end
        end
    end
end




trialNumPerCondition = length(RespMat)/(length(intervalTimesMatSingle)*length(gaborDistanceFromFixationDegree))/2;
% Resp7dvaPerc = Resp7dva/trialNumPerCondition;
Resp_L_Perc = Resp_L/trialNumPerCondition;
Resp_R_Perc = Resp_R/trialNumPerCondition;

% plot(intervalTimesMatSingle*1000,Resp7dvaPerc*100);
% hold on;
plot(intervalTimesMatSingle,Resp_L_Perc*100,'r');
hold on;
plot(intervalTimesMatSingle,Resp_R_Perc*100,'b');
%     hold on;
%     plot(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,'r','LineWidth',3);
%     % plot(meanReactionTime);
%
%
%     proporPerc_ste = ste(proporPerc,1);
%     % bar(1:length(intervalTimesMatSingle),mean(proporPerc,2),'r','BarWidth',0.2);
%     errorbar(intervalTimesMatSingle*1000,mean(proporPerc,1)*100,proporPerc_ste*100,'r.');
%
axis([0 1 0 100]);
legend('10dva')
title('proportion of apparent motion from the end of perceived path(far)','FontSize',40);
xlabel('interval time between illusion and test gabor(ms)','fontSize',30);
ylabel({'proportion of apparent motion from the end of perceived path(%)';'  << more from physical      more from perceived  >> '},'FontSize',20);
%     legend(sbjnames,'Location','northeast')
ax = gca;
ax.FontSize = 20;
set(gcf,'color','w');
%     cd '../../../analysis'



