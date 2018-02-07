STD1 = [960  890    7   9  4.5    0.2] %p = 1 @ T = 12, P = 97 @ T = 8.6, p = 95@T=6.4
STD2 = [860  980    8   10 5.9    -0.7] %p = 1 @9.2, P=0.95 @6, p = 95 @5.4
STD3 = [870  990    4   4  4.9    0.4]


% Analyse_ABS_rapid(STD1,1)
% Analyse_ABS_rapid(STD1,2)
% Analyse_ABS_rapid(STD1,3)
% 
% Analyse_ABS_rapid(STD2,1)
Analyse_ABS_rapid(STD2,2)
% Analyse_ABS_rapid(STD2,3)
% 
% Analyse_ABS_rapid(STD3,1)
% Analyse_ABS_rapid(STD3,2)
% Analyse_ABS_rapid(STD3,3)

STD1(5) = 12;
Specifics_rapid(STD1,2)

STD1(5) = 8.6;
Specifics_rapid(STD1,2)

STD1(5) = 6.4;
Specifics_rapid(STD1,2)


STD2(5) = 9.2;
Specifics_rapid(STD2,1)

STD2(5) = 6;
Specifics_rapid(STD2,1)

STD2(5) = 5.4;
Specifics_rapid(STD2,1)


