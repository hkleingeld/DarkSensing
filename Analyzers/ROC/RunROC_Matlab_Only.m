clear all
loc = {'close';'center';'far'};
path = '..\data\Measurements\day\';
name = {('bjarki ');('danielle ');('erik ');('joris ');('marco ');('rens ');('shashwad ')};

% path = '..\data\Measurements\night\';
% name = {('hajo ');('james ');('joris ');('joris ');('mick ');('timo ')};
filenr = {'1';'2';'3';'4';'5';'6'};

NrOfPaths = 3;
NrOfPeople = 7;
NrOfTries = 6;

n = 7;
d = 300; 
m = 300;
Z = 5;
z = 3;

T = 0:0.1:20;
[dc nrOfT] = size(T);
result = zeros(nrOfT,2,3);

s = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 125);

for t = 1:nrOfT
    for i = 1:NrOfPaths
        for j = 1:NrOfPeople
            for k = 1:NrOfTries
                file = char(strcat(path,name(j),loc(i),'\result_',filenr(k),'.txt'));
                x = csvread(file);
                lesson = x(1,1);
                x(1,:) = [];
                x = filter(s,x(:,1));
                
                result(t,:,i) = result(t,:,i) + AlgorithmSTD(x,100,300,T(t),lesson);
                %result(t,:,i) = result(t,:,i) + Algorithm(x,n,d,m,z,Z,T(t),lesson);
            end
        end
    end
    result(t,:,:);
end


TPclose = result(:,1,1);
FPclose = result(:,2,1);
TPcenter = result(:,1,2);
FPcenter = result(:,2,2);
TPfar = result(:,1,3);
FPfar = result(:,2,3);

TP = TPclose + TPcenter + TPfar;
FP = FPclose + FPcenter + FPfar;
FN = NrOfPeople*NrOfTries*NrOfPaths - TP;
TN = NrOfPeople*NrOfTries*NrOfPaths - FP;

% plot(TPclose/(NrOfPeople*NrOfTries),FPclose/(NrOfPeople*NrOfTries),'DisplayName','Close')
% plot(TPcenter/(NrOfPeople*NrOfTries),FPcenter/(NrOfPeople*NrOfTries),'DisplayName','center')
% plot(TPfar/(NrOfPeople*NrOfTries),FPfar/(NrOfPeople*NrOfTries),'DisplayName','far')
subplot(1,2,1);
plot(FP/(NrOfPeople*NrOfTries*NrOfPaths), TP/(NrOfPeople*NrOfTries*NrOfPaths),'DisplayName','ROC')
title('ROC curve')
xlabel('False positive ratio')
ylabel('True positive ratio')
legend('show')

subplot(1,2,2);
hold on
plot(T,TP./(TP+FP),'DisplayName','precision')
plot(T,TP./(TP+FN),'DisplayName','recall')
plot(T,(TP+TN)./(TP+TN+FP+FN),'DisplayName','accuracy')
title('performance')
xlabel('T')
ylabel('Ratio')
legend('show')
