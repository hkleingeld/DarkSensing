clear all
LB = [0   0   3   1 10 ];
UB = [0   500 800 5 1000];

options = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotmaxconstr},'Display','iter');
%[x,fval,exitflag,output,population,scores] = ga(@Evolution,3,[],[],[],[],LB,UB,@simple_constraint,[1,2,3],options)
[x,fval,exitflag,output,population,scores] = ga(@Evolution_darkroom,5,[],[],[],[],LB,UB,@simple_constraint,[1,2,3,4,5],options)