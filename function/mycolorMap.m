% grnerate my own colormap for plot

function colorMap = mycolorMap(number,rgbmark)
colorMaptemp = [];
colorMap= [];
for gradua = 0:1/(number-1):1
    if rgbmark == 1    % red
        colorMaptemp = [gradua 0 0];
    elseif rgbmark == 2 % yellow
        colorMaptemp = [gradua gradua 0];
    elseif rgbmark == 3  %  gray
        colorMaptemp = [gradua gradua gradua];
    elseif rgbmark == 4  % lake blue
        colorMaptemp = [0 gradua gradua];
    elseif rgbmark == 5   % blue
        colorMaptemp = [0 0 gradua];
    end
    colorMap = cat(1,colorMap,colorMaptemp);
end

