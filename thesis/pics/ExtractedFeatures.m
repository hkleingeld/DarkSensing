clear all
Ton = csvread('single_280cm_30_I1_PD3.txt')';
x = Ton(:,5)
t = 0:1/0.21:50*1/0.21;
x(45:51) = 115;
IIR2_1000 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 6000, 'SampleRate', 210000);
close
hold on

plot(t,x,'LineWidth',2,'DisplayName','Raw flash')
plot(t,filter(IIR2_1000,x),'LineWidth',2,'DisplayName','Filtered flash')
annotation('textarrow',[0.4 0.53],[0.83 0.83],'String','Maximum')
annotation('textarrow',[0.8 0.83],[0.7 0.53],'String','Filtered maximum')

xlabel('time [\mus]');
ylabel('RSS [adc]');
legend('show')
xlim([0 49*1/0.21])
ylim([0 2000]);
print('2maxes.png','-dpng')