clear all
loc = {'close';'center';'far'};
% path = '..\data\Measurements\day\';
% name = {('bjarki ');('danielle ');('erik ');('hajo ');('joris ');('marco ');('rens ');('shashwad ')};

path = '..\data\Measurements\night\';
name = {('hajo ');('james ');('joris ');('joris ');('mick ');('timo ')};
filenr = {'1';'2';'3';'4';'5';'6'};

m = 200;
d = 300; 
T = 1:0.1:10;
[dc nrOfT] = size(T);
result = zeros(nrOfT,2,3);

s = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 125);

for t = 1:nrOfT
    for i = 1:3
        for j = 1:6
            for k = 1:6
                file = char(strcat(path,name(j),loc(i),'\result_',filenr(k),'.txt'));
                x = csvread(file);
                lesson = x(1,1);
                x(1,:) = [];
                x = filter(s,x(:,1));
                
                result(t,:,i) = result(t,:,i) + AlgorithmSTD(x,100,300,T(t),lesson);
%                 result(t,:,i) = result(t,:,i) + Algorithm(x,7,300,800,1,T(t),lesson);
            end
        end
    end
    result(t,:,:)
end
hold on


plot(result(:,2,1)./36,result(:,1,1)/36,'DisplayName','Close')
plot(result(:,2,2)./36,result(:,1,2)/36,'DisplayName','center')
plot(result(:,2,3)./36,result(:,1,3)/36,'DisplayName','far')

plot((result(:,2,1) + result(:,2,2) + result(:,2,3))/144, (result(:,1,1) + result(:,1,2) + result(:,1,3))/108,'DisplayName','all')

legend('show')