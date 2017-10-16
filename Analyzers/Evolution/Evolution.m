function Fitness = Evolution(x)
% 
path1 = '"..\\data\\cars\\paper\\black "';
path2 = '"..\\data\\cars\\paper\\red "';
path3 = '"..\\data\\cars\\paper\\silver "';

path4 = '"..\\data\\cars\\stone\\black "';
path5 = '"..\\data\\cars\\stone\\red "';
path6 = '"..\\data\\cars\\stone\\silver "';

prog_1 = 'DarkSenseAnalyzer_1.exe';
prog_2 = 'DarkSenseAnalyzer_2.exe';

N = num2str(x(1));
D = num2str(x(2));
M = num2str(x(3));
Z = num2str(x(4));
T = num2str(x(5)/10);

[prog_1 ' ' path4 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']

Fitness = 0;
% Fitness = Fitness + system([prog_1 ' ' path1 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
% Fitness = Fitness + system([prog_1 ' ' path2 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
% Fitness = Fitness + system([prog_1 ' ' path3 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
% Fitness = Fitness + system([prog_2 ' ' path1 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
% Fitness = Fitness + system([prog_2 ' ' path2 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
% Fitness = Fitness + system([prog_2 ' ' path3 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
Fitness = Fitness + system([prog_1 ' ' path4 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
Fitness = Fitness + system([prog_1 ' ' path5 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
Fitness = Fitness + system([prog_1 ' ' path6 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
Fitness = Fitness + system([prog_2 ' ' path4 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
Fitness = Fitness + system([prog_2 ' ' path5 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
Fitness = Fitness + system([prog_2 ' ' path6 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);

Fitness = -Fitness + 11*6
%0 598 11 4 8.2 0.02
end