clear all
%in fdatool, lowpass, Fir, 8th order, chebyshev,sidelobe atten = 100, 
%Fs = 125Hz, Fc = 5Hz
filter = [0.0049    0.0348    0.1126    0.2152    0.2650    0.2152    0.1126    0.0348    0.0049]

simulation_time = 20

ts = 1/200000;
t = 0:ts:simulation_time;

T = 3;

[dc n] = size(t);

mu(1:n) = 0;
sigma(1:n) = 8;

noise  = normrnd(mu,sigma);
ac     = 200 * cos(t*2*pi*100);
dc     = 200;
signal(1:n) = 800;
signal(ceil(n/3):n) = 808;

sig = ac(1:n)+dc+noise(1:n)+signal(1:n);

samples_index = 1:200000/125:simulation_time*200000;
sig = sig(samples_index);
signal = signal(samples_index);

%sig = conv(sig,filter)

m = 300;
n = 1;
d = n + 0;
T = 4;

[mu std N res] = Alg(sig, n, d, m, T)

hold on
plot(mu+T*std)
plot(mu-T*std)
plot(N)
plot(res*10+990,'LineWidth',2)
signal(1:1+d+m) = [];
plot(signal+200,'LineWidth',2)