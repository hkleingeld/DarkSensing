function Fitness = Evolution_darkroom(x)
% 
prog = 'DarkSenseAnalyzer_1.exe';
datapath = '"..\\data\\Measurements\\day\\';
loc = {'close';'center';'far'};
name = {('bjarki ');('danielle ');('erik ');('hajo ');('joris ');('marco ');('rens ');('shashwad ')};
nr = [('1'),('2'),('3'),('4'),('5'),('6')];

N = num2str(x(1));
D = num2str(x(2));
M = num2str(x(3));
Z = num2str(x(4));
T = num2str(x(5)/10);

Fitness = zeros(1,8);
for l = 1:3
    for n = 1:8
        cmd = join([prog strcat(datapath,name(n),loc(l),'\\Result_"') N D M Z T nr(1) nr(6)]);
        Fitness(l,n) = system(char(join(cmd)));
    end
end
Fitness = (3 * 8 * (6-1+1)) -sum(sum(Fitness))
%0 598 11 4 8.2 0.02
end