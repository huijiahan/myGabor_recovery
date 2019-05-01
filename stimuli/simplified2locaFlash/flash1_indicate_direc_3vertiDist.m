%% my first gabor drift
% illusion in the 2 different location and 2 directions
% with test gabor change to green flash

%% clear the workspace
close all;
clearvars;
sca;

tic;

name = input('>>>> Participant name (e.g.: AB):  ','s');
subject_name = name;
%----------------------------------------------------------------------
%                      set up Psychtoolbox and skip  sync
%----------------------------------------------------------------------

Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);
% oldEnableFlag=Screen('Preference', 'EmulateOldPTB', [1]);
HideCursor;
commandwindow;
% cd '../function';
% add shared scripts to path
addpath('../../function');

%     Screen('Preference','VisualDebugLevel',1); % warning triangle

% set up screens
screens = Screen('Screens');
screenNumber = max(screens);
% Define black, white and grey
blackcolor = BlackIndex(screenNumber);
whitecolor = WhiteIndex(screenNumber);
grey = whitecolor / 2;


% set the window size
winSize = [0 0 1024 768];   %[0 0 1024 768];


%----------------------------------------------------------------------
%                      open a screen
%----------------------------------------------------------------------

[window winRect] = PsychImaging('OpenWindow',screenNumber,grey,winSize);
[xCenter, yCenter] = RectCenter(winRect);

[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[displaywidth, ~] = Screen('DisplaySize', screenNumber);  %
% Set the text size
Screen('TextSize', window, 40);
framerate = FrameRate(window);
Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
% test = input('Name of the subject:    ');
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
%%%                         experiment loop parameter
%----------------------------------------------------------------------

% Experiment setup
% fprintf('subject_name is',);

trialNumber = 60; % have to triple times of 8 which is the number of the interval time and 9 conditions
blockNumber = 6;

all = RespStartMatrix();

% all the conditions 9
gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};

% interval time between cue and gabor
% intervalTimesMatSingle = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35];   % intervalTime second
intervalTimesMatSingle = [0 0.25 0.5 0.75 1];

% move fixation to left
xCenter = xCenter - gabor.fixationPixel;
yCenter = yCenter;

gaborDistanceFromFixationDegree = [10];   % visual angle degree
cueVerDisDegree = [0 1.5 3.5];

[blockData,subData] = randCondi(gaborDistanceFromFixationDegree,gaborMatSingle,...
    intervalTimesMatSingle,cueVerDisDegree,trialNumber);



%----------------------------------------------------------------------
%%%                         test white flash parameter
%----------------------------------------------------------------------

time.FlashShow = 0.0167;  % 0.2
% Make a vector to record the response for each trial

% flash dot colot of gaussian dot
% dotColor = [0 0.1 0];
dotSizePix = 200;
% gaussDim = 50;
% dot setting
gauss.dotFlag = 2; % 1 is green flash   2 is white flash
gauss.standDevia = 5;% size of the flash
gauss.Dim = round(deg2pix(gabor.VisualAngle,viewingDistance,screenXpixels,displaywidth));

% gaussDimVisualAngle = 5;  % gabor visual angle
% gaussDim = round(deg2pix(gabor.VisualAngle,viewingDistance,screenXpixels,displaywidth));

%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------


for block = 1:blockNumber
    
    for trial = 1: trialNumber
        
        gabor.InternalDriftPhaseIncrPerFrame = gabor.InternalDriftCyclesPerFrame/framerate;
        
        
        % If this is the first trial we present a start screen and wait for a key-press
        if trial == 1
            
            formatSpec = 'This is the %dth of %d block. Press Any Key To Begin';
            A1 = block;
            A2 = blockNumber;
            str = sprintf(formatSpec,A1,A2);
            DrawFormattedText(window, str, 'center', 'center', blackcolor);
            %             DrawFormattedText(window, 'Press Any Key To Begin', 'center', 'center', blackcolor);
            %             fprintf(1,'\tBlock number: %2.0f\n',blockNumber);
            
            Screen('Flip', window);
            KbStrokeWait;
        end
        
        
        condition = string(gaborMatSingle(blockData(trial,2)));
        
        [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
            orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] = conditionRandDis(condition,blockData,trial);
        
        yframe = [1:gabor.SpeedFrame*cos(subIlluDegree*pi/360):500];
        xframe =  yframe * tan(subIlluDegree*pi/360);
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            
            gaborDistanceFromFixationDegreeNow = gaborDistanceFromFixationDegree(blockData(trial,1));
            gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegreeNow,viewingDistance,screenXpixels,displaywidth);
            
            % cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
            
            cueVerDisDegreeNow = cueVerDisDegree(blockData(trial,4));
            cueVerDisPix = deg2pix(cueVerDisDegreeNow,viewingDistance,screenXpixels,displaywidth);
            
            
            % set the middle of the gabor path 7 or 10 dva away from the fixation
            % so the direction of gabor is crossed in the middle of the path
            gaborStartLocMoveXDegree =  (gabor.pathLengthDegree/2)* sin((subIlluDegree/360)*pi);
            gaborStartLocMoveYDegree =  gabor.pathLengthDegree/2 * cos((subIlluDegree/360)*pi);
            gaborStartLocMoveXPixel = deg2pix(gaborStartLocMoveXDegree,viewingDistance,screenXpixels,displaywidth);
            gaborStartLocMoveYPixel = deg2pix(gaborStartLocMoveYDegree,viewingDistance,screenXpixels,displaywidth);
            
            gaborLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
                + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));
            
            cueLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel,  ...
                yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame) + cueVerDisPixFactor * cueVerDisPix);
            %----------------------------------------------------------------------
            %                       save the gabor start location
            %----------------------------------------------------------------------
            
            if frame == 1
                if condition == 'upperRight_rightward'
                    gaborLoc.Start_R = gaborLocation;
                    
                elseif  condition == 'upperRight_leftward'
                    gaborLoc.Start_L = gaborLocation;
                    
                end
            end
           
            
            Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                kPsychDontDoRotation, gabor.propertiesMatFirst');
            
            % Randomise the phase of the Gabors and make a properties matrix
            gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
            %             end
            
            Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
            % Draw fixation
            Screen('DrawDots', window,[xCenter,  yCenter], 10, [255 255 255 255], [], 2);
            
            
            % Flip to the screen
            Screen('Flip',window);
            
            %Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);

        end
        
        
        
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        
        
        intervalTimes = intervalTimesMatSingle(blockData(trial,3));
        WaitSecs(intervalTimes);
        
        
        t0 = GetSecs;
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        %----------------------------------------------------------------------
        %                       save the gabor end location
        %----------------------------------------------------------------------
        
        if condition == 'upperRight_rightward'
            gaborLoc.End_R = gaborLocation;
        elseif  condition == 'upperRight_leftward'
            gaborLoc.End_L = gaborLocation;
        end
        
        if condition == 'upperRight_rightward'
            if cueVerDisDegreeNow == cueVerDisDegree(1)
                gaborLoc.Cue_R.n = cueLocation;
            elseif cueVerDisDegreeNow == cueVerDisDegree(2)
                gaborLoc.Cue_R.m = cueLocation;
            elseif cueVerDisDegreeNow == cueVerDisDegree(3)
                gaborLoc.Cue_R.f = cueLocation;
            end
        elseif  condition == 'upperRight_leftward'
            if cueVerDisDegreeNow == cueVerDisDegree(1)
                gaborLoc.Cue_L.n = cueLocation;
            elseif cueVerDisDegreeNow == cueVerDisDegree(2)
                gaborLoc.Cue_L.m = cueLocation;
            elseif cueVerDisDegreeNow == cueVerDisDegree(3)
                gaborLoc.Cue_L.f = cueLocation;
            end
            %             gaborLoc.Cue_L = cueLocation;
        end
        
        %----------------------------------------------------------------------
        %                       draw test gabor(white flash)
        %----------------------------------------------------------------------
        
        % draw the green gaussian flash at the cue location
        [dotXpos_cue,dotYpos_cue] = findcenter(cueLocation);
        
        Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        [dstRects,flash] = gaussianDot(dotSizePix,gauss.Dim,dotXpos_cue,dotYpos_cue,grey,whitecolor,gauss.standDevia,gauss.dotFlag);
        masktex = Screen('MakeTexture', window, flash);
        %                 Screen('DrawDots', window, [dotXpos_cue dotYpos_cue], dotSizePix, dotColor, [], 2);
        
        % Draw the gaussian apertures  into our full screen aperture mask
        
        Screen('DrawTextures', window, masktex,[],dstRects);
        
        
        Screen('BlendFunction', window, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
        Screen('Flip',window);
        WaitSecs(time.FlashShow);
        
        
        %         Screen('Flip',window);
        % Draw fixation after stimuli in buffer
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        % refresh the screen draw the buffer
        Screen('Flip',window);
        t1 = GetSecs;
        
        
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
                respToBeMade = false;
            elseif keyCode(rightKey)
                response = 0;
                respToBeMade = false;
            end
        end
        t2 = GetSecs;
        %         Record the response
        responseTime = t2-t1;
        %         all.lineAngle = [all.lineAngle;lineAngle];
        all.responseTimeVector = [all.responseTimeVector;responseTime];
        all.responseVector = [all.responseVector;response];
        all.Trial =  [all.Trial; trial];
        all.Block =[all.Block; block];
        %         conditionAll = gaborMat(gaborMatIndex(1:trialNumber));
        all.condition = [all.condition;condition];
        all.gaborDistanceFromFixationDegree = [all.gaborDistanceFromFixationDegree; gaborDistanceFromFixationDegreeNow];
        all.intervalTimesVector = [all.intervalTimesVector;intervalTimes];
        all.cueVerDisDegree = [all.cueVerDisDegree;cueVerDisDegreeNow];
        %         orientationAll = [orientationAll;orientation];
        % trial interval 0.8s
        WaitSecs(0.8);
        
        %     end
        RespMat = [all.Block all.Trial  all.condition all.intervalTimesVector all.gaborDistanceFromFixationDegree all.cueVerDisDegree all.responseVector all.lineAngle all.responseTimeVector];
        
    end
    %----------------------------------------------------------------------
    %                      save parameters files
    %----------------------------------------------------------------------
    %     time = clock;
    %     RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
    %     fileName = ['data/GaborDrift/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
    %     save(fileName,'RespMat','subIlluDegree','intervalTimesVector','InternalDriftCyclesPerSecond','gaborDistanceFromFixationDegree','gaborDimPix','viewingDistance','trialNumber','blockNumber');
    
end


% close(vidObj);

%----------------------------------------------------------------------
%                      save parameters files
%----------------------------------------------------------------------
time = clock;
% RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
fileName = ['../../data/GaborDrift/simplified2loca/flash1_direc_3vertiDist/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName);%,'RespMat','subIlluDegree','intervalTimesVector','cueVerDisDegree','gabor','viewingDistance','trialNumber','blockNumber');


%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;

fprintf(1,'\n\nThis part of the experiment took %.0f min.',(toc)/60);
fprintf(1,'\n\nOK!\n');
