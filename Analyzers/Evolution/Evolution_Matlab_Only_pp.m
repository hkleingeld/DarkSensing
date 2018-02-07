function result = Evolution_Matlab_Only_pp(x)

% n = x(1);
d = x(1)*10;
m = x(2)*10;
z = x(3);
Z = x(4);
T = x(5)/10*2;
T_offset = x(6)/10*2;
[d m z Z T T_offset]
%[d m z Z T]
loc = {'center';'right';'far'};
path = '..\data\Measurements\';
name = {('floor\red ');('floor\black ');('floor\green ');('floor\blue ');('floor\grey ');('carpet\red ');('carpet\black ');('carpet\green ');('carpet\blue ');('carpet\grey ')};
%name = {('floor\red ');('floor\black ');('floor\green ');('floor\blue ');('floor\grey ')};
%name = {('carpet\red ');('carpet\black ');('carpet\green ');('carpet\blue ');('carpet\grey ')};

filenr = {'1';'2';'3';'4';'5';'6'};

[NrOfPaths dc]   = size(loc);
[NrOfcolours dc] = size(name);
[NrOfTries dc]   = size(filenr);

totres = [0 0];

IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 125);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.2, 'SampleRate', 125);
for i = 1:NrOfPaths
    for j = 1:NrOfcolours
        for k = 1:NrOfTries
            file = char(strcat(path,name(j),loc(i),'\result_',filenr(k),'.txt'));
            x = csvread(file);
            lesson = x(1,1)+2000;
            x(1,:) = [];
            x = [x(1:2000,4);x(:,4)]; %repeating first 1500 numbers to ensure that filter does not influences the data
            x = filter(IIR2_5,x);
            x = filter(IIR2_01,x);
            n = CalcN(x,3,50,125);
            %res = AlgorithmSTD(x,d,m,z,Z,T,lesson);
            res = Algorithm_pp(x,n,d,m,z,Z,T,k,lesson);
            totres = totres + res;
        end
    end
end
result = NrOfPaths*NrOfcolours*NrOfTries + totres(2) - totres(1)
