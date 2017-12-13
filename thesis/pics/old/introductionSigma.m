clear all

simulation_time = 3

ts = 1/200000;
t = 0:ts:simulation_time;

T = 3;

[dc n] = size(t);

mu(1:n) = 0;
sigma(1:n) = 4;

noise  = normrnd(mu,sigma);
ac     = 0 * cos(t*2*pi*50);
dc     = 200;
signal(1:n) = 800;
signal(ceil(n/2:n)) = 800*1.01;

%oppertunity one.


%end of oppertunity one.

sig_on = ac(1:n)+dc+noise(1:n)+signal(1:n);

samples_index = 1:200000/125:simulation_time*200000
sig = sig_on(samples_index);

%oppertunity two.
[dc n] = size(sig);

std = movstd(sig,[99 0]);
mean= movmean(sig,[99 0]);
%end of oppertunity two.

result = (sig > (mean + T*std)) | (sig < (mean - T*std));

subplot(2,1,1)
hold on
plot(sig,'DisplayName','Signal')
plot(mean+std*T,'LineWidth',2,'DisplayName','\mu + T*\sigma')
plot(mean-std*T,'LineWidth',2,'DisplayName','\mu - T*\sigma')
axis([1 350 980 1030])
ylabel('Signal strenght','FontSize',12)
legend('show')
title('Original + Filter')

subplot(2,1,2)
plot(result,'LineWidth',2,'DisplayName','Detection result')
axis([1 350 -0.5 1.5])
xlabel('Sample number','FontSize',12)
ylabel('Detection','FontSize',12)
legend('show')