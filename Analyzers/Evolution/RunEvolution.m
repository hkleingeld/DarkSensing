clear all
% good seetings found:      0   164   566     2    54 = 15/66


% n = number of sapmles in N, if n == 0, then FFT mode
% d = number of sapmles in D
% m = number of sapmles in M
% z = detections in a row until true detection
% T = scalefactor /10 (35 becomes T = 3.5)
%
%     n   d   m   z   T
LB = [1   0   0   1   1 ]; %lower bound
UB = [1   500 800 1   400]; %upper bound

%tbh, no clue what this does, just copy pasted it form the web, it puts up
%a screen which plots the progression of the algorithm
options = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotmaxconstr},'Display','iter');

% Run on Car dataset
%[x,fval,exitflag,output,population,scores] = ga(@Evolution,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)

% Run on darkroom dataset
%[x,fval,exitflag,output,population,scores] = ga(@Evolution_darkroom,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)

% Run on outside dataset
%[x,fval,exitflag,output,population,scores] = ga(@Evolution_outside,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)

%Run with matlab only
[x,fval,exitflag,output,population,scores] = ga(@Evolution_Matlab_Only,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)