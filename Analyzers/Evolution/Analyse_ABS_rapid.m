function result = Analyse_ABS_rapid(x,dataset)

d = x(1);
m = x(2);
z = x(3);
Z = x(4);
T = x(5);
T_offset = x(6);

loc = {'center';'right';'far'};
path = '..\data\Measurements\';

if(dataset == 1)
    name = {('floor\red ');('floor\black ');('floor\green ');('floor\blue ');('floor\grey ')};
end
if(dataset == 2)
    name = {('carpet\red ');('carpet\black ');('carpet\green ');('carpet\blue ');('carpet\grey ')};
end
if(dataset == 3)
    name = {('floor\red ');('floor\black ');('floor\green ');('floor\blue ');('floor\grey ');('carpet\red ');('carpet\black ');('carpet\green ');('carpet\blue ');('carpet\grey ')};
end
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
            lesson = x(1,1);
            x(1,:) = [];
            x = x(:,4);

            while(size(x) < 5000) %repeating several numbers to ensure the signal is at least 5000 samples long (40 seconds)
                x = [x(200:1200);x];
                lesson = lesson + 1000;
            end

            x = filter(IIR2_5,x);
            x = filter(IIR2_01,x);
            n = CalcN(x,3,50,125);
            res = Algorithm_pp(x,n,d,m,z,Z,T,T_offset,lesson);
            
            totres = totres + res;
        end
    end
end
result = NrOfPaths*NrOfcolours*NrOfTries + totres(2) - totres(1);
result = [totres(1) totres(2) (NrOfPaths*NrOfcolours*NrOfTries-result)/(NrOfPaths*NrOfcolours*NrOfTries)];
