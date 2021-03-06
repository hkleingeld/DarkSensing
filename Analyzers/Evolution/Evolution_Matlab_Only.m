function res = Evolution_Matlab_Only(x)

n = x(1);
d = x(2);
m = x(3);
z = x(4);
Z = x(5);
T = x(6)/10;

loc = {'close';'center';'far'};
path = '..\data\Measurements\day\';
name = {('bjarki ');('danielle ');('erik ');('joris ');('marco ');('rens ');('shashwad ')};%('hajo ')};

% path = '..\data\Measurements\night\';
% name = {('hajo ');('james ');('joris ');('joris ');('mick ');('timo ')};
filenr = {'1';'2';'3';'4';'5';'6'};

result = zeros(1,2);

s = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 125);

for i = 1:3
    for j = 1:7
        for k = 1:6
            file = char(strcat(path,name(j),loc(i),'\result_',filenr(k),'.txt'));
            x = csvread(file);
            lesson = x(1,1);
            x(1,:) = [];
            x = filter(s,x(:,1));

            result = result + AlgorithmSTD(x,m,d,T,lesson);
            % result = result + Algorithm(x,n,d,m,z,Z,T,lesson);
        end
    end
end

res = 144 - result(1) + result(2);