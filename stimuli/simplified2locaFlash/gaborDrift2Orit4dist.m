%% my first gabor drift
% illusion in the 8 different location and directions but with the same
% illusion degree at each condition

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
addpath('function');

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
% Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
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

trialNumber = 24; % have to triple times of 8 which is the number of the interval time and 9 conditions
blockNumber = 6;


responseVector = []; %
% Make a vector to record the interval time for each trial
intervalTimesVector = []; % reshape(zeros(trialNumber,blockNumber),[],1);
TrialAll = [];
BlockAll = [];
conditionAll = [];
responseTimeVector=[];
% all the conditions 9
gaborMatSingle = {'upperRight_leftward','upperRight_rightward'};
% gaborMatSingle = {'upperLeft_rightward','lowerLeft_rightward'};
% interval time between cue and gabor
intervalTimesMatSingle = [0 50 100 150 200 250 300 350 400 450 500 550]* 0.001;   % intervalTime second

% gabor location from center in angle  but fixation move left 3 degree [4 5
% 6 7] means [7 8 9 10] dva
gaborDistanceFromFixationDegree = [7];   % visual angle degree
gaborDistanceFromFixationDegreeAll = [];

% trial repeatTimes of each combined condition
repeatTimes = trialNumber/(length(gaborMatSingle)*length(intervalTimesMatSingle)...
        *length(gaborDistanceFromFixationDegree));
% randomized the different conditions 4 locations 8 directions
blockData = [];
k = 0;
factor1 = [1:length(gaborMatSingle)]; % blockData 1
factor2 = [1:length(intervalTimesMatSingle)]; % blockData 2
factor3 = [1:length(gaborDistanceFromFixationDegree)]; % blockData 3
for i1 = 1:length(factor1)
    for i2 = 1:length(factor2)
        for i3 = 1:length(factor3)
            k = k + 1;
            pickupData(k,:) = [factor1(i1),factor2(i2),factor3(i3)];
        end
    end
end
subData = repmat(pickupData,repeatTimes,1);
% blockData = [subData(Shuffle(1:length(subData)),:)];
blockData = subData;


%----------------------------------------------------------------------
%%%                         test gaobor parameter
%----------------------------------------------------------------------

cueShowTime = 0.2;  % 0.2
% Make a vector to record the response for each trial
cueVerDisDegree =  1.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);
% flash dot colot of gaussian dot 
dotColor = [0 1 0];
dotSizePix = 80;
% gaussDim = 50;

gaussDimVisualAngle = 1;  % gabor visual angle
gaussDim = round(deg2pix(gabor.VisualAngle,viewingDistance,screenXpixels,displaywidth));

%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------


for block = 1:blockNumber
    
    
    
    %----------------------------------------------------------------------
    %%%                         stimulus Recording
    %----------------------------------------------------------------------
    % Record the stimulus by frame
    rec = 0;   % Rec = 1 begin recording
    mov.name = 'doubledrift';
    mov.framerate = 60;
    mov.dir = cd;
    mov = recdisplay(rec,mov,'create');
    
    
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
        
        
        condition = string(gaborMatSingle(blockData(trial,1)));
        [InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,...
            gaborfixationFactor,orientation,subIlluDegree] = conditionRand(condition);
        %     if  gabor.SpeedFrame > 0
        yframe = [1:gabor.SpeedFrame:300];
        %     else
        %         yframe = [1:300];
        %     end
        xframe =  yframe * tan(subIlluDegree*pi/360);
        
        
        for frame = 1: (gabor.stimulusTime * framerate)
            
            gaborDistanceFromFixationDegreeNow = gaborDistanceFromFixationDegree(blockData(trial,3));
            gaborDistanceFromFixationPixel = deg2pix(gaborDistanceFromFixationDegreeNow,viewingDistance,screenXpixels,displaywidth);
           
            
            
            gaborLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel  ...
                + xframeFactor * xframe(frame), yCenter +  yframeFactor * yframe(frame));
            cueLocation = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel,  ...
                yCenter + yframeFactor * yframe(frame) + cueVerDisPixFactor * cueVerDisPix);
            
            % at the end of the gabor generate a green flash
%             if frame == round(gabor.stimulusTime * framerate)
%                 dotXpos_gabor = (gaborLocation(1)+gaborLocation(3))/2;
%                 dotYpos_gabor = (gaborLocation(2)+gaborLocation(4))/2;
%                 
%                 [dstRects,flash] = gaussianDot(dotSizePix,gaussDim,dotXpos_gabor,dotYpos_gabor,grey,whitecolor);
%                 % Draw the dot to the screen. For information on the command used in
%                 % this line type "Screen DrawDots?" at the command line (without the
%                 % brackets) and press enter. Here we used good antialiasing to get nice
%                 % smooth edges
%                 %Screen('DrawDots', window, [dotXpos_gabor dotYpos_gabor], gabor.DimPix, dotColor, [], 2);
%                 
%                 % Draw the gaussian apertures  into our full screen aperture mask
%                 masktex = Screen('MakeTexture', window, flash);
%                 Screen('DrawTextures', window, masktex,[],dstRects);
%             else
                
                Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                    kPsychDontDoRotation, gabor.propertiesMatFirst');
                
                % Randomise the phase of the Gabors and make a properties matrix
                gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
%             end
            
            % Draw fixation
            Screen('DrawDots', window,[xCenter - gabor.fixationPixel  yCenter], 10, [255 255 255 255], [], 2);
            
            
            % Flip to the screen
            Screen('Flip',window);
            
            % Record the stimulus by frame
            mov = recdisplay(rec,mov,'record',window);
            
            
            %             gabor.SpeedFrame = gaborMoveSpeedPixel + gabor.SpeedFrame;
        end
        
        
        
        Screen('DrawDots', window,[xCenter - gabor.fixationPixel  yCenter], 10, [255 255 255 255], [], 2);
        Screen('Flip',window);
        
        
        intervalTimes = intervalTimesMatSingle(blockData(trial,2));
        WaitSecs(intervalTimes);
        
        % stimulus recording
        mov = recdisplay(rec,mov,'record',window,intervalTimes);
        t0 = GetSecs;
        Screen('DrawDots', window,[xCenter - gabor.fixationPixel  yCenter], 10, [255 255 255 255], [], 2);
        
       
%         % Draw the cue gabor
        Screen('DrawTextures', window, gabor.tex, [], cueLocation, orientation, [], [], [], [],...
            kPsychDontDoRotation, gabor.propertiesMatFirst');
%         [dstRects,masktex]= gaussianDot[gabor.DimPix, dotXpos,dotYpos];

        %----------------------------------------------------------------------
        %                       draw test gabor(green flash)
        %----------------------------------------------------------------------

              % draw the green gaussian flash at the cue location
%               dotXpos_cue = (cueLocation(1) + cueLocation(3))/2;
%               dotYpos_cue = (cueLocation(2) + cueLocation(4))/2;
%               [dstRects,flash] = gaussianDot(dotSizePix,gaussDim,dotXpos_cue,dotYpos_cue,grey,whitecolor);
%               masktex = Screen('MakeTexture', window, flash);
% %                 Screen('DrawDots', window, [dotXpos_cue dotYpos_cue], dotSizePix, dotColor, [], 2);
%                 
%                 % Draw the gaussian apertures  into our full screen aperture mask
%                 
%                 Screen('DrawTextures', window, masktex,[],dstRects);
                
                
        Screen('Flip',window);
        WaitSecs(cueShowTime);
        
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'record',window,cueShowTime);
        %         Screen('Flip',window);
        % Draw fixation after stimuli in buffer
        Screen('DrawDots', window,[xCenter- gabor.fixationPixel   yCenter], 10, [255 255 255 255], [], 2);
        % refresh the screen draw the buffer
        Screen('Flip',window);
        t1 = GetSecs;
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'record',window,1);
        
        
        
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
        responseTimeVector = [responseTimeVector;responseTime];
        responseVector = [responseVector;response];
        TrialAll =  [TrialAll; trial];
        BlockAll =[BlockAll; block];
        %         conditionAll = gaborMat(gaborMatIndex(1:trialNumber));
        conditionAll = [conditionAll;condition];
        gaborDistanceFromFixationDegreeAll = [gaborDistanceFromFixationDegreeAll; gaborDistanceFromFixationDegreeNow];
        
        intervalTimesVector = [intervalTimesVector;intervalTimes];
        orientationAll = [orientationAll;orientation];
        WaitSecs(1);
        
        %----------------------------------------------------------------------
        %%%                         stimulus Recording
        %----------------------------------------------------------------------
        
        
        %         open(vidObj);
        %         currFrame = Screen('GetImage', window);
        %         writeVideo(vidObj,currFrame);
        %         imageArray = Screen('GetImage', window, [200 264 874 544]);
        %         imageArray = [imageArray; {Screen('GetImage', window, [200 264 874 544])}];
        
        %     end
        
        % Record the stimulus by frame
        mov = recdisplay(rec,mov,'finalize');
        RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector gaborDistanceFromFixationDegreeAll responseVector responseTimeVector];
    end
    %----------------------------------------------------------------------
    %                      save parameters files
    %----------------------------------------------------------------------
    %     time = clock;
    %     RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
    %     fileName = ['data/GaborDrift/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
    %     save(fileName,'RespMat','subIlluDegree','intervalTimesVector','InternalDriftCyclesPerSecond','gaborDistanceFromFixationDegree','gaborDimPix','viewingDistance','trialNumber','blockNumber');
    
% end

toc;
% close(vidObj);

%----------------------------------------------------------------------
%                      save parameters files
%----------------------------------------------------------------------
time = clock;
% RespMat = [BlockAll TrialAll  conditionAll intervalTimesVector  responseVector];
fileName = ['../data/GaborDrift/simplified2loca/' subject_name '-' num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '-' num2str(time(4)) '-' num2str(time(5)) '.mat'];
save(fileName,'RespMat','subIlluDegree','intervalTimesVector','cueVerDisDegree','gabor','viewingDistance','trialNumber','blockNumber');
end

%----------------------------------------------------------------------
%                       clear screen
%----------------------------------------------------------------------

ShowCursor;
Screen('close all');
sca;

fprintf(1,'\n\nThis part of the experiment took %.0f min.',(toc)/60);
fprintf(1,'\n\nOK!\n');
