% RespMat to Line angle ave have to be the data from which response is
% adjustable line

function  [angle_R_all,angle_L_all] = RespMat2LineAngle_ave_forBaseline(RespMat,gaborStartLocation_L,...
    gaborEndLocation_L,gaborStartLocation_R,gaborEndLocation_R,gaborCueLoca_L,gaborCueLoca_R)


[dotXpos_L_st,dotYpos_L_st] = findcenter(gaborStartLocation_L);
[dotXpos_L_end,dotYpos_L_end] = findcenter(gaborEndLocation_L);
[dotXpos_R_st,dotYpos_R_st] = findcenter(gaborStartLocation_R);
[dotXpos_R_end,dotYpos_R_end] = findcenter(gaborEndLocation_R);

[cueXpos_L,cueYpos_L] = findcenter(gaborCueLoca_L);
[cueXpos_R,cueYpos_R] = findcenter(gaborCueLoca_R);


dotLocaXcolumn = 6;
dotLocaYcolumn = 7;
angle_L_all = [];
angle_R_all = [];

for i = 1 : length(RespMat)
    switch RespMat(i,3)
        % left 1   right 0
        % record the apparent motion from real path
        case 'upperRight_leftward'
            opposite_side_L = str2double(RespMat(i,dotLocaXcolumn)) - dotXpos_L_st;
            adjacent_side_L = str2double(RespMat(i,dotLocaYcolumn)) - cueYpos_L;
            angle_L = atan(opposite_side_L/adjacent_side_L);
            angle_L_all = [angle_L_all; angle_L];
            
        case  'upperRight_rightward'
            opposite_side_R = str2double(RespMat(i,dotLocaXcolumn)) - dotXpos_R_st;
            adjacent_side_R = str2double(RespMat(i,dotLocaYcolumn)) - cueYpos_R;
            angle_R = atan(opposite_side_R/adjacent_side_R);
            angle_R_all = [angle_R_all; angle_R];
    end
    
end
end