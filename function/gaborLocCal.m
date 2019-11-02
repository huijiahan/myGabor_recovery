% calculate the gabor start end and cue location by using the parameter but
% the gabor trajactory is crossing in the middle with rotating leftward and rightward

function [gaborLoc] = gaborLocCal(gabor,xCenter,yCenter,gaborDistanceFromFixationPixel,viewingDistance,screenXpixels,displaywidth,framerate,meanSubIlluDegree); % framerate,gabor,xCenter,yCenter,viewingDistance,screenXpixels,displaywidth);

cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);


%----------------------------------------------------------------------
%             calculate gaborLoc - rightward
%----------------------------------------------------------------------
% yframe = [1:gabor.SpeedFrame*cos(subIlluDegree*pi/360):500];
% xframe =  yframe * tan(subIlluDegree*pi/360);
% 
% gaborStartLocMove.XDegree =  (gabor.pathLengthDegree/2)* sin((subIlluDegree/360)*pi);
% gaborStartLocMove.YDegree =  gabor.pathLengthDegree/2 * cos((subIlluDegree/360)*pi);
% gaborStartLocMove.XPixel = deg2pix(gaborStartLocMove.XDegree,viewingDistance,screenXpixels,displaywidth);
% gaborStartLocMove.YPixel = deg2pix(gaborStartLocMove.YDegree,viewingDistance,screenXpixels,displaywidth);

yframe = [1:gabor.SpeedFrame*cos(meanSubIlluDegree(1)*pi/360):500];
xframe =  yframe * tan(meanSubIlluDegree(1)*pi/360);

gaborStartLocMove.XDegree =  (gabor.pathLengthDegree/2)* sin((meanSubIlluDegree(1)/360)*pi);
gaborStartLocMove.YDegree =  gabor.pathLengthDegree/2 * cos((meanSubIlluDegree(1)/360)*pi);
gaborStartLocMove.XPixel = deg2pix(gaborStartLocMove.XDegree,viewingDistance,screenXpixels,displaywidth);
gaborStartLocMove.YPixel = deg2pix(gaborStartLocMove.YDegree,viewingDistance,screenXpixels,displaywidth);


condition_R = 'upperRight_rightward';
[InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
    orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor] ...
    = conditionRandDis_phyloc(condition_R,meanSubIlluDegree);

frame.start = 1;
gaborLoc.Start_R = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel  ...
    + xframeFactor * xframe(frame.start), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.start));

% gaborLoc.Start_R_x = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel + xframeFactor * xframe(frame.start);
% gaborLoc.Start_R_y = yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.start);

frame.end = ceil(gabor.stimulusTime * framerate) - 1;
gaborLoc.End_R = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel  ...
    + xframeFactor * xframe(frame.end), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.end));
% gaborLoc.End_R_x = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel + xframeFactor * xframe(frame.end);
% gaborLoc.End_R_y = yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.end);

gaborLoc.Cue_R = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel,  ...
    yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.end) + cueVerDisPixFactor * cueVerDisPix);
% gaborLoc.Cue_R_x = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel;
% gaborLoc.Cue_R_y = yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.end) + cueVerDisPixFactor * cueVerDisPix;


%----------------------------------------------------------------------
%             calculate gaborLoc - leftward
%----------------------------------------------------------------------
yframe = [1:gabor.SpeedFrame*cos(meanSubIlluDegree(2)*pi/360):500];
xframe =  yframe * tan(meanSubIlluDegree(2)*pi/360);

gaborStartLocMove.XDegree =  (gabor.pathLengthDegree/2)* sin((meanSubIlluDegree(2)/360)*pi);
gaborStartLocMove.YDegree =  gabor.pathLengthDegree/2 * cos((meanSubIlluDegree(2)/360)*pi);
gaborStartLocMove.XPixel = deg2pix(gaborStartLocMove.XDegree,viewingDistance,screenXpixels,displaywidth);
gaborStartLocMove.YPixel = deg2pix(gaborStartLocMove.YDegree,viewingDistance,screenXpixels,displaywidth);


condition_L = 'upperRight_leftward';
[InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
    orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor] ...
    = conditionRandDis_phyloc(condition_L,meanSubIlluDegree);
frame.start = 1;
gaborLoc.Start_L = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel  ...
    + xframeFactor * xframe(frame.start), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.start));

% gaborLoc.Start_L_x = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel + xframeFactor * xframe(frame.start);
% 
% gaborLoc.Start_L_y = gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.start);

frame.end = ceil(gabor.stimulusTime * framerate) - 1;
gaborLoc.End_L = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel  ...
    + xframeFactor * xframe(frame.end), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.end));
% gaborLoc.End_L_x = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel + xframeFactor * xframe(frame.end);
% gaborLoc.End_L_y = yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.end);

gaborLoc.Cue_L = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel,  ...
    yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.end) + cueVerDisPixFactor * cueVerDisPix);
% gaborLoc.Cue_L_x = xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel;
% gaborLoc.Cue_L_y = yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame.end) + cueVerDisPixFactor * cueVerDisPix;
end
