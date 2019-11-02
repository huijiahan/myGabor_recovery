%% my first gabor drift

% test degree illusion in  8 location across the visual field with
% corresponding oritation

clearvars;
sca;
gogglemark = input('>>>> goggle? (e.g.: y or n):  ','s');
expmark = input('>>>> which exp (e.g.: 1/2/3/4):  ');
% 1 CFS main exp BR  2 control nointernal motion BR  3 control binocular without CFS
% 4 grey montage control BR
% name = input('>>>> Participant name (e.g.: AB):  ','s');
% age = input('>>>> Participant age (e.g.: 24):  ');
% dominant_eye = input('>>>> dominant eye (e.g.: l/r):  ','s');
% session = input('>>>> session (e.g.: 1/2/3):  ','s');


name = 'k';
age = 26;
dominant_eye = 'l';
session = 1;
CFScovermark = 'p';   % f = full   p = part   part means the top edge of gabor over the CFS top edge and CFS disappear
% expmark = 4;

%----------------------------------------------------------------------
%                      set up Psychtoolbox and skip  sync
%----------------------------------------------------------------------

%% clear the workspace
close all;
debug = 'n';
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
screenNumber = max(screens);
% Define black, white and grey
blackColor = BlackIndex(screenNumber);
whiteColor = WhiteIndex(screenNumber);
grey = whiteColor/2;


if expmark == 3
    stereoMode = 0;   % 4 for stereoscope   11 for shutter glass  10 second times for test whether covered
else
    if gogglemark == 'y'
        stereoMode = 102;
    elseif  gogglemark == 'n'
        stereoMode = 4;
    end
end
% set the window size
winSize = [0 0 1024 768];   %[0 0 1024 768];


%----------------------------------------------------------------------
%                      open a screen
%----------------------------------------------------------------------

if stereoMode == 102
    % Prepare setup of imaging pipeline for onscreen window.
    % This is the first step in the sequence of configuration steps.
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask','General','SideBySideCompressedStereo');
    [window winRect] = PsychImaging('OpenWindow',screenNumber,128,winSize,[],[],stereoMode);
    %     gammaTable = [0.5 0.5 0.5];
    %     Screen('LoadNormalizedGammaTable', window, gammaTable);
    AssertOpenGL;
    
    oldVisualDebugLevel   = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
else
    
    %     [window winRect] = PsychImaging('OpenWindow',screenNumber,grey,winSize);
    [window,winRect] = Screen('OpenWindow',screenNumber,128,winSize,[],[],stereoMode);%1024 768
end


[xCenter, yCenter] = RectCenter(winRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[displaywidth, ~] = Screen('DisplaySize', screenNumber);  %
Screen('TextSize', window, 40);
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
trialNumber = 36; % have to be divided by  12
blockNumber = 6;

all = RespStartMatrix();


% randomized the different conditions 4 locations 8 directions
gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
% gaborMatSingle = {'lowerLeft_rightward'};
% intervalTimesMatSingle = [0 0.25 0.5 1];    % intervalTime second
gaborDistanceFromFixationDegree = [10];   % visual angle degree
barDisFromGaborStartDeg = [-1 0 1];
eyeCFS = [0 1];  %0 mean left eye
% gabor location from center in angle  but fixation move left 3 degree
xCenter = xCenter - gabor.fixationPixel;
yCenter = yCenter;

barDisFromGaborStartPix = deg2pix(barDisFromGaborStartDeg,viewingDistance,screenXpixels,displaywidth);

blockData = [];

[blockData,subData]=randCondi(gaborDistanceFromFixationDegree,gaborMatSingle,...
    barDisFromGaborStartDeg,eyeCFS,trialNumber);



if debug == 'n'
    blockData = [subData(Shuffle(1:length(subData)),:)];
elseif debug == 'y'
    blockData = subData;
end


barDelay = 1;


%----------------------------------------------------------------------
%%%                     generate  CFS
%----------------------------------------------------------------------
load /Users/jia/Documents/matlab/DD_illusion/myGabor/function/CFS/CFSMatMovie1.mat
% CFSFrequency= 8;
CFSMatMovie=Shuffle(CFSMatMovie);
CFSFrames = 100;
CFSwidth = 60; %30;
% make sure the gabor was all covered by CFS,CFS started y axis lower than
% center of gabor start point
CFScoverGabor = gabor.DimPix/2;
% CFScoverGabor = 25;
CFScont = 0.8;
CFSoffFrame = 15;


for i=1:CFSFrames
    CFSMatMovie{i} =CFScont*(CFSMatMovie{i}-128)+128;
    CFSImage=CFSMatMovie{i};%.*mask+ContraN;
    %     CFSImage(:,:,4)=mask2*255;
    
    %     CFSImage = CFSImage((256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),(256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),:);
    CFSTex(i)=Screen('MakeTexture',window,CFSImage);
end


%----------------------------------------------------------------------
%       draw binocular circles to justify the steroscope
%----------------------------------------------------------------------
% Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
Screen('SelectStereoDrawBuffer', window, 0);
Screen('FrameOval', window, 60, [xCenter - 50 yCenter - 50 xCenter + 50  yCenter + 50], 4);
Screen('SelectStereoDrawBuffer', window, 1);
Screen('FrameOval', window, 179, [xCenter - 50 yCenter - 50 xCenter + 50  yCenter + 50], 4);
Screen('Flip', window);
KbStrokeWait;
%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------


for block = 1: blockNumber
    
    
    for trial = 1:trialNumber
        % If this is the first trial we present a start screen and wait for a
        % key-press
        if trial == 1
            formatSpec = 'This is the %d of %d block. \n\n Press Any Key To Begin';
            if block ~= 1
                formatSpec = 'You could have a rest. \n\n This is the %d of %d block. \n\n Press Any Key To Begin';
            end
            A1 = block;
            A2 = blockNumber;
            str = sprintf(formatSpec,A1,A2);
            Screen('SelectStereoDrawBuffer', window, 0);
            DrawFormattedText(window, str, 'center', 'center', blackColor);
            Screen('SelectStereoDrawBuffer', window, 1);
            DrawFormattedText(window, str, 'center', 'center', blackColor);
            Screen('Flip', window);
            KbStrokeWait;
        end
        
        
        % in y axis - gaborMoveSpeedPixel / xgaborFactor
        gabor.InternalDriftPhaseIncrPerFrame = gabor.InternalDriftCyclesPerFrame/framerate;
        
        
        
        condition = string(gaborMatSingle(blockData(trial,2)));
        
        
        [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
            orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] = conditionRandDis(condition); %
        
        yframe = [1:gabor.SpeedFrame*cos(subIlluDegree*pi/360):500];
        xframe =  yframe * tan(subIlluDegree*pi/360);
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            
            
            gaborDistanceFromFixationDegreeNow = gaborDistanceFromFixationDegree(blockData(trial,1));
            gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegreeNow,viewingDistance,screenXpixels,displaywidth);
            
            % set the middle of the gabor path 7 or 10 dva away from the fixation
            % so the direction of gabor is crossed in the middle of the path
            
%             gaborStartLocMoveXDegree = gabor.pathLengthDegree * sin((subIlluDegree/360)*pi); % (gabor.pathLengthDegree/2)* sin((subIlluDegree/360)*pi);
%             gaborStartLocMoveYDegree = gabor.pathLengthDegree * cos((subIlluDegree/360)*pi); % gabor.pathLengthDegree/2 * cos((subIlluDegree/360)*pi);
%             gaborStartLocMoveXPixel = deg2pix(gaborStartLocMoveXDegree,viewingDistance,screenXpixels,displaywidth);
%             gaborStartLocMoveYPixel = deg2pix(gaborStartLocMoveYDegree,viewingDistance,screenXpixels,displaywidth);
            
            
            % gabor start at the same location whatever the direction of
            % rotation is
            gaborLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel   ...
                + xframeFactor * xframe(frame), yCenter + yframeFactor * yframe(frame));
            
            %----------------------------------------------------------------------
            %                       save the gabor start location
            %----------------------------------------------------------------------
            %             [gaborLoc] = CFSgaborLocCal(gabor,xCenter,yCenter,gaborDistanceFromFixationPixel,viewingDistance,screenXpixels,displaywidth,framerate);
            %             [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborLoc.Start_R);
            %             [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborLoc.Start_L);
            gaborLoc.Start_x = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + xframeFactor * xframe(1);
            gaborLoc.Start_y = yCenter + yframeFactor * yframe(1);
            
          
            %             Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
            %                 kPsychDontDoRotation, gabor.propertiesMatFirst');
            
            % Randomise the phase of the Gabors and make a properties matrix
            gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
            
            %----------------------------------------------------------------------
            %                       CFS location
            %----------------------------------------------------------------------
            % generate CFS size and location from the last frame location of gabor
            % whatever the condition is the CFS field should be same
            frameMax = ceil(gabor.stimulusTime * framerate) - 1;
            %             gaborLocationaCFS = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel  ...
            %                 + xframeFactor * xframe(frameCFS), yCenter +  yframeFactor * yframe(frameCFS));
            
            gaborLoc.End_x = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + xframeFactor * xframe(frameMax);
            gaborLoc.End_y = yCenter +  yframeFactor * yframe(frameMax);
            
            
            % gabor full covered
            if CFScovermark == 'f'
                CFSloca = [gaborLoc.End_x - CFSwidth  gaborLoc.End_y - CFScoverGabor  gaborLoc.Start_x + CFSwidth  gaborLoc.Start_y + CFScoverGabor];
                %   upper edge of CFS is at the center of gabor offset endpoint
            elseif CFScovermark == 'p'
                CFSloca = [gaborLoc.End_x - CFSwidth  gaborLoc.End_y  gaborLoc.Start_x + CFSwidth  gaborLoc.Start_y + CFScoverGabor];
            end
            
            %----------------------------------------------------------------------
            %                       drawTexture for each side of screen
            %----------------------------------------------------------------------
            % randomize the CFS eye
            eye = eyeCFS(blockData(trial,4));
            w = randi(100,1);
            
            % separate main experiment and control experiment
            if expmark == 3   % control binocular rivalry without CFS
                Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                    kPsychDontDoRotation, gabor.propertiesMatFirst');
                
            else  % if expmark == 1 || expmark == 2 
                
                %----------------------------------------------------------------------
                %%%        when expmark == 1|2|4    binocular rivalry
                %----------------------------------------------------------------------
                
                Screen('SelectStereoDrawBuffer', window, eye);  % 0 mean left eye
                %             Screen('DrawTexture',window,backTex);
                Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                    kPsychDontDoRotation, gabor.propertiesMatFirst');
                
                % 4 grey montage control BR
            if expmark == 4
                    
                Screen('SelectStereoDrawBuffer', window, eye);  % 0 mean left eye
                %             Screen('DrawTexture',window,backTex);
                Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                    kPsychDontDoRotation, gabor.propertiesMatFirst');
%                     GreyMontageStartX = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + xframeFactor * xframe(1);
%                     GreyMontageStartY = yCenter + yframeFactor * yframe(1);
%                     frameGreyMon = ceil(gabor.stimulusTime * framerate) - 1;
%                     GreyMontageEndX = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + xframeFactor * xframe(frameGreyMon);
%                     GreyMontageEndY = yCenter + yframeFactor * yframe(frameGreyMon);
%                     
%                     GreyMontageRect = [GreyMontageEndX - CFSwidth    GreyMontageEndY  GreyMontageStartX + CFSwidth  GreyMontageStartY + CFScoverGabor];
%                     
%                     CFSloca = [gaborLoc.End_x - CFSwidth  gaborLoc.End_y  gaborLoc.Start_x + CFSwidth  gaborLoc.Start_y + CFScoverGabor];
  
                    
                    Screen('SelectStereoDrawBuffer', window, eye); % 1 means right eye   CFS
                    if frame <= (ceil(gabor.stimulusTime * framerate) - CFSoffFrame);
                    Screen('FillRect', window, 128, CFSloca);
                    end
%                     Screen('DrawTexture',window,CFSTex(w),[],CFSloca);
                    
%                     Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                end
                
                
                Screen('SelectStereoDrawBuffer', window, 1 - eye); % 1 means right eye   CFS
                Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                %             Screen('DrawTexture',window,backTex);
                % chose what time the CFS disappear
                %             control binocular without CFS
                
                
                if frame > (ceil(gabor.stimulusTime * framerate) - CFSoffFrame); % gabor.sigma
                    Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                else
                    %                     if condition == 'upperRight_rightward'
                    Screen('DrawTexture',window,CFSTex(w),[],CFSloca); % CFSloca_R
                    %                     elseif  condition == 'upperRight_leftward'
                    %                         Screen('DrawTexture',window,CFSTex(w),[],CFSloca_L); % ,CFSloca_L   [154.4633  543.7759  204.4633  593.7759]
                    %                     end
                end
            end
            
            
            % Flip to the screen
            Screen('Flip',window);
        end
        
        %----------------------------------------------------------------------
        %%%                         draw fixation dots
        %----------------------------------------------------------------------
        Screen('SelectStereoDrawBuffer', window, 0);  % 0 mean left eye
        Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
        
        
        Screen('SelectStereoDrawBuffer', window, 1); % 1 means right eye
        Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
        
        
        Screen('Flip',window);
        WaitSecs(barDelay);
        
        %----------------------------------------------------------------------
        %%%                         bar setting
        %----------------------------------------------------------------------
        
        % Now we wait for a keyboard button signaling the observers response.
        % The left arrow key signals a "left" response and the right arrow key
        % a "right" response. You can also press escape if you want to exit the
        % program
        %         if condition == 'upperRight_rightward'
        %             gaborEndLocation_R = gaborLocation;
        %         elseif  condition == 'upperRight_leftward'
        %             gaborEndLocation_L = gaborLocation;
        %         end
        
        t1 = GetSecs;
        respToBeMade = true;
        
        
        barDisFromGaborStartDegNow = barDisFromGaborStartDeg(blockData(trial,3));
        
        
        moveStep = 1;
        while respToBeMade
            %             [gaborLoc.End_R_x, gaborLoc.End_R_y] = findcenter(gaborLocationaCFS);
            
            Screen('SelectStereoDrawBuffer', window, 0);
            %             Screen('Flip',window);
            Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
            Screen('DrawLine', window,blackColor,gaborLoc.End_x + barDisFromGaborStartPix(blockData(trial,3)), gaborLoc.End_y - 15, gaborLoc.End_x + barDisFromGaborStartPix(blockData(trial,3)), gaborLoc.End_y + 15, 2);
            Screen('SelectStereoDrawBuffer', window, 1);
            %             Screen('Flip',window);
            Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
            Screen('DrawLine', window,blackColor,gaborLoc.End_x + barDisFromGaborStartPix(blockData(trial,3)), gaborLoc.End_y - 15, gaborLoc.End_x + barDisFromGaborStartPix(blockData(trial,3)), gaborLoc.End_y + 15, 2);
            
            %             [dstRects,flash] = gaussianDot(gauss.dotSizePix,gauss.Dim,dotXpos,dotYpos,grey,whiteColor,gauss.standDevia,gauss.dotFlag);
            %             Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            %             masktex = Screen('MakeTexture', window, flash);
            %             Screen('DrawTextures', window, masktex,[],dstRects);
            %             %             Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            %             %Screen('DrawDots', window,[dotXpos,   dotYpos], 25, grey+0.1, [],2);
            %
            %             Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
            Screen('Flip',window);
            
            
            
            % the gauss dot could move either horizontally or vertically
            [keyIsDown,secs,keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
                % the bar was on the left of the gabor
            elseif keyCode(leftKey)
                response = 0;   %  origin 1
                respToBeMade = false;
                % the bar was on the right of gabor
            elseif keyCode(rightKey)
                response = 1; % origin 2
                respToBeMade = false;
                % perceived nothing
            elseif keyCode(upKey)
                response = NaN;
                respToBeMade = false;
                % when Gabor break through
            elseif keyCode(spaceKey)
                response = 3;
                respToBeMade = false;
            end
        end
        t2 = GetSecs;
        %         Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
        Screen('SelectStereoDrawBuffer', window, 0);
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('SelectStereoDrawBuffer', window, 1);
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        
        Screen('Flip',window);
        %         WaitSecs(gauss.testDotDelay);
        
        %         Record the response
        responseTime = t2-t1;
        %         all.dotLocaRand = [all.dotLocaRand;dotLocaRand(trial)];
        
        %         all.dotXpos = [all.dotXpos;dotXpos];
        %         all.dotYpos = [all.dotYpos;dotYpos];
        all.responseTimeVector = [all.responseTimeVector;responseTime];
        all.responseVector = [all.responseVector;response];
        all.Trial =  [all.Trial; trial];
        all.Block =[all.Block; block];
        %         conditionAll = gaborMat(gaborMatIndex(1:trialNumber));
        all.condition = [all.condition;condition];
        all.gaborDistanceFromFixationDegree = [all.gaborDistanceFromFixationDegree; gaborDistanceFromFixationDegreeNow];
        %         all.intervalTimesVector = [all.intervalTimesVector;intervalTimes];
        all.orientation = [all.orientation;orientation];
        all.barDisFromGaborStartDeg = [all.barDisFromGaborStartDeg;barDisFromGaborStartDegNow];
        all.eye = [all.eye;eye];
        
        WaitSecs(0.5);
        
        
        
        
    end
end

time = clock;
RespMat = [all.Block all.Trial  all.condition all.gaborDistanceFromFixationDegree all.barDisFromGaborStartDeg all.eye all.responseVector all.responseTimeVector];
if expmark == 1
    savePath = '../../data/CFS/main/'
elseif expmark == 2
    savePath = '../../data/CFS/nointer/'
elseif expmark == 3
    savePath = '../../data/CFS/binocular/'
elseif expmark == 4
    savePath = '../../data/CFS/greyMontage/'
end

fileName = [savePath  subject_name session '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName);



%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;