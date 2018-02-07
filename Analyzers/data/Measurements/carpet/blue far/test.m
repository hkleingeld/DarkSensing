clear all
x = csvread('../black far/Result_3.txt');
lesson = x(1:1) + 2000
x(1,:) = [];

x = x(:,4)';
x = [x(1:1000) x(1:1000) x]
plot(x)
set(gcf,'position',[0 0 1200 600])


IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 150);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125)
x = filter(IIR2_5, x)
x = filter(IIR2_01, x)
n = CalcN(x(1500:2000),3,50,125)
x = movmean(x, [n-1 0])
close
plot(x)
hold on

set(gcf,'position',[0 0 1200 600])
xlim([2500 5200])
ylim([-150 150])
print('ROCplot1.png','-dpng')
% print('Thresholds_1.png','-dpng')
c = movmean(x,[999 0])
% plot(c,'LineWidth',2)
plot(movmean(x,[999 0]) + 1 * movstd(x,[999 0]),'m','LineWidth',2)
plot(movmean(x,[999 0]) - 1 * movstd(x,[999 0]),'m','LineWidth',2)

plot(movmean(x,[999 0]) + 2 * movstd(x,[999 0]),'r','LineWidth',2)
plot(movmean(x,[999 0]) - 2 * movstd(x,[999 0]),'r','LineWidth',2)

plot(movmean(x,[999 0]) + 3 * movstd(x,[999 0]),'g','LineWidth',2)
plot(movmean(x,[999 0]) - 3 * movstd(x,[999 0]),'g','LineWidth',2)
% print('Thresholds_2.png','-dpng')
plot(movmean(x,[999 0]) + 4 * movstd(x,[999 0]),'b','LineWidth',2)
plot(movmean(x,[999 0]) - 4 * movstd(x,[999 0]),'b','LineWidth',2)

print('ROCplot2.png','-dpng')

