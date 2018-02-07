path = '..\data\Measurements\floor\blue right\Result_4.txt';
x = csvread(path)';
x_ = x(4,:);
x_(1) = [];
IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 150);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125);
set(gcf,'position',[0 0 1200 600])
x1 = filter(IIR2_5, x_);
x2 = filter(IIR2_01, x1);
n = CalcN(x2(2000:2511),3,50,125);

Algorithm_pp(x2',n,0,500,1,1,4,0,x(1,1))
xlim([1900 3100])
ylim([-300 600])
xlabel('Sample number');
ylabel('Observed measure');
title('Algorithm with m = 500, T = 4 and d = 0');
legend('show');
print('InfluenceOfD_noD.png','-dpng')
Algorithm_pp(x2',n,300,500,1,1,4,0,x(1,1))
xlim([2600 3100])
ylim([-300 600])
xlabel('Sample number');
ylabel('Observed measure');
title('Algorithm with m = 500, T = 4 and d = 300');
legend('show');
print('InfluenceOfD_withD.png','-dpng')