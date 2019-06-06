% analysis psychometric function
% for different bar position, percentage of  subject response 'right'


clear all;
clear all;
addpath '../../function';

sbjnames = {'huijiahan'}; % ,'guyang','linweiru2','lucy','qinxiwen'

cd '../../data/CFS'




for sbjnum = 1:length(sbjnames)
    s1 = string(sbjnames(sbjnum));
    s2 = '*.mat';
    s3 = strcat(s1,s2);
    Files = dir([s3]);
    load (Files.name);
 
  
    [PercRightTimes_L,PercRightTimes_R] = deal(zeros(3,1));
    
    %%%--------------------------------------------------
    %
    %%%--------------------------------------------------
    for i = 1:length(RespMat)
        for bar = length(barDisFromGaborStartDeg)
            if str2double(RespMat(i,5)) == barDisFromGaborStartDeg(bar)
                switch RespMat(i,3)
                    case 'upperRight_leftward'
                    PercRightTimes_L(bar) =  PercRightTimes_L(bar) + str2double(RespMat(i,7)) - 1; 
                        
                    case 'upperRight_rightward'
                    PercRightTimes_R(bar) =  PercRightTimes_R(bar) + str2double(RespMat(i,7)) - 1; 
                end
            end
        end
    end
                        
end                        
                      
%%%--------------------------------------------------
%     plot the result of leftward
%%%--------------------------------------------------

plot(barDisFromGaborStartDeg,PercRightTimes_L,'-o','color','r');
% Perc_prop_ste_L = ste(Perc_prop_L*100,1);
hold on;
% errorbar(intervalTimesMatSingle*1000,(Perc_prop_norm_L * 100),Perc_prop_ste_L,color_error,'color','r');


% title('proportion of apparent motion perceived from the end of perceived path','FontSize',15);
% axis([-10 1000 0 100]);
% xlabel('interval time between illusion and test gabor(ms)','fontSize',10);
% ylabel('proportion from perceived endpoint %','FontSize',10);
% legend('internal motion leftward','internal motion rightward','best')
% % %     legend(sbjnames,'Location','northeast')
% % ax = gca;
% % ax.FontSize = 20;
% set(gcf,'color','w');
% set(gca,'box','off');
% %     title(sbjnames,'FontSize',40);
% % cd '../../../../analysis/flash_lineAdjust'
% saveas(figure(1),[pwd '/avdrage.png']);