function initStim3D_noise

global visual scr params design

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Screen  & Stimulus Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------
% Screen information
%--------------------
visual.black = BlackIndex(scr.main);
visual.white = WhiteIndex(scr.main);
% visual.grey = visual.white/2;
visual.bgColor = round((visual.black + visual.white) / 2);       % background color
visual.ppd       = va2pix(1,scr);   % pixel per degree
visual.scrCenter = [scr.centerX scr.centerY scr.centerX scr.centerY];

params.screen.cmx       = scr.width./10;
params.screen.cmy       = scr.height./10;
params.screen.degPerCm  = 57/scr.viewingDist; % vis deg per cm

%---------------------------
% Fixation point information
%---------------------------
params.fix.color = 50;           % color
params.fix.size = 0.2;           % size (width of the dot) in vis deg
params.fix.offset = visual.ppd * [-3,0];      % dva from screen center 
params.fix.JtStd = 0;            % jitter
params.fix.Loc = [scr.centerX scr.centerY] + params.fix.offset + round(randn(1,2)*params.fix.JtStd*visual.ppd);
%---------------------------
% Stimulus information
%---------------------------
params.stim.size = 1;                                            % stim size in vis deg
params.stim.sizepx = round(params.stim.size * visual.ppd);       % stim size in pixels
params.stim.xoffset = 10;         % eccentricity of the trajectory midpoint (degree of visual angle)
params.stim.yoffset = 0;
params.stim.pathAngles = [45,-45];       % stim initial physcial path angle (from vertical to ccw)
params.stim.trajLength = 6 ;     % stim global drift path length   (vis deg) 
params.stim.duration = 3;                                         % stim duration in sec
params.stim.env_speed = params.stim.trajLength ./ params.stim.duration;        % external motion speed dva/sec
params.stim.speedpx = visual.ppd .* params.stim.env_speed .* scr.fd;       % stim global drift (pixel/frame)
params.stim.period = params.stim.trajLength*2 ./ params.stim.env_speed;
params.stim.drifting_speed = 3;                                        % (cycles of the carrier)/sec.

params.stim.contrast = 0.8;        % gabor's contrast [0,1]
params.stim.sf = 1 /visual.ppd;  % spatial frequency of the carrier(cycles per pixel)
params.stim.sigma = 0.15 * visual.ppd;             % sigma of the gaussian envelope (sigma = FWHM / 2.35)
params.stim.motionType = 'triangular';
