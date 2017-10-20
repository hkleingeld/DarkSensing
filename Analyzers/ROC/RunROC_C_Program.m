clear all
prog_1 = 'DarkSenseAnalyzer_1_TP.exe';
prog_2 = 'DarkSenseAnalyzer_1_FP.exe';

loc = {'close';'center';'far'};
path = '"..\data\Measurements\day\';
name = {('bjarki ');('danielle ');('erik ');('joris ');('marco ');('rens ');('shashwad ')};

% path = '..\data\Measurements\night\';
% name = {('hajo ');('james ');('joris ');('joris ');('mick ');('timo ')};

n = 0;
m = 800;
d = 300; 
T = 1:0.2:15;
z = 1;

[dc nrOfT] = size(T);
result = zeros(nrOfT,2,3);

N = num2str(n);
D = num2str(d);
M = num2str(m);
Z = num2str(z);

for t = 1:nrOfT
    T_ = num2str(T(t))
    for i = 1:3
        for j = 1:7
            TP = system(char(join(join([prog_1 strcat(path,name(j),loc(i),'\Result_"') N D M Z T_ ' 1 6'],1))));
            FP = system(char(join(join([prog_2 strcat(path,name(j),loc(i),'\Result_"') N D M Z T_ ' 1 6'],1))));
            result(t,:,i) = result(t,:,i) + [TP FP];
        end
    end
    result(t,:,:);
end
hold on


plot(result(:,2,1),result(:,1,1),'DisplayName','Close')
plot(result(:,2,2),result(:,1,2),'DisplayName','center')
plot(result(:,2,3),result(:,1,3),'DisplayName','far')

plot((result(:,2,1) + result(:,2,2) + result(:,2,3)), (result(:,1,1) + result(:,1,2) + result(:,1,3)),'DisplayName','all')

legend('show')