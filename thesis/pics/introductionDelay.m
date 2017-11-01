clear all

simulation_time = 5

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
signal(n/3:n) = 800*(1:0.01/(2*n/3):1.01);

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

subplot(2,2,1)
hold on
plot(sig,'DisplayName','Signal')
plot(mean+std*T,'LineWidth',2,'DisplayName','\mu + 3*\sigma')
plot(mean-std*T,'LineWidth',2,'DisplayName','\mu - 3*\sigma')
axis([150 500 980 1030])
ylabel('Signal strenght','FontSize',12)
legend('show')
title('mean \pm 3*sigma')

subplot(2,2,3)
plot(result,'LineWidth',2,'DisplayName','Detection result')
axis([150 500 -0.5 1.5])
xlabel('Sample number','FontSize',12)
ylabel('Detection','FontSize',12)
legend('show')


std(101:n+100) = std(1:n)
mean(101:n+100)= mean(1:n)

result = (sig(1:n) > (mean(1:n) + T*std(1:n))) | (sig(1:n) < (mean(1:n) - T*std(1:n)));

subplot(2,2,2)
hold on
plot(sig,'DisplayName','Signal')
plot(mean+std*T,'LineWidth',2,'DisplayName','\mu + 3*\sigma')
plot(mean-std*T,'LineWidth',2,'DisplayName','\mu - 3*\sigma')
axis([150 500 980 1030])
ylabel('Signal strenght','FontSize',12)
legend('show')
title('mean \pm 3*sigma with delay = 100')

subplot(2,2,4)
plot(result,'LineWidth',2,'DisplayName','Detection result')
axis([150 500 -0.5 1.5])
xlabel('Sample number','FontSize',12)
ylabel('Detection','FontSize',12)
legend('show')