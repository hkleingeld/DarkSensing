clear all
Ton = csvread('consec_280cm_25_I3_PD2.txt')';

IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 125);
x1_PD2 = Ton(1,:);
x2_PD2 = Ton(2,:);
x3_PD2 = Ton(3,:);
x4_PD2 = Ton(4,:);

Ton = csvread('consec_280cm_20_I1_PD3.txt')';
x1_PD3 = Ton(1,:);
x2_PD3 = Ton(2,:);
x3_PD3 = Ton(3,:);
x4_PD3 = Ton(4,:);

hist(x1_PD3(1:1000))
hist(x2_PD3(1:1000))
hist(x3_PD3(1:1000))
hist(x4_PD3(1:1000))



% x1 = filter(IIR2_5,x1)
% x2 = filter(IIR2_5,x2)
% x3 = filter(IIR2_5,x3)
% x4 = filter(IIR2_5,x4)
% x4 = movmean(x4, [20 0])

close
figure('pos',[10 10 550 425/2])
hold on
plot(x2_PD2,'DisplayName','Maximum')
plot(x1_PD2,'DisplayName','Filtered maximum')
xlim([2200 4200])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
title('S_P_D_3, I_3')
print('SNR_simple_PD2.png','-dpng')


close
figure('pos',[10 10 550 425/2])
hold on
plot(x3_PD2,'DisplayName','Sum')
plot(x4_PD2,'DisplayName','Filtered sum')
xlim([2200 4200])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
title('S_P_D_3, I_3')
print('SNR_complex_PD2.png','-dpng')


close
figure('pos',[10 10 550 425/2])
hold on
plot(x2_PD3,'DisplayName','Maximum')
plot(x1_PD3,'DisplayName','Filtered maximum')
xlim([2000 4000])
ylim([700 2700])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show');
title('S_P_D_2, I_1');
print('SNR_simple_PD3.png','-dpng');

close
figure('pos',[10 10 550 425/2])
hold on
plot(x3_PD3,'DisplayName','Sum')
plot(x4_PD3,'DisplayName','Filtered sum')
xlim([2000 4000])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show');
title('S_P_D_2, I_1');
print('SNR_complex_PD3.png','-dpng');

r1 = (max(x1_PD2(1000:3000)) - mean(x1_PD2(500:1500))) /std(x1_PD2(500:1500))
r2 = (max(x2_PD2(1000:3000)) - mean(x2_PD2(500:1500))) /std(x2_PD2(500:1500)) 
r3 = (max(x3_PD2(1000:3000)) - mean(x3_PD2(500:1500))) /std(x3_PD2(500:1500)) 
r4 = (max(x4_PD2(1000:3000)) - mean(x4_PD2(500:1500))) /std(x4_PD2(500:1500))

% brief results for FS
% method     30_PD3  25_PD3    20_PD3   15_PD3
% max        32      40        38       35
% filter     51      66        65       39
% sum        74      95        75       45
% sumfilter  80      100       105      50

% brief results for FS
% method     30_PD2  25_PD2    20_PD2   15_PD2
% max        5       4.8       5        5
% filter     29.9    33        27       20
% sum        25.2    25.9      20       18
% sumfilter  22.8    23.4      20       19


% brief results for 100 cm (LED1, PD1)
% method      10     15     20     25
% filter      7      4      7      6.3
% max         4      4      4.6    4.8
% sum         8.2    4.2    8.6    8.7
% sumfilter   8.2    4.7    11.8   12.6