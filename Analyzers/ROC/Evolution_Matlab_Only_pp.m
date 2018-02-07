clear all
loc = {'center';'right';'far'};
path = '..\data\Measurements\';
% name = {('floor\red ');('floor\black ');('floor\green ');('floor\blue ');('floor\grey ')};
% name = {('carpet\red ');('carpet\black ');('carpet\green ');('carpet\blue ');('carpet\grey ')};
name = {('floor\red ');('floor\black ');('floor\green ');('floor\blue ');('floor\grey ');('carpet\red ');('carpet\black ');('carpet\green ');('carpet\blue ');('carpet\grey ')};


filenr = {'1';'2';'3';'4';'5';'6'};

[NrOfPaths dc]   = size(loc);
[NrOfcolours dc] = size(name);
[NrOfTries dc]   = size(filenr);

d = 850;
m = 350;
z = 3;
Z = 8;
T = 0:0.1:10;
T_o = -0.6;
[dc nrOfT] = size(T);
result = zeros(nrOfT,2,NrOfPaths);

IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 125);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125);

for t = 1:nrOfT
    T(t)
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
                b =  AlgorithmSTD(x,d,m,z,Z,T(t),lesson);
                %b = Algorithm_pp(x,n,d,m,z,Z,T(t),T_o,lesson);
                result(t,:,i) = result(t,:,i) + b;
                if(b(2) == 1)
                    b
                end
            end
        end
    end
    result(t,:,:);
end

ROC = result(:,:,1) + result(:,:,2) + result(:,:,3);
TP = ROC(:,1)
FP = ROC(:,2)
TN = NrOfPaths*NrOfcolours*NrOfTries - ROC(:,2);
FN = NrOfPaths*NrOfcolours*NrOfTries - ROC(:,1);

P = TP./(TP+FP)
R = TP./(TP+FN)
% A = (TP + TN) ./ (TP+TN+FP+FN)

hold on
plot(T,P,'LineWidth',2,'DisplayName','Precision')
plot(T,R,'LineWidth',2,'DisplayName','Recall')
% plot(T,A,'LineWidth',2,'DisplayName','Accuracy')
% legend('show')