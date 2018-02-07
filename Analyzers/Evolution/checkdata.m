
% n = x(1);
d = x(1);
m = x(2);
z = x(3);
Z = x(4);
T = x(5)/10;
T_offset = x(6)/10;
[d m z Z T T_offset]

loc = {'center';'right';'far'};
path = '..\data\Measurements\';
%name = {('floor\red ');('floor\black ');('floor\green ');('floor\blue ');('floor\grey ');('carpet\red ');('carpet\black ');('carpet\green ');('carpet\blue ');('carpet\grey ')};
%name = {('floor\red ');('floor\black ');('floor\green ');('floor\blue ');('floor\grey ')};
name = {('carpet\red ');('carpet\black ');('carpet\green ');('carpet\blue ');('carpet\grey ')};

filenr = {'1';'2';'3';'4';'5';'6'};

NrOfPaths = 3;
NrOfcolours = 5;
NrOfTries = 6;

totres = [0 0];

IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 150);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125);

for i = 1:NrOfPaths
    for j = 1:NrOfcolours
        for k = 1:NrOfTries
            file = char(strcat(path,name(j),loc(i),'\result_',filenr(k),'.txt'));
            x = csvread(file);
            lesson = x(1,1);
            x(1,:) = [];
            x = filter(IIR2_5,x(:,4));
            x = filter(IIR2_01,x(:,4));
            n = CalcN(x,3,50,125);
            %result(t,:,i) = result(t,:,i) + AlgorithmSTD(x,100,300,T(t),lesson);
            res = Algorithm_pp(x,n,d,m,z,Z,T,T_offset,lesson);
            totres = totres + res;
        end
    end
end
result = NrOfPaths*NrOfcolours*NrOfTries + totres(2) - totres(1)
