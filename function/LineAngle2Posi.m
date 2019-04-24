function  [dotXpos_delay,dotYpos_end] = LineAngle2Posi(LineAngle_ave,dotXpos_st,dotYpos_end,lineLengthPixel,colorMap)

% Check number of inputs.
if nargin > 5
    error('LineAngle2Posi:TooManyInputs','requires at most 3 optional inputs');
end

% Fill in unset optional values.
switch nargin
    case 4
        colorMap = [0 0 0];
end

% transfer Line angle to dot X and Y position


for delay = 1:length(LineAngle_ave)
    if LineAngle_ave(delay) > 0
        RealxDis(delay) = lineLengthPixel * tan(LineAngle_ave(delay));
        dotXpos_delay(delay) = dotXpos_st + RealxDis(delay);
    elseif  LineAngle_ave(delay) < 0
        RealxDis(delay) = lineLengthPixel * tan(abs(LineAngle_ave(delay)));
        dotXpos_delay(delay) = dotXpos_st - RealxDis(delay);
    end
    
end


dotYpos_end = repmat(dotYpos_end,sum(LineAngle_ave(:,1)~=0),1)';


end