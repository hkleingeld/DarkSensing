path = '..\data\Measurements\floor\blue right\Result_4.txt';
x = csvread(path)';
x_ = x(4,:);
x_(1) = [];
IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 150);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125);
x1 = filter(IIR2_5, x_);
x2 = filter(IIR2_01, x1);
n = CalcN(x2(2000:2511),3,50,125);

plot(x_)
set(gcf,'position',[0 0 1200 400])
xlim([2300 3100])
xlabel('Sample number');
ylabel('Observed measure');
print('raw_pres.png','-dpng')
close
x2 = movmean(x2, [n-1 0])
plot(x2,'LineWidth',2)
set(gcf,'position',[0 0 1200 400])
ylim([-250 250])
xlim([2300 3100])
xlabel('Sample number');
ylabel('Observed measure');
print('filtered_pres.png','-dpng')
close
hold on

plot(x2,'LineWidth',2)
set(gcf,'position',[0 0 1200 400])
ylim([-250 250])
xlim([2300 3100])
xlabel('Sample number');
ylabel('Observed measure');
Algorithm_pp(x2',1,0,500,1,1,4,0,x(1,1))
print('filtered_pres_2.png','-dpng')
close

plot(x2,'LineWidth',2)
set(gcf,'position',[0 0 1200 400])
ylim([-250 250])
xlim([2300 3100])
xlabel('Sample number');
ylabel('Observed measure');
Algorithm_pp(x2',1,300,500,1,1,4,0,x(1,1))
print('filtered_pres_3.png','-dpng')
