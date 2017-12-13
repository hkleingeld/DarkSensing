clear all
Ton = csvread('consec_280cm_20_I1_PD3_me.txt')';
x = Ton(4,1:3600);

IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 6, 'HalfPowerFrequency', 5, 'SampleRate', 125);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 6, 'HalfPowerFrequency', 0.05, 'SampleRate', 125);

n = 33
b(1:n) = 1/n; 

y = filter(IIR2_01, x - mean(x(1:3500)))
% z = conv(y,b)
% a = movstd(z, [199 0])

close
hold on
plot(x,'DisplayName','Original signal')
plot(y,'DisplayName','Filtered signal')
% plot(z,'DisplayName','post mov mean')
% plot(a)


xlim([50 2000])



% plot(z,'DisplayName','Filtered signal')
ylabel('Observed measure')
xlabel('Sample number')
legend('show')
% 
% Rx = (max(x(1600:2000)) - mean(x(500:1500))) / std(x(500:1500))
% Ry = (max(y(1600:2000)) - mean(y(500:1500))) / std(y(500:1500))
% Rz = (max(z(1600:2000)) - mean(z(500:1500))) / std(z(500:1500))

% close
% hold on
% plot(abs(fft(y(100:600)- mean(y(100:600)))))
% plot(abs(fft(z(100:600)- mean(z(100:600)))))
