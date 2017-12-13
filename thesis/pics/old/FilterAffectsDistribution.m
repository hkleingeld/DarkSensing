clear all
close all
%in fdatool, lowpass, Fir, 8th order, chebyshev,sidelobe atten = 100, 
%Fs = 125Hz, Fc = 5Hz
filter = [0.0049    0.0348    0.1126    0.2152    0.2650    0.2152    0.1126    0.0348    0.0049]

simulation_time = 3

ts = 1/200000;
t = 0:ts:simulation_time;

diff = 10;
T = 3;

[dc n] = size(t);

mu(1:n) = 10;
sigma(1:n) = 3;

noise  = normrnd(mu,sigma);
ac     = 2.5+5* cos(t*2*pi*50);
acL    = 1.25+2.5* cos(t*2*pi*200);
dc(1:n)= 200;
signal(1:n) = 0;
sin    = 4* sin(t*2*pi*1);
signal(ceil(1/ts):floor(1/ts+1/ts/2)) = sin(1:ceil(1/ts/2));
signal(floor(1/ts+1/ts/2)-25000:n) = 3;


sig_on = ac(1:n-diff)+dc(1:n-diff)+noise(1:n-diff)+signal(1:n-diff);

samples_index = 1:200000/125:simulation_time*200000;
sig_on = sig_on(samples_index);


subplot(6,1,1)
signal = signal(samples_index);
plot(signal,'LineWidth',2,'DisplayName','signal')
axis([1 250 0 5])
title('I_L * \alpha @125Hz')

subplot(6,1,2)
dc     = dc(samples_index);
plot(dc,'LineWidth',2,'DisplayName','I_E_a_c)')
axis([1 250 150 250])
title('I_E_d_c * \beta @125Hz')

subplot(6,1,3)
acL     = acL(samples_index);
plot(acL,'LineWidth',1,'DisplayName','I_E_a_c)')
axis([1 250 -1 5])
title('I_E_a_c * \beta @125Hz')

subplot(6,1,4)
ac    = ac(samples_index);
plot(ac,'LineWidth',1,'DisplayName','50Hz)')
axis([1 250 -2 7])
title('50Hz @125Hz')

subplot(6,1,5)
noise  = noise(samples_index);
plot(noise,'LineWidth',1,'DisplayName','N(\mu,\sigma)')
axis([1 250 0 20])
title('N(10,3) @125Hz')

subplot(6,1,6)
tot  = signal + noise + dc + ac + acL;
plot(tot,'LineWidth',1,'DisplayName','N(\mu,\sigma)')

title('Complete simulated signal @125Hz')

figure;
subplot(2,1,1)
plot(signal+ac+acL,'DisplayName','signal')
axis([1 250 0 20])
hold on
filtered = conv(signal+ac+acL,filter)
filtered(1:8) = [];
plot(filtered,'LineWidth',2,'DisplayName','Filtered signal')
title('N_5_0_H_z + I_E_a_c @200 Hz (alias = 50Hz)')
ylabel('Amplitude')
legend('show')

subplot(2,1,2)
acL    = 1.25+2.5* cos(t*2*pi*100);
acL    = acL(samples_index);

plot(signal+ac+acL,'DisplayName','signal')
axis([1 250 0 20])
hold on
filtered = conv(signal+ac+acL,filter)
filtered(1:8) = [];
plot(filtered,'LineWidth',2,'DisplayName','Filtered signal')
title('N_5_0_H_z + I_E_a_c @100 Hz (alias = 25Hz)')
xlabel('Sample number')

legend('show')

%histogram(sig_on)
%hold on
%histogram(noise)
%sig_on = conv(sig_on,filter);
%histogram(sig_on)