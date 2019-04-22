function [GratingsPhase1 GratingsPhase2] = make_Gratings(gratingsize,pixelsPerPeriod,tiltInDegrees)


% *** To rotate the grating, set tiltInDegrees to a new value.
% tiltInDegrees = 0; % The tilt of the grating in degrees.
tiltInRadians = tiltInDegrees * pi / 180; % The tilt of the grating in radians.

% *** To lengthen the period of the grating, increase pixelsPerPeriod.
% pixelsPerPeriod = 50; % How many pixels will each period/cycle occupy?
spatialFrequency = 1 / pixelsPerPeriod; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (3*pi); % = (periods per pixel) * (2 pi radians per period)

% *** If the grating is clipped on the sides, increase widthOfGrid.
widthOfGrid = gratingsize;
 halfWidthOfGrid = widthOfGrid / 2;
widthArray = (- halfWidthOfGrid ) :  halfWidthOfGrid ;  % widthArray is used in creating the meshgrid.


% Retrieves color codes for black and white and gray.
% 	black = 0;  % Retrieves the CLUT color code for black.
% 	white = 255;  % Retrieves the CLUT color code for white.
% 	gray = (black + white) / 2;  % Computes the CLUT color code for gray.
% 	if round(gray)==white
% 		gray=black;
%     end
%     
%     absoluteDifferenceBetweenWhiteAndGray = abs(white - gray);
    
    [x y] = meshgrid(widthArray, widthArray);
    
    a=cos(tiltInRadians)*radiansPerPixel;
	b=sin(tiltInRadians)*radiansPerPixel; 
    
    
  %  gratingMatrix1 = exp(-((x/90).^2)-((y/90).^2)).*sin(a*x+b*y); %the formula get the gabor.
     gratingMatrix1=sin(a*x+b*y);  %get the sin gratings.
  %  gratingMatrix1 =sign(sin(a*x+b*y));
   % use the sign function could change the sin wave to square wave
   %  sign(sin(a*x+b*y))
    imageMatrix1 = gratingMatrix1 .* 1;

    GratingsPhase1 = imageMatrix1;
    
% the gratingMatrix2 is the reverse phase of the gratingMatrix1, these
% matrix is most used to flicker the stimulus,if we don't need the stimulus
% flicker,we just use the gratingMatrix1 is OK.
    
    gratingMatrix2 = sin(a*x+b*y+pi);
    imageMatrix2 = gratingMatrix2 .* 1;
%     grayscaleImageMatrix2 = gray + absoluteDifferenceBetweenWhiteAndGray * imageMatrix2;
    GratingsPhase2 = imageMatrix2;
    

end

