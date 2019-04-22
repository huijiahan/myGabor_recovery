%% my first gabor drift

% test degree illusion in  8 location across the visual field with
% corresponding oritation

%% clear the workspace
close all;
clearvars;
sca;
%----------------------------------------------------------------------
%                      set up Psychtoolbox and skip  sync
%----------------------------------------------------------------------
name = input('>>>> Participant name (e.g.: AB):  ','s');
subject_name = name;
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
% oldEnableFlag=Screen('Preference', 'EmulateOldPTB', [1]);
HideCursor;
commandwindow;
addpath '../function';

%     Screen('Prefere nce','VisualDebugLevel',0); % warning triangle

% set up screens
screens = Screen('Screens');
screenNumber = max(screens);
blackColor = BlackIndex(screenNumber);
whiteColor = WhiteIndex(screenNumber);
grey = whiteColor/2;
stereoMode = 4;

% set the window size
winSize = [0 0 1024 768];   %[0 0 1024 768];


%----------------------------------------------------------------------
%                      open a screen
%----------------------------------------------------------------------

% [window winRect] = PsychImaging('OpenWindow',screenNumber,grey,winSize);
[window winRect] = Screen('OpenWindow',screenNumber,128,winSize,[],[],stereoMode);
[xCenter, yCenter] = RectCenter(winRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[displaywidth, ~] = Screen('DisplaySize', screenNumber);  %
Screen('TextSize', window, 40);
% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);
framerate = FrameRate(window);
viewingDistance = 60; % subject distance to the screen
%----------------------------------------------------------------------
%                       Gabor information
%----------------------------------------------------------------------

gabor = gaborParaSet(window,screenXpixels,displaywidth,viewingDistance,framerate);
orientationAll = [];

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');


%----------------------------------------------------------------------
%%%                         Experiment loop parameter
%----------------------------------------------------------------------

% Experiment setup
trialNumber = 10; % have to be divided by  8
blockNumber = 1;

subIlluDegreeStep = 2;
responseVector = []; %
TrialAll = [];
BlockAll = [];
conditionAll = [];
subIlluDegreeAll = [];
gaborDistanceFromFixationDegreeAll = [];
% randomized the different conditions 4 locations 8 directions
gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
% gaborMatSingle = {'lowerLeft_rightward'};

% gabor location from center in angle  but fixation move left 3 degree
xCenter = xCenter - gabor.fixationPixel;
yCenter = yCenter;

gaborDistanceFromFixationDegree = [10];   % visual angle degree

conditionFreq = (length(gaborMatSingle)*length(gaborDistanceFromFixationDegree));
repeatFreq = trialNumber/conditionFreq;

k = 0;
factor1 = [1:length(gaborDistanceFromFixationDegree)]; % blockData 1
factor2 = [1:length(gaborMatSingle)]; % blockData 2
for i1 = 1:length(factor1)
    for i2 = 1:length(factor2)
        k = k + 1;
        subData(k,:) = [factor1(i1), factor2(i2)];
    end
end


blockData = repmat(subData,repeatFreq,1);
% random sequence of condition
randSequ = [blockData(Shuffle(1:length(blockData)),:)];
% condition show in order
% randSequ = blockData;

subIlluDegreeStart = 45;
% store each trial each location subIlluDegree in the matrix
subIlluDegree = zeros(conditionFreq,trialNumber/conditionFreq + 1);
subIlluDegree(1:conditionFreq,1) = subIlluDegreeStart;
gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegree,viewingDistance,screenXpixels,displaywidth);

%----------------------------------------------------------------------
%%%                     generate  CFS
%----------------------------------------------------------------------
load /Users/jia/Documents/matlab/DD_illusion/myGabor/function/CFS/CFSMatMovie.mat
CFSFrequency= 8;
CFSMatMovie=Shuffle(CFSMatMovie);
CFSFrames = 100;
CFScont = 1;
% frameRate = 60;



% r2 = disk_radius;
% pict = 256*rand(disk_radius,disk_radius,3);
% mask2 = r2<disk_radius;
% pict(:,:,4) = mask2;
% pict(:,:,4) = uint8(pict(:,:,4)*255);
% load CFS images and Make Textures
CFSsize_scale = 0.25;
xsize = 256;
ysize = 256;
[x2,y2] = meshgrid(-xsize/2:xsize/2-1,-ysize/2:ysize/2-1); % make a axis
r2 = sqrt(x2.^2+y2.^2);
% pict = 256*rand(ysize,xsize,3);
mask2 = r2<xsize/2.*CFSsize_scale;

% pict(:,:,4) = mask2;
% pict(:,:,4) = uint8(pict(:,:,4)*255);
for i=1:CFSFrames
    CFSMatMovie{i} =CFScont*(CFSMatMovie{i}-128)+128;
    CFSImage=CFSMatMovie{i};  %.*mask+ContraN;
    CFSImage(:,:,4)=mask2*255;
    
    CFSImage = CFSImage((256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),(256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),:);
    CFSTex(i)=Screen('MakeTexture',window,CFSImage);
end





%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------


for block = 1: blockNumber
    
    
    for trial = 1:trialNumber
        % If this is the first trial we present a start screen and wait for a
        % key-press
        if trial == 1
            DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', black);
            Screen('Flip', window);
            KbStrokeWait;
        end
        
        
        % in y axis - gaborMoveSpeedPixel / xgaborFactor
        gabor.InternalDriftPhaseIncrPerFrame = gabor.InternalDriftCyclesPerFrame/framerate;
        
        
        % set different condition parameters
        
        %         [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
        %     orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] = conditionRandDis(condition,blockData,trial);
        
        % to make a subIlluDegree matrix  row is  gaborMatSingle type with
        % one distance in gaborDistanceFromFixationDegree(row = 12)
        % column is each trial result
        % compare this type of trial in all the trials have been presented
        % here determine the subIlluDegree  order
        % first is gaborDistanceFromFixationDegree second is gaborMatSingle
        % 7 upperRight_rightward
        % 7 upperRight_leftward
        % 10 upperRight_rightward
        % 10 upperRight_leftward
        
        % blockData is in order and check each trial condition is in which
        % condition set the subIlluDegreeIndex as the same order as
        % blockData
        % 7dva rightward 7dva leftward    10 dva rightward 10dva leftward
        for q = 1:conditionFreq
            if randSequ(trial,:) == blockData(q,:)
                subIlluDegreeIndex = q;
            end
        end
        
        
        
        eachCondIlluDegreeTimes1 = double(randSequ(1:trial,:) == randSequ(trial,:));
        % count the frequency of this type of trial have been prensented
        eachCondIlluDegreeTimes = length(find(int8(sum(eachCondIlluDegreeTimes1,2) == 2) == 1));
        
        
        % subIlluDegreeIndex is in the same order as blockData
        % 5 'upperRight_rightward',  5 'upperRight_leftward'   7 'upperRight_rightward',  7 'upperRight_leftward'
        if eachCondIlluDegreeTimes == 1
            subIlluDegreeNow = subIlluDegreeStart;
        else
            subIlluDegreeNow = subIlluDegree(subIlluDegreeIndex,eachCondIlluDegreeTimes);
        end
        
        condition = string(gaborMatSingle(randSequ(trial,2)));
        [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
            orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] = conditionRandDis(condition);
        % compare randSequ with subData and determine each trial's
        % subIlluDegreeNow is in which condition in 12 condition
        
        
        
        %         subIlluDegree(find(TF)',trialIndex) = subIlluDegree(find(TF)',trialIndex-1);
        %         TF = contains(gaborMatSingle,condition);
        %         subIlluDegree(find(TF)',trialIndex) = subIlluDegree(find(TF)',trialIndex);
        
        yframe = [1:gabor.SpeedFrame:300];
        xframe = yframe * tan(subIlluDegreeNow*pi/180);
        
        
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            
            
            gaborDistanceFromFixationDegreeNow = gaborDistanceFromFixationDegree(randSequ(trial,1));
            gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegreeNow,viewingDistance,screenXpixels,displaywidth);
            
            % set the middle of the gabor path 7 or 10 dva away from the fixation
            % so the direction of gabor is crossed in the middle of the path
            gaborStartLocMoveXDegree =  (gabor.pathLengthDegree/2)* sin((subIlluDegreeNow/180)*pi);
            gaborStartLocMoveYDegree =  gabor.pathLengthDegree/2 * cos((subIlluDegreeNow/180)*pi);
            gaborStartLocMoveXPixel = deg2pix(gaborStartLocMoveXDegree,viewingDistance,screenXpixels,displaywidth);
            gaborStartLocMoveYPixel = deg2pix(gaborStartLocMoveYDegree,viewingDistance,screenXpixels,displaywidth);
            
            
            
            % define the tractory of gabor movement   start from xCenter + 7/10 dva +  move gabor's center to the same level of fixation
            %             gaborLocation = CenterRectOnPointd(gabor.rect, xCenter + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel ...
            %                 + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel+  yframeFactor * yframe(frame));
            gaborLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
                + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));
            %----------------------------------------------------------------------
            %                       save the gabor start location
            %----------------------------------------------------------------------
            
            if frame == 1
                if condition == 'upperRight_rightward'
                    gaborLoc.Start_R = gaborLocation;
                    [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborLoc.Start_R);
                elseif  condition == 'upperRight_leftward'
                    gaborLoc.Start_L = gaborLocation;
                    [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborLoc.Start_L);
                end
            end
            
            
            
            %             Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
            %                 kPsychDontDoRotation, gabor.propertiesMatFirst');
            
            % Randomise the phase of the Gabors and make a properties matrix
            gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
            
            %----------------------------------------------------------------------
            %                       save the gabor end location
            %----------------------------------------------------------------------
            
            if condition == 'upperRight_rightward'
                gaborLoc.End_R = gaborLocation;
                [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborLoc.End_R);
                CFSloca_R = [dotXpos_R_st  dotYpos_R_st dotXpos_R_end  dotYpos_R_end];
            elseif  condition == 'upperRight_leftward'
                gaborLoc.End_L = gaborLocation;
                [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborLoc.End_L);
                CFSloca_L = [dotXpos_L_st   dotYpos_L_st   dotXpos_L_end    dotYpos_L_end];
            end
            
            %             if condition == 'upperRight_rightward'
            %                 gaborLoc.Cue_R = cueLocation;
            %             elseif  condition == 'upperRight_leftward'
            %                 gaborLoc.Cue_L = cueLocation;
            %             end
            
            
            % Draw fixation
            %             Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
            %----------------------------------------------------------------------
            %                       drawTesture for each side of screen
            %----------------------------------------------------------------------
            w = randi(100,1);
            Screen('SelectStereoDrawBuffer', window, 0);  % 0 mean left eye
            %             Screen('DrawTexture',window,backTex);
            Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
            Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                kPsychDontDoRotation, gabor.propertiesMatFirst');
            
            Screen('SelectStereoDrawBuffer', window, 1); % 1 means right eye   CFS
            Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
            %             Screen('DrawTexture',window,backTex);
            if condition == 'upperRight_rightward'
                Screen('DrawTexture',window,CFSTex(w),[]); % CFSloca_R
            elseif  condition == 'upperRight_leftward'
                Screen('DrawTexture',window,CFSTex(w),[]); % ,CFSloca_L
            end
            
            
            % Flip to the screen
            Screen('Flip',window);
        end
        
        
        Screen('SelectStereoDrawBuffer', window, 0);  % 0 mean left eye
        Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
        
        
        Screen('SelectStereoDrawBuffer', window, 1); % 1 means right eye
        Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
        
        %         Screen('DrawDots', window,[xCenter,  yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        
        % in rightward conditon respond left incre = -1; reight Incre = 1;
        % in leftward conditon respond left Incre = 1; right Incre = -1;
        
        % different condition means different directions
        internalPattern1 = "rightward";
        internalPattern2 = "leftward";
        iTF1 = contains(condition,internalPattern1);
        iTF2 = contains(condition,internalPattern2);
        
        if iTF1 == 1
            
            % Now we wait for a keyboard button signaling the observers response.
            % The left arrow key signals a "left" response and the right arrow key
            % a "right" response. You can also press escape if you want to exit the
            % program
            
            respToBeMade = true;
            while respToBeMade
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(leftKey)
                    response = 1;
                    subIlluDegreeIncre = - subIlluDegreeStep;
                    respToBeMade = false;
                elseif keyCode(rightKey)
                    response = 0;
                    subIlluDegreeIncre =  subIlluDegreeStep;
                    respToBeMade = false;
                end
            end
        elseif iTF2 == 1
            respToBeMade = true;
            while respToBeMade
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(leftKey)
                    response = 1;
                    subIlluDegreeIncre = subIlluDegreeStep;
                    respToBeMade = false;
                elseif keyCode(rightKey)
                    response = 0;
                    subIlluDegreeIncre = - subIlluDegreeStep;
                    respToBeMade = false;
                end
            end
        end
        
        
        
        % there is 2 distance of subIlluDegree
        %         if gaborDistanceFromFixationDegreeNow == 7
        % record condition
        subIlluDegree(subIlluDegreeIndex,eachCondIlluDegreeTimes+1) = subIlluDegreeNow + subIlluDegreeIncre;
        %         subIlluDegree(find(TF),trialIndex+1) =  subIlluDegree(find(TF),trialIndex) + subIlluDegreeIncre;
        
        % Record the response
        subIlluDegreeAll = [subIlluDegreeAll;subIlluDegree(subIlluDegreeIndex,eachCondIlluDegreeTimes+1)];
        responseVector = [responseVector;response];
        TrialAll =  [TrialAll; trial];
        gaborDistanceFromFixationDegreeAll = [gaborDistanceFromFixationDegreeAll;gaborDistanceFromFixationDegree(randSequ(trial,1))];
        conditionAll = [conditionAll;condition];
        WaitSecs(1);
        
    end
end

time = clock;
RespMat = [TrialAll  conditionAll gaborDistanceFromFixationDegreeAll responseVector subIlluDegreeAll];
fileName = ['../data/ThresholdTest/simplified2loca/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName,'RespMat','subIlluDegree','gabor','viewingDistance','trialNumber','blockNumber');



plot(subIlluDegree');
meansubIlluDegree = mean(subIlluDegree(:,10:end),2);
meansubIlluDegree'
% plot(meansubIlluDegree);



%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;