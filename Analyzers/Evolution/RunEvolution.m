clear all
% n = N/A, was automated with FFT mode
% d = number of sapmles in D*10
% m = number of sapmles in M*10
% l = detections in a row until true detection
% T = scalefactor /20 (16 becomes T = 3.2)
% k = Offset of the curve

%     d   m   l   L   T   k
LB = [1   1   1   1   10 -10]; %lower bound
UB = [100 100 10  10  100 10]; %upper bound

%     d   m   l   L   T  (for STD algortihm)
%LB = [1   1   1   1   1  ]; %lower bound
%UB = [100 100 10  10  100]; %upper bound

%tbh, no clue what this does, just copy pasted it form the web, it puts up
%a screen which plots the progression of the algorithm
options = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotmaxconstr},'Display','iter');

%100    96     4     5    49     9
%79    98     3     2    53     7
%Run with matlab only (Absolute mode)
[x,fval,exitflag,output,population,scores] = ga(@Evolution_Matlab_Only_ABS,6,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5,6],options)
% S12
%     83    68     5     6    38    -1
%     76    66     6    10    37    -6
%     76    66     7    10    36    -5
% S1
%     41    65     3     9    29     1
%     46    80     4     3    26     5
%     42    33     7     4    28     6
% S2
%     43    57     5     2    60    -5
%     42    47     2     3    65    -7
%     42    47     2     3    65    -7

%Run with matlab only (Standard deviation mode)
%[x,fval,exitflag,output,population,scores] = ga(@Evolution_Matlab_Only_STD,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)
% S12
%     85    35     3     8    23
%     85    35     3     8    23
%     85    35     2     8    23
% S1
%     66    36     1     7    27
%     66    33     5     6    28
%     65    35     3     5    29
% S2
%     75    51     3     9    45
%     75    50     3     8    45
%     75    50     3     8    45