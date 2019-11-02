% calculate the gabor start end and cue location by using the parameter but
% the gabor trajactory is crossing in the middle with rotating leftward and rightward

function [gaborLoc] = CFSgaborLocCal(gabor,xCenter,yCenter,gaborDistanceFromFixationPixel,viewingDistance,screenXpixels,displaywidth,framerate); % framerate,gabor,xCenter,yCenter,viewingDistance,screenXpixels,displaywidth);


condition_R = 'upperRight_rightward';
[InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
    orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] ...
    = conditionRandDis(condition_R);

cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);

yframe = [1:gabor.SpeedFrame*cos(subIlluDegree*pi/360):500];
xframe =  yframe * tan(subIlluDegree*pi/360);


frame = 1;
gaborLoc.Start_R = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel  ...
    + xframeFactor * xframe(frame), yCenter +  yframeFactor * yframe(frame));


frame = ceil(gabor.stimulusTime * framerate) - 1;
gaborLoc.End_R = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel  ...
    + xframeFactor * xframe(frame), yCenter +  yframeFactor * yframe(frame));

%----------------------------------------------------------------------
%             calculate gaborLoc - leftward
%----------------------------------------------------------------------
condition_L = 'upperRight_leftward';
[InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
    orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] ...
    = conditionRandDis(condition_L);
frame = 1;
gaborLoc.Start_L = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel   ...
    + xframeFactor * xframe(frame), yCenter + yframeFactor * yframe(frame));

frame = ceil(gabor.stimulusTime * framerate) - 1;
gaborLoc.End_L = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel  ...
    + xframeFactor * xframe(frame), yCenter + yframeFactor * yframe(frame));


end