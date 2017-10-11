clear all

% n = number of sapmles in N, if n == 0, then FFT mode
% d = number of sapmles in D
% m = number of sapmles in M
% z = detections in a row until true detection
% T = scalefactor /10 (35 becomes T = 3.5)
%
%     n   d   m   z   T
LB = [0   0   3   1   10 ]; %lower bound
UB = [0   300 800 5   400]; %upper bound

%tbh, no clue what this does, just copy pasted it form the web, it puts up
%a screen which plots the progression of the algorithm
options = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotmaxconstr},'Display','iter');

% Run on Car dataset
[x,fval,exitflag,output,population,scores] = ga(@Evolution,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)

% Run on darkroom dataset
%[x,fval,exitflag,output,population,scores] = ga(@Evolution_darkroom,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)

% Run on outside dataset
%[x,fval,exitflag,output,population,scores] = ga(@Evolution_outside,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)