
d = [350  900]
m = [330 890]
z = [7    5]
Z = [2    7]
T = [3.6  4.2]
k_= [0    -0.2]
[d m z Z T k_]
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


result = 0;
baseline = 0;

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

            baseline = [baseline Algorithm_pp_delay(x,n,d(1),m(1),z(1),Z(1),T(1),k_(1),lesson)];
            result = [result Algorithm_pp_delay(x,n,d(2),m(2),z(2),Z(2),T(2),k_(2),lesson)];
            
        end
    end
end

hold on
plot(baseline - result,'o')