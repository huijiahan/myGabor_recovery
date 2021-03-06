%% my first gabor drift
% illusion in the 2 different directions
% with test gabor and tell the orientation of the adjustable line 

%% clear the workspace
close all;
clearvars;
sca;

tic;

name = input('>>>> Participant name (e.g.: AB):  ','s');
subject_name = name;
%  debug 1  no    debug  2  yes
debug = input('>>>> debug? (e.g.: no debug press n; yes debug press y):  ','s');


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
winSize = [];   %[0 0 1024 768];


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
% Make KbName use shared name mapping of keys between PC and Mac
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
spaceKey = KbName('space');

%----------------------------------------------------------------------
%%%                         experiment loop parameter
%----------------------------------------------------------------------

% Experiment setup
% fprintf('subject_name is',);

trialNumber = 36; % have to triple times of 8 which is the number of the interval time and 9 conditions
blockNumber = 6;
% Response start matrix setting
all = RespStartMatrix();

% all the conditions 9
gaborMatSingle = {'upperRight_rightward','upperRight_leftward'};
% gaborMatSingle = {'upperLeft_rightward','lowerLeft_rightward'};
% interval time between cue and gabor
intervalTimesMatSingle = [0 0.2 0.4 0.6 0.8 1];   % intervalTime second


% gabor location from center in angle  but fixation move left 3 degree [4 5
% 6 7] means [7 8 9 10] dva
xCenter = xCenter - gabor.fixationPixel;
yCenter = yCenter;

gaborDistanceFromFixationDegree = [10];   % visual angle degree


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

if debug == 'n'  % debug 1  no
    blockData = [subData(Shuffle(1:length(subData)),:)];
elseif debug == 'y' % debug 2 no
    blockData = subData;
end


%----------------------------------------------------------------------
%%%                         test flash parameter
%----------------------------------------------------------------------


time.secondFlashShow = 0.0167;  % before 0.2   0.0167 is for one frame
time.lineDelay = 0.9;
% Make a vector to record the response for each trial
cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);
% flash dot colot of gaussian dot
gauss.dotSizePix = 200;
% gaussDim = 50;

% gauss.DimVisualAngle = 5;  % gabor visual angle
gauss.Dim = round(deg2pix(gabor.VisualAngle,viewingDistance,screenXpixels,displaywidth));

% dot setting
gauss.dotFlag = 1; % 1 is green flash
gauss.standDevia = 5;% size of the flash

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
            
            
            % at the end of the gabor generate a green flash
            % N > 0 : round to N digits to the right of the decimal point.
            % so -2 means generate flash for 1 frame
            
                
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
        %        save the gabor end location and cue location
        %----------------------------------------------------------------------
        if condition == 'upperRight_rightward'
            gaborLoc.End_R = gaborLocation;
        elseif  condition == 'upperRight_leftward'
            gaborLoc.End_L = gaborLocation;
        end
        if condition == 'upperRight_rightward'
            gaborLoc.Cue_R = cueLocation;
        elseif  condition == 'upperRight_leftward'
            gaborLoc.Cue_L = cueLocation;
        end
    
    %----------------------------------------------------------------------
    %                       draw test gabor
    %----------------------------------------------------------------------
        
        
        % draw the green gaussian flash at the cue location
        [dotXpos_cue,dotYpos_cue] = findcenter(cueLocation);
%         dotXpos_cue = (cueLocation(1) + cueLocation(3))/2;
%         dotYpos_cue = (cueLocation(2) + cueLocation(4))/2;
        Screen('DrawTextures', window, gabor.tex, [], cueLocation, orientation, [], [], [], [],...
            kPsychDontDoRotation, gabor.propertiesMatFirst');
        
        Screen('Flip',window);
        
        
        WaitSecs(time.secondFlashShow);
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        WaitSecs(time.lineDelay);
        
        
        
        %----------------------------------------------------------------------
        %%%                         adjustable line setting
        %----------------------------------------------------------------------
        
        % Now we wait for a keyboard button signaling the observers response.
        % The left arrow key signals a "left" response and the right arrow key
        % a "right" response. You can also press escape if you want to exit the
        % program
        
        respToBeMade = true;
        AngleStep = pi/360/2; % (1/360)* 2*pi
        % lineAngle is the upper angle between first vertical and the
        % adjusted line "+"  means right "-"  means left
        lineAngle = 0; % (90/360)*2*pi
        lineLengthDegree = cueVerDisDegree;
        lineLengthPixel = deg2pix(lineLengthDegree,viewingDistance,screenXpixels,displaywidth);
        
        %         if blockData(trial,:) == 1
        t1 = GetSecs;
        while respToBeMade
            
            
            Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
            if lineAngle >= 0
                Screen('DrawLine', window,blackcolor,dotXpos_cue, dotYpos_cue, dotXpos_cue + tan(lineAngle)*lineLengthPixel, dotYpos_cue + lineLengthPixel,2);
            elseif lineAngle < 0
                Screen('DrawLine', window,blackcolor,dotXpos_cue, dotYpos_cue, dotXpos_cue - tan(abs(lineAngle))*lineLengthPixel, dotYpos_cue + lineLengthPixel,2);
            end
            Screen('Flip',window);
            
            
            [keyIsDown,secs,keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(leftKey)
                response = 1;
                lineAngle = lineAngle - AngleStep;
            elseif keyCode(rightKey)
                response = 0;
                lineAngle = lineAngle + AngleStep;
            elseif keyCode(spaceKey)
                response = NaN;
                respToBeMade = false;
            end
        end
        Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        WaitSecs(0.3);
        t2 = GetSecs;
        %         Record the response
        responseTime = t2-t1;
        all.lineAngle = [all.lineAngle;lineAngle];
        all.responseTimeVector = [all.responseTimeVector;responseTime];
        all.responseVector = [all.responseVector;response];
        all.Trial =  [all.Trial; trial];
        all.Block =[all.Block; block];
        %         conditionAll = gaborMat(gaborMatIndex(1:trialNumber));
        all.condition = [all.condition;condition];
        all.gaborDistanceFromFixationDegree = [all.gaborDistanceFromFixationDegree; gaborDistanceFromFixationDegreeNow];
        all.intervalTimesVector = [all.intervalTimesVector;intervalTimes];
        %         orientationAll = [orientationAll;orientation];
        WaitSecs(1);
        
        RespMat = [all.Block all.Trial  all.condition all.intervalTimesVector all.gaborDistanceFromFixationDegree all.responseVector all.lineAngle all.responseTimeVector];  %
    end
    
end

toc;
% close(vidObj);


%----------------------------------------------------------------------
%                      save parameters files
%----------------------------------------------------------------------
time = clock;
% RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
fileName = ['../../data/GaborDrift/flash_lineAdjust/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName);


%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;

fprintf(1,'\n\nThis part of the experiment took %.0f min.',(toc)/60);
fprintf(1,'\n\nOK!\n');
