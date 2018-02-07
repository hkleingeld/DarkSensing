clear all
loc = {'center';'right';'far'};
path = '..\data\Measurements\floor\';
name = {('red ');('black ');('green ');('blue ')};

filenr = {'1';'2';'3';'4';'5';'6'};

NrOfPaths = 3;
NrOfcolours = 2;
NrOfTries = 6;

d = 4*125;
m = 500;
Z = 1;
z = 1;

T = 0:0.1:10;
[dc nrOfT] = size(T);
result = zeros(nrOfT,2,NrOfPaths);

IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 150);
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
                x = filter(IIR2_5,x(:,1));
                x = filter(IIR2_01,x(:,1));
                n = CalcN(x,3,50,125);
                %result(t,:,i) = result(t,:,i) + AlgorithmSTD(x,100,300,T(t),lesson);
                result(t,:,i) = result(t,:,i) + Algorithm_pp(x,n,d,m,z,Z,T(t),0.5,lesson);
            end
        end
    end
    result(t,:,:);
end

ROC = result(:,:,1) + result(:,:,2) + result(:,:,3);
ROC_norm = ROC ./ max(ROC)

ROC_center = result(:,:,1)./max(result(:,:,1));
ROC_right = result(:,:,2)./max(result(:,:,2));
ROC_far = result(:,:,3)./max(result(:,:,3));

hold on
plot(ROC_norm(:,2),ROC_norm(:,1),'LineWidth',2)
plot(ROC_center(:,2),ROC_norm(:,1))
plot(ROC_right(:,2),ROC_norm(:,1))
plot(ROC_far(:,2),ROC_norm(:,1))