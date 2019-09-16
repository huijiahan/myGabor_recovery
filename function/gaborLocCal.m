function [gaborLoc] = gaborLocCal(gabor,xCenter,yCenter,gaborDistanceFromFixationPixel,viewingDistance,screenXpixels,displaywidth,framerate); % framerate,gabor,xCenter,yCenter,viewingDistance,screenXpixels,displaywidth);


condition_R = 'upperRight_rightward';
[InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
    orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] ...
    = conditionRandDis(condition_R);

cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);

yframe = [1:gabor.SpeedFrame*cos(subIlluDegree*pi/360):500];
xframe =  yframe * tan(subIlluDegree*pi/360);

gaborStartLocMove.XDegree =  (gabor.pathLengthDegree/2)* sin((subIlluDegree/360)*pi);
gaborStartLocMove.YDegree =  gabor.pathLengthDegree/2 * cos((subIlluDegree/360)*pi);
gaborStartLocMove.XPixel = deg2pix(gaborStartLocMove.XDegree,viewingDistance,screenXpixels,displaywidth);
gaborStartLocMove.YPixel = deg2pix(gaborStartLocMove.YDegree,viewingDistance,screenXpixels,displaywidth);




frame = 1;
gaborLoc.Start_R = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel  ...
    + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame));


frame = round(gabor.stimulusTime * framerate) - 1;
gaborLoc.End_R = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel  ...
    + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame));
gaborLoc.Cue_R = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel,  ...
    yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame) + cueVerDisPixFactor * cueVerDisPix);

%----------------------------------------------------------------------
%             calculate gaborLoc - leftward
%----------------------------------------------------------------------
condition_L = 'upperRight_leftward';
[InternalDriftPhaseIncrFactor,xframeFactor,yframeFactor,cueVerDisPixFactor,gaborfixationFactor,...
    orientation,subIlluDegree,gaborStartLocMoveXFactor,gaborStartLocMoveYFactor,meanSubIlluDegree] ...
    = conditionRandDis(condition_L);
frame = 1;
gaborLoc.Start_L = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel  ...
    + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame));

frame = round(gabor.stimulusTime * framerate) - 1;
gaborLoc.End_L = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel  ...
    + xframeFactor * xframe(frame), yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame));
gaborLoc.Cue_L = CenterRectOnPointd(gabor.rect, xCenter  + gaborfixationFactor * gaborDistanceFromFixationPixel + gaborStartLocMoveXFactor * gaborStartLocMove.XPixel,  ...
    yCenter +  gaborStartLocMoveYFactor * gaborStartLocMove.YPixel + yframeFactor * yframe(frame) + cueVerDisPixFactor * cueVerDisPix);
end