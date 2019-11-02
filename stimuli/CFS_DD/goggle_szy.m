Screen('Preference', 'SkipSyncTests', 1);

stereomode=102;
presentRECT=[];

% Prepare setup of imaging pipeline for onscreen window.
% This is the first step in the sequence of configuration steps.
PsychImaging('PrepareConfiguration');

% PsychImaging('AddTask','General','SideBySideCompressedStereo');
% This mode is useful for driving some auto-stereoscopic displays. These
% use either some vertical parallax barriers or vertical lenticular
% lense sheets. These direct light from even columns to one eye, light
% from odd columns to the other eye.
if stereomode ==102
    PsychImaging('AddTask','General','SideBySideCompressedStereo');
end

% [WindowPtr,  WindowPtrRect.all]  = Screen('OpenWindow',whichScreen,[0 0 0]);
[WindowPtr,  WindowPtrRect.all] = PsychImaging('OpenWindow',whichScreen,0,presentRECT,[],[],stereomode);
Screen('LoadNormalizedGammaTable', WindowPtr, gammaTable);    % 1024 table

AssertOpenGL;

oldVisualDebugLevel   = Screen('Preference', 'VisualDebugLevel', 3);
oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);



Screen('SelectStereoDrawBuffer', WindowPtr, 0);

Screen('DrawTexture', WindowPtr  , FixationDot.txt ,[] ,CenterRect(FixationDot.Rect,WindowPtrRect.all) );
% Screen('FillOval',WindowPtr,[128 0 0],CenterRect(FixationDot.Rect,WindowPtrRect.all));
Screen('DrawTexture', WindowPtr  ,  FixationBar.txt, [] , FixationBar.LeftTopRect);
Screen('DrawTexture', WindowPtr  ,  FixationBar.txt, [] , FixationBar.LeftBotRect);

Screen('SelectStereoDrawBuffer', WindowPtr, 1);

Screen('DrawTexture', WindowPtr  , FixationDot.txt ,[] ,CenterRect(FixationDot.Rect,WindowPtrRect.all) );
Screen('DrawTexture', WindowPtr  ,  FixationBar.txt, [] , FixationBar.RightTopRect);
Screen('DrawTexture', WindowPtr  ,  FixationBar.txt, [] , FixationBar.RightBotRect);
Screen('DrawText', WindowPtr, sprintf('If ready press spacekey.',  WindowPtrRect.all(3)*0.25, 100, [130 130 130]));

%     vbl1 = Screen('Flip', WindowPtr, vbl1 + (2 - 0.5) * rRateInterval);
vbl1 = Screen('Flip', WindowPtr);



