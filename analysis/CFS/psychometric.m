% analysis psychometric function
% for different bar position, percentage of  subject response 'right'


clear all;
clear all;
addpath '../../function';

sbjnames = {'nate'};

% greyMontage   main   nointer
mark = 1;
dataFile = {'main'  'greyMontage'   'nointer'   'binocular'};
dataPath = '../../data/CFS/'
path = char(strcat(dataPath,dataFile(mark)));
cd (path);

for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
    
    
    if mark ~= 3
        [rightTimes_L,rightTimesTotal_L,rightTimes_R,rightTimesTotal_R] = psychmetricCurve(RespMat,barDisFromGaborStartDeg);
        
        respons_L(:,sbjnum) = rightTimes_L;
        respons_R(:,sbjnum) = rightTimes_R;
        responsTotal_L(:,sbjnum) = rightTimesTotal_L;
        responsTotal_R(:,sbjnum) = rightTimesTotal_R;
        
        
        for j = 1:length(barDisFromGaborStartDeg)
            Perc_L(j,sbjnum) = respons_L(j,sbjnum)/responsTotal_L(j,sbjnum);
            Perc_R(j,sbjnum) = respons_R(j,sbjnum)/responsTotal_R(j,sbjnum);
        end
        % no internal motion
    elseif mark == 3
        [rightTimes,rightTimesTotal] = deal(zeros(length(barDisFromGaborStartDeg),sbjnum));
        
        %     %%%------------------------------------------------------
        %     % response 'right'  delete  gabor break through trial
        %     %%%------------------------------------------------------
        for i = 1:length(RespMat)
            for barLoc = 1:length(barDisFromGaborStartDeg)
                % bar location
                if str2double(RespMat(i,5)) == barDisFromGaborStartDeg(barLoc)
                    % isnan == 0 means response left or right or break through
                    % isnan == 0  means not NaN
                    if  isnan(str2double(RespMat(i,7))) == 0  && str2double(RespMat(i,7)) < 2
                        rightTimesTotal(barLoc,sbjnum) = rightTimesTotal(barLoc,sbjnum) + 1;
                        rightTimes(barLoc,sbjnum) =  rightTimes(barLoc,sbjnum) + str2double(RespMat(i,7));
                    end
                end
            end
        end
        % percentage of perceived the bar was on the right
        for j = 1:length(barDisFromGaborStartDeg)
            Perc(j) = rightTimes(j,sbjnum)/rightTimesTotal(j,sbjnum);
        end
    end
end

breakThroughTime_Total = 0;
% break through time
for i = 1:length(RespMat)
    if  str2double(RespMat(i,7)) == 3
        breakThroughTime = str2double(RespMat(i,8));
        breakThroughTime_Total = breakThroughTime_Total + breakThroughTime;
    end
    
end

avebreakThroughTime = breakThroughTime_Total/sum(str2double(RespMat(:,7)) == 3);



% calculate the percentage of trial which gabor didn't break through
% unbreakThroughrate = 1 - sum(double(isnan(str2double(RespMat(1:length(RespMat),7)))))/length(RespMat)
breakThroughrate(sbjnum) = sum(str2double(RespMat(1:length(RespMat),7)) == 3)/length(RespMat)
unawarenessrate(sbjnum) = sum(isnan(str2double(RespMat(1:length(RespMat),7))) == 1)/length(RespMat)


%%%--------------------------------------------------
%     plot the result of leftward
%%%--------------------------------------------------

color = {'b','r','g','c','y','m'};



if mark ~= 3
    if mark == 1
        color_L = char(color(1));
        color_R = char(color(2));
    elseif mark == 2
        color_L = char(color(3));
        color_R = char(color(4));
    elseif mark == 4
        color_L = char(color(5));
        color_R = char(color(6));
    end
    plot(barDisFromGaborStartDeg,mean(Perc_L,2),'-o','color',color_L);
    hold on;
    plot(barDisFromGaborStartDeg,mean(Perc_R,2),'-o','color',color_R);
elseif mark == 3
    plot(barDisFromGaborStartDeg,Perc,'-o','color','k');
end

% plot(barDisFromGaborStartDeg,(Perc_L + Perc_R)/2,'-o','color','k');
% Perc_prop_ste_L = ste(Perc_prop_L*100,1);

% errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm_L * 100),Perc_prop_ste_L,color_error,'color','r');

yline(0.5,'k','lineWidth',1);
% title('proportion of apparent motion perceived from the end of perceived path','FontSize',15);
axis([-2 2 0 1]);
xlabel('bar position - target position','fontSize',20);
ylabel('proportion of the response "the bar was on the right" %','FontSize',20);
% legend('internal motion leftward','internal motion rightward','Location','best','FontSize',20)
% % %     legend(sbjnames,'Location','northeast')
% % ax = gca;
% % ax.FontSize = 20;

set(gcf,'color','w');
% set(gca,'box','off');
% %     title(sbjnames,'FontSize',40);
% % cd '../../../../analysis/flash_lineAdjust'
% saveas(figure(1),[pwd '/offframe20.png']);