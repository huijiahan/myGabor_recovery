%% my first gabor drift

% test degree illusion in  8 location across the visual field with
% corresponding oritation

clearvars;
sca;
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
CFScovermark = 'p';   % f = full   p = part
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
blackColor = BlackIndex(screenNumber);
whiteColor = WhiteIndex(screenNumber);
grey = whiteColor/2;
if expmark == 3
    stereoMode = 0;   % 4 for sterroscope   11 for shutter glass  10 second times for test whether covered
else
    stereoMode = 11;
end
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



% conditionFreq = (length(gaborMatSingle)*length(gaborDistanceFromFixationDegree));
% repeatFreq = trialNumber/conditionFreq;

% trial repeatTimes of each combined condition

% repeatTimes = trialNumber/(length(gaborMatSingle) * length(gaborDistanceFromFixationDegree) *...
%     length(barDisFromGaborStartDeg));
% randomized the different conditions 4 locations 8 directions
blockData = [];

[blockData,subData]=randCondi(gaborDistanceFromFixationDegree,gaborMatSingle,...
    barDisFromGaborStartDeg,eyeCFS,trialNumber);

% k = 0;
% factor1 = [1:length(gaborDistanceFromFixationDegree)]; % blockData 1
% factor2 = [1:length(gaborMatSingle)]; % blockData 2
% factor3 = [1:length(barDisFromGaborStartDeg)]; % blockData 3
% for i1 = 1:length(factor1)
%     for i2 = 1:length(factor2)
%         for i3 = 1:length(factor3)
%             k = k + 1;
%             pickupData(k,:) = [factor1(i1),factor2(i2),factor3(i3)];
%         end
%     end
% end
%
% subData = repmat(pickupData,repeatTimes,1);

if debug == 'n'
    blockData = [subData(Shuffle(1:length(subData)),:)];
elseif debug == 'y'
    blockData = subData;
end

% 3 means 3 locations  1 is physical  2 mid 3 perceived location
%  dotLoca = [gaborLocationPhy; gaborEndLocaMid; gaborLocationPerc];
% dotLocaMat = repmat([1; 2; 3],trialNumber/3,1);
% dotLocaRand = dotLocaMat(Shuffle(1:length(dotLocaMat)));

barDelay = 1;
%----------------------------------------------------------------------
%%%                         CFS represented eye
%----------------------------------------------------------------------




%----------------------------------------------------------------------
%%%                     generate  CFS
%----------------------------------------------------------------------
load /Users/jia/Documents/matlab/DD_illusion/myGabor/function/CFS/CFSMatMovie1.mat
% CFSFrequency= 8;
CFSMatMovie=Shuffle(CFSMatMovie);
CFSFrames = 100;
CFSwidth = 30; %30;
CFScoverGabor = 25;
CFScont = 0.8;
CFSoffFrame = 15;

% load CFS images and Make Textures
% CFSsize_scale = 0.8;
% xsize = 256;
% ysize = 256;
% [x2,y2] = meshgrid(-xsize/2:xsize/2-1,-ysize/2:ysize/2-1); % make a axis
% r2 = sqrt(x2.^2+y2.^2);
% % pict = 256*rand(ysize,xsize,3);
% mask2 = r2<xsize/2.*CFSsize_scale;

% pict(:,:,4) = mask2;
% pict(:,:,4) = uint8(pict(:,:,4)*255);
for i=1:CFSFrames
    CFSMatMovie{i} =CFScont*(CFSMatMovie{i}-128)+128;
    CFSImage=CFSMatMovie{i};%.*mask+ContraN;
    %     CFSImage(:,:,4)=mask2*255;
    
    %     CFSImage = CFSImage((256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),(256/2-128*CFSsize_scale):(256/2+128*CFSsize_scale),:);
    CFSTex(i)=Screen('MakeTexture',window,CFSImage);
end


% Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
Screen('SelectStereoDrawBuffer', window, 0);
Screen('FrameOval', window, blackColor, [xCenter - 50 yCenter - 50 xCenter + 50  yCenter + 50], 4);
Screen('SelectStereoDrawBuffer', window, 1);
Screen('FrameOval', window, blackColor, [xCenter - 50 yCenter - 50 xCenter + 50  yCenter + 50], 4);
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
            DrawFormattedText(window, str, 'center', 'center', black);
            Screen('SelectStereoDrawBuffer', window, 1);
            DrawFormattedText(window, str, 'center', 'center', black);
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
            
            gaborStartLocMoveXDegree = gabor.pathLengthDegree * sin((subIlluDegree/360)*pi); % (gabor.pathLengthDegree/2)* sin((subIlluDegree/360)*pi);
            gaborStartLocMoveYDegree = gabor.pathLengthDegree * cos((subIlluDegree/360)*pi); % gabor.pathLengthDegree/2 * cos((subIlluDegree/360)*pi);
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
                    gaborLoc.Start = gaborLoc.Start_R;
                    [dotXpos_R_st,dotYpos_R_st] = findcenter(gaborLoc.Start_R);
                elseif  condition == 'upperRight_leftward'
                    gaborLoc.Start_L = gaborLocation;
                    gaborLoc.Start = gaborLoc.Start_L;
                    [dotXpos_L_st,dotYpos_L_st] = findcenter(gaborLoc.Start_L);
                end
                
                
            end
            
            
            
            %             Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
            %                 kPsychDontDoRotation, gabor.propertiesMatFirst');
            
            % Randomise the phase of the Gabors and make a properties matrix
            gabor.propertiesMatFirst(1) = gabor.propertiesMatFirst(1) + InternalDriftPhaseIncrFactor * gabor.InternalDriftPhaseIncrPerFrame;
            
            %----------------------------------------------------------------------
            %                       CFS location
            %----------------------------------------------------------------------
            % generate CFS size and location from the last frame location of gabor
            frameCFS = round(gabor.stimulusTime * framerate);
            gaborLocationaCFS = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
                + xframeFactor * xframe(frameCFS), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frameCFS));
            if condition == 'upperRight_rightward'
                gaborLoc.End_R = gaborLocationaCFS;
                gaborLoc.End = gaborLoc.End_R;
                [dotXpos_R_end,dotYpos_R_end] = findcenter(gaborLoc.End_R);
                % abor full covered
                if CFScovermark == 'f'
                    CFSloca_R = [dotXpos_R_end - CFSwidth  dotYpos_R_end - CFScoverGabor  dotXpos_R_st + CFSwidth  dotYpos_R_st + CFScoverGabor];
                    %                   Gabor partly covered
                elseif CFScovermark == 'p'
                    CFSloca_R = [dotXpos_R_end - CFSwidth  dotYpos_R_end  dotXpos_R_st + CFSwidth  dotYpos_R_st + CFScoverGabor];
                end
            elseif  condition == 'upperRight_leftward'
                gaborLoc.End_L = gaborLocationaCFS;
                gaborLoc.End = gaborLoc.End_L;
                [dotXpos_L_end,dotYpos_L_end] = findcenter(gaborLoc.End_L);
                if CFScovermark == 'f'
                    CFSloca_L = [dotXpos_L_end - CFSwidth  dotYpos_L_end - CFScoverGabor  dotXpos_L_st + CFSwidth  dotYpos_L_st + CFScoverGabor];
                elseif CFScovermark == 'p'
                    CFSloca_L = [dotXpos_L_end - CFSwidth  dotYpos_L_end  dotXpos_L_st + CFSwidth  dotYpos_L_st + CFScoverGabor];
                end
            end
            
            %             if condition == 'upperRight_rightward'
            %                 gaborLoc.Cue_R = cueLocation;
            %             elseif  condition == 'upperRight_leftward'
            %                 gaborLoc.Cue_L = cueLocation;
            %             end
            
            
            % Draw fixation
            %             Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
            %----------------------------------------------------------------------
            %                       drawTexture for each side of screen
            %----------------------------------------------------------------------
            % randomize the CFS eye
            eye = eyeCFS(blockData(trial,4));
            w = randi(100,1);
            
            % separate main experiment and control experiment
            if expmark == 3
                Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                    kPsychDontDoRotation, gabor.propertiesMatFirst');
            else
                
                Screen('SelectStereoDrawBuffer', window, eye);  % 0 mean left eye
                %             Screen('DrawTexture',window,backTex);
                Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                Screen('DrawTextures', window, gabor.tex, [], gaborLocation, orientation, [], [], [], [],...
                    kPsychDontDoRotation, gabor.propertiesMatFirst');
                % 4 grey montage control BR
                if expmark == 4
                    [GreyMontageStartX,GreyMontageStartY] = findcenter(gaborLoc.Start);
                    [GreyMontageEndX,GreyMontageEndY] = findcenter(gaborLoc.End);
                    GreyMontageRect = [GreyMontageEndX - CFSwidth    GreyMontageEndY  GreyMontageStartX + CFSwidth  GreyMontageStartY + CFScoverGabor];
                    Screen('FillRect', window, 128, GreyMontageRect);
                end
                
                
                Screen('SelectStereoDrawBuffer', window, 1-eye); % 1 means right eye   CFS
                Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                %             Screen('DrawTexture',window,backTex);
                % chose what time the CFS disappear
                %             control binocular without CFS
                
                
                if frame > (round(gabor.stimulusTime * framerate) - CFSoffFrame)
                    Screen('DrawDots', window,[xCenter, yCenter], 10, [255 255 255 255], [], 2);
                else
                    if condition == 'upperRight_rightward'
                        Screen('DrawTexture',window,CFSTex(w),[],CFSloca_R); % CFSloca_R
                    elseif  condition == 'upperRight_leftward'
                        Screen('DrawTexture',window,CFSTex(w),[],CFSloca_L); % ,CFSloca_L   [154.4633  543.7759  204.4633  593.7759]
                    end
                end
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
        
        % set 3 conditions of perceived location test dot
        %         gaborLocationPhy = gaborLocation;
        %         gaborLocationPerc = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
        %             - xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));
        %         gaborEndLocaMid = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMoveXPixel  ...
        %             , yCenter +  gaborStartLocMoveYFactor * gaborStartLocMoveYPixel + yframeFactor * yframe(frame));
        %
        %         dotLoca = [gaborLocationPhy; gaborEndLocaMid; gaborLocationPerc];
        %
        %
        %         [dotXpos,dotYpos] = findcenter(dotLoca(dotLocaRand(trial),:));
        
        barDisFromGaborStartDegNow = barDisFromGaborStartDeg(blockData(trial,3));
        
        
        moveStep = 1;
        while respToBeMade
            [gaborLoc.End_R_x, gaborLoc.End_R_y] = findcenter(gaborLocationaCFS);
            
            Screen('SelectStereoDrawBuffer', window, 0);
            %             Screen('Flip',window);
            Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
            Screen('DrawLine', window,blackColor,gaborLoc.End_R_x + barDisFromGaborStartPix(blockData(trial,3)), gaborLoc.End_R_y - 15, gaborLoc.End_R_x + barDisFromGaborStartPix(blockData(trial,3)), gaborLoc.End_R_y + 15, 2);
            Screen('SelectStereoDrawBuffer', window, 1);
            %             Screen('Flip',window);
            Screen('DrawDots', window,[xCenter,   yCenter], 10, [255 255 255 255], [], 2);
            Screen('DrawLine', window,blackColor,gaborLoc.End_R_x + barDisFromGaborStartPix(blockData(trial,3)), gaborLoc.End_R_y - 15, gaborLoc.End_R_x + barDisFromGaborStartPix(blockData(trial,3)), gaborLoc.End_R_y + 15, 2);
            
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