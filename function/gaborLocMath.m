% calculate the gabor trajactory and cue position

function [gaborLoc] = gaborLocMath(meanSubIlluDegree,viewingDistance,screenXpixels,displaywidth,gaborLoc);


cueVerDisDegree = 3.5;  % negtive number means higher;   positive number means lower
cueVerDisPix = deg2pix(cueVerDisDegree,viewingDistance,screenXpixels,displaywidth);

% gabor moving path length
gabor.pathLengthDegree = 3.5; % dva
gabor.pathLengthPixel = deg2pix(gabor.pathLengthDegree,viewingDistance,screenXpixels,displaywidth);


if isfield(gaborLoc,'Star_R') == 1
    gaborLoc.Start_R = gaborLoc.Star_R;
end


[gaborLoc.Start_L_x,gaborLoc.Start_L_y] = findcenter(gaborLoc.Start_L);
[gaborLoc.Start_R_x,gaborLoc.Start_R_y] = findcenter(gaborLoc.Start_R);


% 'upperRight_rightward'
gaborLoc.End_L_x = gaborLoc.Start_L_x + sin(ang2radi(meanSubIlluDegree(2)/2)) * gabor.pathLengthPixel;
gaborLoc.End_L_y = gaborLoc.Start_L_y - cos(ang2radi(meanSubIlluDegree(2)/2)) * gabor.pathLengthPixel;

gaborLoc.End_R_x = gaborLoc.Start_R_x - sin(ang2radi(meanSubIlluDegree(1)/2)) * gabor.pathLengthPixel;
gaborLoc.End_R_y = gaborLoc.Start_R_y - cos(ang2radi(meanSubIlluDegree(1)/2)) * gabor.pathLengthPixel;


gaborLoc.Cue_L_x = gaborLoc.Start_L_x;
gaborLoc.Cue_L_y = gaborLoc.Start_L_y -  cos(ang2radi(meanSubIlluDegree(2)/2)) * gabor.pathLengthPixel - cueVerDisPix;

gaborLoc.Cue_R_x = gaborLoc.Start_R_x;
gaborLoc.Cue_R_y = gaborLoc.Start_R_y -  cos(ang2radi(meanSubIlluDegree(1)/2)) * gabor.pathLengthPixel - cueVerDisPix;


end 