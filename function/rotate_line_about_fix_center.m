% rotate a line (originX, originY which is a matrix)  by a fixed center(x_rotaCenter,
% y_rotaCenter which is a dot)  clockwise theta radian
% originX_L = [dotXpos_L_st,dotXpos_L_end];
% originY_L = [dotYpos_L_st,dotYpos_L_end];



function [x_rotated,y_rotated] = rotate_line_about_fix_center(originX,originY,theta,x_rotaCenter,y_rotaCenter);
% create a matrix of these points, which will be useful in future calculations
origin = [originX; originY];

% create a matrix which will be used later in calculations
rotaCenter = repmat([x_rotaCenter; y_rotaCenter], 1, length(origin));

% define a degree counter clockwise rotation matrix
rotate = [cos(theta) -sin(theta); sin(theta) cos(theta)];

% do the rotation...
neworigin = origin - rotaCenter;     % shift points in the plane so that the center of rotation is at the origin
TrajMat = rotate * neworigin;           % apply the rotation about the origin
newTrajMat = TrajMat + rotaCenter;   % shift again so the origin goes back to the desired center of rotation

% pick out the vectors of rotated x- and y-data
x_rotated = newTrajMat(1,:);
y_rotated = newTrajMat(2,:);
end