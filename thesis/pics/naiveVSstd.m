clear all

simulation_time = 50

ts = 1/200000;
t = 0:ts:simulation_time;

diff = 10;
T = 3;

[dc n] = size(t);

mu(1:n) = 0;
sigma(1:n) = 10;

noise  = normrnd(mu,sigma);
ac     = 0 * cos(t*2*pi*50);
dc     = 30*sin(t*2*pi*0.0025);
signal(1:n) = 800;


%oppertunity one.


%end of oppertunity one.

sig = ac(1:n-diff)+dc(1:n-diff)+noise(1:n-diff)+signal(1:n-diff);

samples_index = 1:200000/125:simulation_time*200000;
sig = sig(samples_index);

[dc nrOfSamples] = size(sig);

minThreshold = zeros([1 nrOfSamples]);
maxThreshold = zeros([1 nrOfSamples]);
result = zeros([1 nrOfSamples]);

maxThreshold(1) = 0;
minThreshold(1) = 9999;

for i = 1:2000 %init (20s)
    maxThreshold(i+1) = max(maxThreshold(i),sig(i));
    minThreshold(i+1) = min(minThreshold(i),sig(i));
end
maxThreshold(1) = [];
minThreshold(1) = [];
maxThreshold(2001:nrOfSamples) = maxThreshold(2000);
minThreshold(2001:nrOfSamples) = minThreshold(2000);

parfor i = 2001:nrOfSamples
    result(i) = (sig(i) > maxThreshold(i)+1) | (sig(i) < minThreshold(i)+1);
end


div = zeros([1 nrOfSamples])
avg_ = movmean(sig,[299 0]);
for i = 2:2000
   DIV = abs(sig(i)-avg_(i));
   div(i) = max(div(i-1), DIV);
end
div(2001:nrOfSamples) = div(2000);

result3 = zeros([1 nrOfSamples])

parfor i = 2001:nrOfSamples
    result3(i) = (sig(i) > avg_(i)+div(i)) | (sig(i) < avg_(i)-div(i));
end


[mu_ std_ N_ result2] = Alg(sig,1,1,300,4);

mu_ = [zeros([1 300]) mu_];
mu_(1:300) = 800;

std_ = [zeros([1 300]) std_];
std_(1:300) = 15;

result2 = [zeros([1 300]) result2];


subplot(3,1,1)
hold on
plot(sig,'DisplayName','signal')
axis([1 5500 750 870])
plot(maxThreshold,'LineWidth',2,'DisplayName','Max threshold')
plot(minThreshold,'LineWidth',2,'DisplayName','Min threshold')
plot(result*30+750,'LineWidth',2,'DisplayName','False positive')
title('Naive threshold, 2000 samples of initiation')
ylabel('RSS','FontSize',12)
legend('show')

subplot(3,1,2)
hold on
plot(sig,'DisplayName','signal')
axis([1 5500 750 870])
plot(avg_,'g','LineWidth',2,'DisplayName','mean')
plot(avg_+div,'LineWidth',2,'DisplayName','Max threshold')
plot(avg_-div,'LineWidth',2,'DisplayName','Min threshold')
plot(result3*30+750,'LineWidth',2,'DisplayName','False positive')

title('Moving threshold, 2000 samples of initiation')
ylabel('RSS','FontSize',12)
legend('show')

subplot(3,1,3)
hold on
plot(sig,'DisplayName','signal')
axis([1 5500 750 870])
plot(mu_+4*std_,'LineWidth',2,'DisplayName','\mu+4\sigma threshold')
plot(mu_-4*std_,'LineWidth',2,'DisplayName','\mu-4\sigma threshold')
plot(result2*30+750,'LineWidth',2,'DisplayName','False positive')

title('Moving standard deviation with m = 300')
xlabel('Sample number','FontSize',12)
ylabel('RSS','FontSize',12)
legend('show')