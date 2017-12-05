clear all
Ton = csvread('ME_FAR.txt')';
Ton_ = csvread('ME_MID.txt')';
IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 125);
IIR_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125)
x3 = Ton_(4,:);
x4 = Ton(4,:);

x3_lp = filter(IIR2_5,x3);
x3_hp = filter(IIR_01,x3_lp);
x3_movavg = movmean(x3_hp, [27 0]);

x4_lp = filter(IIR2_5,x4);
x4_hp = filter(IIR_01,x4_lp);
x4_movavg = movmean(x4_hp, [27 0]);

close
figure('pos',[10 10 550 425/2])
hold on
plot(x3,'DisplayName','Original')
xlim([2000 2600])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
print('Original_good.png','-dpng')

close
figure('pos',[10 10 550 425/2])
hold on
plot(x3,'DisplayName','Original')
plot(x3_lp,'DisplayName','Lowpass','LineWidth',2)
xlim([2000 2600])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
print('lowpass_good.png','-dpng')

close
figure('pos',[10 10 550 425/2])
hold on
plot(x3_lp,'DisplayName','Lowpass','LineWidth',2)
plot(x3_hp,'DisplayName','Highpass + Lowpass','LineWidth',2)
xlim([0 2600])
ylim([-0.5e4 4e4])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
print('highpass_good.png','-dpng')

close
figure('pos',[10 10 550 425/2])
hold on
plot(x3_hp,'DisplayName','Highpass + Lowpass','LineWidth',2)
plot(x3_movavg,'DisplayName','movavg + Highpass + Lowpass','LineWidth',2)
xlim([2000 2600])
ylim([-1000 700])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
print('movavg_good.png','-dpng')

close
figure('pos',[10 10 550 425/2])
hold on
plot(x4,'DisplayName','Original')
xlim([1250 2250])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
print('original_bad.png','-dpng')

close
figure('pos',[10 10 550 425/2])
hold on
plot(x4,'DisplayName','Original')
plot(x4_lp,'DisplayName','Lowpass','LineWidth',2)
xlim([1250 2250])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
print('lowpass_bad.png','-dpng')

close
figure('pos',[10 10 550 425/2])
hold on
plot(x4_lp,'DisplayName','Lowpass','LineWidth',2)
plot(x4_hp,'DisplayName','Hihgpass + Lowpass','LineWidth',2)
xlim([0 2250])
ylim([-0.5e4 4e4])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
print('highpass_bad.png','-dpng')

close
figure('pos',[10 10 550 425/2])
hold on

plot(x4_hp,'DisplayName','Hihgpass + Lowpass','LineWidth',2)
plot(x4_movavg,'DisplayName','Hihgpass + Lowpass','LineWidth',2)
xlim([1250 2250])
ylim([-200 300])
xlabel('Sample number');
ylabel('Extracted measure');
legend('show')
print('movavg_bad.png','-dpng')

% brief results for FS
% method     30_PD3  25_PD3    20_PD3   15_PD3
% filter     51      66        65       39
% max        32      40        38       35
% sum        74      95        75       45
% sumfilter  80      100       105      50

% brief results for FS
% method     30_PD2  25_PD2    20_PD2   15_PD2
% filter     29.9    33        27       20
% max        5       4.8       5        5
% sum        25.2    25.9      20       18
% sumfilter  22.8    23.4      20       19


% brief results for 100 cm (LED1, PD1)
% method      10     15     20     25
% filter      7      4      7      6.3
% max         4      4      4.6    4.8
% sum         8.2    4.2    8.6    8.7
% sumfilter   8.2    4.7    11.8   12.6

% histogram(x4(200:1800),'Normalization','pdf')
% histogram(x4_(200:1800),'Normalization','pdf')

(max(x3(1000:2500)) - min(x3(1000:2500))) / std(x3(1500:2000))
(max(x4(1000:2500) - min(x4(1000:2500)))) / std(x4(500:1000))

(max(x3_lp(1000:2500)) - min(x3_lp(1000:2500))) / std(x3_lp(1500:2000))
(max(x4_lp(1000:2500) - min(x4_lp(1000:2500)))) / std(x4_lp(500:1000))

(max(x3_hp(1000:2500)) - min(x3_hp(1000:2500))) / std(x3_hp(3500:4000))
(max(x4_hp(1000:2500) - min(x4_hp(1000:2500)))) / std(x4_hp(3000:3500))

(max(x3_movavg(1000:2500)) - min(x3_movavg(1000:2500))) / std(x3_movavg(3500:4000))
(max(x4_movavg(1000:2500) - min(x4_movavg(1000:2500)))) / std(x4_movavg(3000:3500))

