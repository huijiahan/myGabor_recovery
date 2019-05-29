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
debug = 'y';
subject_name = name;
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
% oldEnableFlag=Screen('Preference', 'EmulateOldPTB', [1]);
HideCursor;
commandwindow;
addpath '../../function';

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


%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
spaceKey = KbName('space');


%----------------------------------------------------------------------
%%%                         Experiment loop parameter
%----------------------------------------------------------------------

% Experiment setup
trialNumber = 24; % have to be divided by  8
blockNumber = 1;

all = RespStartMatrix();


% randomized the different conditions 4 locations 8 directions
gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
% gaborMatSingle = {'lowerLeft_rightward'};
intervalTimesMatSingle = [0 0.25 0.5 1];    % intervalTime second
gaborDistanceFromFixationDegree = [10];   % visual angle degree
barDisFromGaborStartDeg = [-0.2 0 0.2];
% gabor location from center in angle  but fixation move left 3 degree
xCenter = xCenter - gabor.fixationPixel;
yCenter = yCenter;


%
% conditionFreq = (length(gaborMatSingle)*length(gaborDistanceFromFixationDegree));
% repeatFreq = trialNumber/conditionFreq;

% trial repeatTimes of each combined condition
repeatTimes = trialNumber/(length(gaborMatSingle)*length(intervalTimesMatSingle)...
    *length(gaborDistanceFromFixationDegree));
% randomized the different conditions 4 locations 8 directions
blockData = [];
k = 0;
factor1 = [1:length(gaborDistanceFromFixationDegree)]; % blockData 1
factor2 = [1:length(gaborMatSingle)]; % blockData 2
factor3 = [1:length(intervalTimesMatSingle)]; % blockData 3
for i1 = 1:length(factor1)
    for i2 = 1:length(factor2)
        for i3 = 1:length(factor3)
            k = k + 1;
            pickupData(k,:) = [factor1(i1),factor2(i2),factor3(i3)];
        end
    end
end

subData = repmat(pickupData,repeatTimes,1);

if debug == 'n'
    blockData = [subData(Shuffle(1:length(subData)),:)];
elseif debug == 'y'
    blockData = subData;
end

% 3 means 3 locations  1 is physical  2 mid 3 perceived location
%  dotLoca = [gaborLocationPhy; gaborEndLocaMid; gaborLocationPerc];
dotLocaMat = repmat([1; 2; 3],trialNumber/3,1);
dotLocaRand = dotLocaMat(Shuffle(1:length(dotLocaMat)));


%----------------------------------------------------------------------
%%%                         test gaobor parameter
%----------------------------------------------------------------------

time.secondFlashShow = 0.0167;  % before 0.2   0.0167 is for one frame
time.lineDelay = 0.9;
% Make a vector to record the response for each trial
cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);
% flash dot colot of gaussian dot
gauss.dotSizePix = 200;

% gauss.DimVisualAngle = 4;  % gabor visual angle
gauss.Dim = round(deg2pix(gabor.VisualAngle,viewingDistance,screenXpixels,displaywidth));

gauss.testDotDelay = 0.9;
gauss.standDevia = 7 ;% small 7    big 4
gauss.dotFlag = 2;   %  grey flash
% gauss.dotAppeartime = 0.5;

%----------------------------------------------------------------------
%%%                     generate  CFS
%----------------------------------------------------------------------
load /Users/jia/Documents/matlab/DD_illusion/myGabor/function/CFS/CFSMatMovie.mat
% CFSFrequency= 8;
CFSMatMovie=Shuffle(CFSMatMovie);
CFSFrames = 100;
% CFScont = 1;


% load CFS images and Make Textures
% CFSsize_scale = 0.5;
% xsize = 256;
% ysize = 256;
% [x2,y2] = meshgrid(-xsize/2:xsize/2-1,-ysize/2:ysize/2-1); % make a axis
% r2 = sqrt(x2.^2+y2.^2);
% pict = 256*rand(ysize,xsize,3);
% mask2 = r2<xsize/2.*CFSsize_scale;

% pict(:,:,4) = mask2;
% pict(:,:,4) = uint8(pict(:,:,4)*255);
for i=1:CFSFrames
    %     CFSMatMovie{i} =CFScont*(CFSMatMovie{i}-128)+128;
    CFSImage=CFSMatMovie{i};  %.*mask+ContraN;
    %     CFSImage(:,:,4)=mask2*255;
    
    %     CFSImage = CFSImage((256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),(256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),:);
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
            Screen('SelectStereoDrawBuffer', window, 0);
            DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', black);
            Screen('SelectStereoDrawBuffer', window, 1);
            DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', black);
            Screen('Flip', window);
            KbStrokeWait;
        end
        
        
        % in y axis - gaborMoveSpeedPixel / xgaborFactor
        gabor.InternalDriftPhaseIncrPerFrame = gabor.InternalDriftCyclesPerFrame/framerate;
        
        
        
        condition = string(gaborMatSingle(blockData(trial,2)));
        
        
        [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
            orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] = conditionRandDis(condition,blockData,trial);
        
        yframe = [1:gabor.SpeedFrame*cos(subIlluDegree*pi/360):500];
        xframe =  yframe * tan(subIlluDegree*pi/360);
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            
            
            gaborDistanceFromFixationDegreeNow = gaborDistanceFromFixationDegree(blockData(trial,1));
            gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegreeNow,viewingDistance,screenXpixels,displaywidth);
            
            % set the middle of the gabor path 7 or 10 dva away from the fixation
            % so the direction of gabor is crossed in the middle of the path

            gaborStartLocMoveXDegree = gabor.pathLengthDegree/2 * sin((subIlluDegree/360)*pi); % (gabor.pathLengthDegree/2)* sin((subIlluDegree/360)*pi);
            gaborStartLocMoveYDegree = gabor.pathLengthDegree/2 * cos((subIlluDegree/360)*pi); % gabor.pathLengthDegree/2 * cos((subIlluDegree/360)*pi);
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
            frameCFS = round(gabor.stimulusTime * framerate);
                gaborLocationaCFS = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
                + xframeFactor * xframe(frameCFS), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frameCFS));
            if condition == 'upperRight_rightward'             
                gaborLoc.End_R = gaborLocationaCFS;
                [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborLoc.End_R);
                CFSloca_R = [dotXpos_R_end  dotYpos_R_end dotXpos_R_st  dotYpos_R_st];
            elseif  condition == 'upperRight_leftward'
                gaborLoc.End_L = gaborLocationaCFS;
                [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborLoc.End_L);
                CFSloca_L = [dotXpos_L_end    dotYpos_L_end   dotXpos_L_st   dotYpos_L_st];
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
                Screen('DrawTexture',window,CFSTex(w),[],CFSloca_R); % CFSloca_R
            elseif  condition == 'upperRight_leftward'
                Screen('DrawTexture',window,CFSTex(w),[],CFSloca_L); % ,CFSloca_L   [154.4633  543.7759  204.4633  593.7759]
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
        WaitSecs(gauss.testDotDelay);
        
        %----------------------------------------------------------------------
        %%%                         adjustable dot setting
        %----------------------------------------------------------------------
        
        % Now we wait for a keyboard button signaling the observers response.
        % The left arrow key signals a "left" response and the right arrow key
        % a "right" response. You can also press escape if you want to exit the
        % program
        if condition == 'upperRight_rightward'
            gaborEndLocation_R = gaborLocation;
        elseif  condition == 'upperRight_leftward'
            gaborEndLocation_L = gaborLocation;
        end
        
        t1 = GetSecs;
        respToBeMade = true;
        
        % set 3 conditions of perceived location test dot
        gaborLocationPhy = gaborLocation;
        gaborLocationPerc = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
            - xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));
        gaborEndLocaMid = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
            , yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));
        
        dotLoca = [gaborLocationPhy; gaborEndLocaMid; gaborLocationPerc];
        
        
        [dotXpos,dotYpos] = findcenter(dotLoca(dotLocaRand(trial),:));
        
        
        moveStep = 1;
        while respToBeMade
            Screen('SelectStereoDrawBuffer', window, 0);
            %             Screen('Flip',window);
            Screen('DrawDots', window,[xCenter,   yCenter], 10, whiteColor, [], 2);
            Screen('SelectStereoDrawBuffer', window, 1);
            %             Screen('Flip',window);
            Screen('DrawDots', window,[xCenter,   yCenter], 10, whiteColor, [], 2);
            
            [dstRects,flash] = gaussianDot(gauss.dotSizePix,gauss.Dim,dotXpos,dotYpos,grey,whiteColor,gauss.standDevia,gauss.dotFlag);
            Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            masktex = Screen('MakeTexture', window, flash);
            Screen('DrawTextures', window, masktex,[],dstRects);
            %             Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            %Screen('DrawDots', window,[dotXpos,   dotYpos], 25, grey+0.1, [],2);
            
            Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
            Screen('Flip',window);
            
            
            % the gauss dot could move either horizontally or vertically
            [keyIsDown,secs,keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(leftKey)
                response = 1;
                dotXpos = dotXpos - moveStep;
                dotYpos = dotYpos;
            elseif keyCode(rightKey)
                response = 2;
                dotXpos = dotXpos + moveStep;
                dotYpos = dotYpos;
            elseif keyCode(upKey)
                response = 3;
                dotXpos = dotXpos;
                dotYpos = dotYpos - moveStep;
            elseif keyCode(downKey)
                response = 4;
                dotXpos = dotXpos;
                dotYpos = dotYpos + moveStep;
            elseif keyCode(spaceKey)
                response = NaN;
                dotXpos = dotXpos;
                dotYpos = dotYpos;
                respToBeMade = false;
            end
            %             end
            
            
        end
        
        Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
        Screen('SelectStereoDrawBuffer', window, 0);
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('SelectStereoDrawBuffer', window, 1);
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        
        Screen('Flip',window);
        %         WaitSecs(gauss.testDotDelay);
        t2 = GetSecs;
        %         Record the response
        responseTime = t2-t1;
        all.dotLocaRand = [all.dotLocaRand;dotLocaRand(trial)];
        
        all.dotXpos = [all.dotXpos;dotXpos];
        all.dotYpos = [all.dotYpos;dotYpos];
        all.responseTimeVector = [all.responseTimeVector;responseTime];
        all.responseVector = [all.responseVector;response];
        all.Trial =  [all.Trial; trial];
        all.Block =[all.Block; block];
        %         conditionAll = gaborMat(gaborMatIndex(1:trialNumber));
        all.condition = [all.condition;condition];
        all.gaborDistanceFromFixationDegree = [all.gaborDistanceFromFixationDegree; gaborDistanceFromFixationDegreeNow];
        %         all.intervalTimesVector = [all.intervalTimesVector;intervalTimes];
        all.orientation = [all.orientation;orientation];
        
        WaitSecs(0.8);
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        
        RespMat = [all.Block all.Trial  all.condition all.gaborDistanceFromFixationDegree all.responseVector all.dotXpos all.dotYpos all.responseTimeVector all.dotLocaRand];
    end
end

time = clock;
RespMat = [TrialAll  conditionAll gaborDistanceFromFixationDegreeAll responseVector subIlluDegreeAll];
fileName = ['../data/ThresholdTest/simplified2loca/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName);




%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;