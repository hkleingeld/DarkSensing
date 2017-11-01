clear all

%in fdatool, lowpass, Fir, 8th order, chebyshev,sidelobe atten = 100, 
%Fs = 125Hz, Fc = 5Hz
filter = [0.0049    0.0348    0.1126    0.2152    0.2650    0.2152    0.1126    0.0348    0.0049]
mov_Avg(1:100) = 0.01;

simulation_time = 100

ts = 1/200000;
t = 0:ts:simulation_time;

[dc n] = size(t);

mu(1:n) = 0;
sigma(1:n) = 10;

noise  = normrnd(mu,sigma);
PD_PDdark = noise(1:n-1) - noise(2:n);

samples_index = 1:200000/125:simulation_time*200000;

noise = noise(samples_index);
PD_PDdark = PD_PDdark(samples_index);
filterRes = conv(filter,noise);
mov_avg_res= conv(mov_Avg,noise);


[dc n] = size(noise);
xaxis = 0:125/n:125;
xaxis = xaxis(1:12500);
filterRes = filterRes(1:12500);
mov_avg_res = mov_avg_res(1:12500);

subplot(1,2,1)
%plot(xaxis,abs(fft(PD_PDdark)),'DisplayName','PD - PD_d_a_r_k')
hold on
plot(xaxis,abs(fft(noise)),'DisplayName','Unfilterd noise')
plot(xaxis,abs(fft(filterRes)),'DisplayName','Low-pass filter')
plot(xaxis,abs(fft(mov_avg_res)),'k','DisplayName','Moving average (n = 100)')
axis([0 62.5 0 5000])
xlabel('Frequency [Hz]')
ylabel('Amplitude [ADC out]')
title('Frequency response of filtered signals')
legend('show')

subplot(1,2,2)
%histogram(PD_PDdark,'BinEdges',-60:2:60,'Normalization','pdf')
hold on
histogram(noise,'Normalization','pdf','DisplayName','Unfilterd noise')
histogram(filterRes,'Normalization','pdf','DisplayName','Low-pass filter')
histogram(mov_avg_res,'FaceColor','k','Normalization','pdf','DisplayName','Moving average (n = 100)')
axis([-30 30 0 0.55])
title('normalized diviation of filtered signals')
xlabel('diviation from mean [ADC out]')
ylabel('Probability of occurance')
legend('show')
