clear all

simulation_time = 3

ts = 1/200000;
t = 0:ts:simulation_time;

diff = 10;
T = 3;

[dc n] = size(t);

mu(1:n) = 0;
sigma(1:n) = 5;

noise  = normrnd(mu,sigma);
ac     = 100* cos(t*2*pi*50);
dc     = 200;
signal(1:n) = 800;
signal(ceil(n/3:n)) = 800*1.005;

%oppertunity one.


%end of oppertunity one.

sig_on = ac(1:n-diff)+dc+noise(1:n-diff)+signal(1:n-diff);
sig_off= ac(1+diff:n)+dc+noise(1+diff:n)+800;

samples_index = 1:200000/125:simulation_time*200000
sig_on = sig_on(samples_index);
sig_off= sig_off(samples_index);

std = movstd(sig_on,[99 0])
mean= movmean(sig_on,[99 0])
result = (sig_on > (mean + T*std)) | (sig_on < (mean - T*std))
figure;
subplot(2,2,1)
hold on
plot(sig_on,'DisplayName','Signal')
plot(mean+std*T,'LineWidth',2,'DisplayName','\mu + T*\sigma')
plot(mean-std*T,'LineWidth',2,'DisplayName','\mu - T*\sigma')
ylabel('Signal strenght','FontSize',12)
legend('show')
axis([1 300 600 1400])
title('Original')

subplot(2,2,3)
plot(result,'LineWidth',2,'DisplayName','Detection result')
axis([1 300 -0.5 1.5])
xlabel('Sample number','FontSize',12)
ylabel('Detection','FontSize',12)
legend('show')

%oppertunity two.
sig = sig_on-sig_off;
[dc n] = size(sig);

std = movstd(sig,[99 0])
mean= movmean(sig,[99 0])
%end of oppertunity two.

result = (sig > (mean + T*std)) | (sig < (mean - T*std))

subplot(2,2,2)
hold on
plot(sig,'DisplayName','Signal')
plot(mean+std*T,'LineWidth',2,'DisplayName','\mu + T*\sigma')
plot(mean-std*T,'LineWidth',2,'DisplayName','\mu - T*\sigma')
axis([1 300 -5 10])
ylabel('Signal strenght','FontSize',12)
legend('show')
title('PD - PD_d_a_r_k, with difference = 10')

subplot(2,2,4)
plot(result,'LineWidth',2,'DisplayName','Detection result')
axis([1 300 -0.5 1.5])
xlabel('Sample number','FontSize',12)
ylabel('Detection','FontSize',12)
legend('show')