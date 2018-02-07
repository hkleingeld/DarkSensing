clear all
Ton = csvread('single_280cm_30_I1_PD3.txt')';
x = Ton(:,5)
t = 0:1/0.21:50*1/0.21;
x(44:51) = 115;
IIR2_1000 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 6000, 'SampleRate', 210000);
close
hold on

area(t,x,'LineWidth',2,'DisplayName','Raw flash')
h = area(t,filter(IIR2_1000,x),'LineWidth',3,'DisplayName','Filtered flash')
h(1).FaceColor = [1 0.0 0.0];


xlabel('time [\mus]');
ylabel('RSS [adc]');
% legend('show')
xlim([0 49*1/0.21])
ylim([0 2000]);
set(gca,'FontSize', 20)
set(gcf,'position',[0 0 1200 600])
print('2maxes.png','-dpng')

close
x1 = Ton(:,2);
x2 = Ton(:,3);
x3 = Ton(:,4);
x4 = Ton(:,5);
x5 = Ton(:,6);
x1(44:51,:) = 115
x2(44:51,:) = 115
x3(44:51,:) = 115
x4(44:51,:) = 115
x5(44:51,:) = 115


plot(t,x2,'LineWidth',2)
hold on
% xlim([0 49*1/0.21])
% print('f1.png','-dpng')
plot(t,x3,'LineWidth',2)
xlim([0 49*1/0.21])
xlabel('time [\mus]')
ylabel('RSS [adc]')
print('f2.png','-dpng')
close
plot(t,x2-x3,'LineWidth',2)
xlim([0 49*1/0.21])
xlabel('time [\mus]')
ylabel('RSS [adc]')
title('Two flashes')
print('f1-f2.png','-dpng')

close
spacing = zeros(200,1)
spacing(1:200) = 115;
X = [x2 ;x3; x4; x5]
subplot(2,1,2)
set(gcf,'position',[0 0 1200 600])
plot(X)
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
xlim([1 200])
xlabel('Time')
ylabel('RSS [adc]')

subplot(2,1,1)
X2(10:42) = 1;
X2(60:92) = 1;
X2(110:142) = 1;
X2(160:192) = 1;
X2(300) = 0;
plot(X2)
xlim([1 200])
ylim([-0.2 1.2])
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
xlabel('Time')
ylabel('Light intensity')

print('SeveralFlashes_pres','-dpng')