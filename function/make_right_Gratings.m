function [Grating_Matrix] = make_right_Gratings(disk_radius,pixelsPerPeriod,contrast,GreenLum,tiltInDegrees)
%  Summary of this function goes here
%   Detailed explanation goes here
% GreenLum = 50;
black = 0;%BlackIndex(window);  % Retrieves the CLUT color code for black.
white = 255;%WhiteIndex(window);  % Retrieves the CLUT color code for white.
gray = (black + white) / 2;  % Computes the CLUT color code for gray.
if round(gray)==white
    gray=black;
end

absoluteDifferenceBetweenWhiteAndGray = abs(white - gray);


gridSize =disk_radius+1;

Grating_Matrix=zeros(gridSize,gridSize,3);

[GratingsPhase1 GratingsPhase2] = make_Gratings(disk_radius,pixelsPerPeriod,tiltInDegrees);


LumContrast=contrast; %% the contrast is defined that the 128+-128*contrast, 

%we make a radius gratings , so we need to add a mask(alpha channel) in the
%grating_matrix.

[x y] = meshgrid(-0.5*disk_radius:0.5*disk_radius, -0.5*disk_radius:0.5*disk_radius);

%use the same phase but 


% make the green gratings ,show right eye, while the contrast is different from the red
% gratings .

Grating_Matrix(:,:,1) = 0;        
Grating_Matrix(:,:,2) = LumContrast*GreenLum*(GratingsPhase1)+GreenLum; 
Grating_Matrix(:,:,3) = 0;

Grating_Matrix(:,:,4) = (x.^2+y.^2 <=(0.5*disk_radius)^2)*255;
Grating_Matrix = uint8(Grating_Matrix);



% when make the red and green gratings, we need to get the isoluminance red
% index and green index.

 % load IsoLumColor.mat GreenAmp RedAmp;

% Grating_Matrix{1}(:,:,1) = LumContrast*RedAmp*(GratingsPhase1)+128;         
% Grating_Matrix{1}(:,:,2) = -LumContrast*GreenAmp*(GratingsPhase1)+128;
% Grating_Matrix{1}(:,:,3) = zeros(gridSize,gridSize);
% Grating_Matrix{1} = uint8(Grating_Matrix{1});
% 
% Grating_Matrix{2}(:,:,1) = -LumContrast*RedAmp*(GratingsPhase1)+128;         
% Grating_Matrix{2}(:,:,2) = LumContrast*GreenAmp*(GratingsPhase1)+128;
% Grating_Matrix{2}(:,:,3) = zeros(gridSize,gridSize);
% Grating_Matrix{2} = uint8(Grating_Matrix{2});


end

