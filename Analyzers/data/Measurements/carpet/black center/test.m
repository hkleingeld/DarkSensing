x = csvread('Result_1.txt')
x = x(:,4)
x(1) = [];
f = 0:125/3000:125-125/3000
plot(f,abs(fft(x(1:3000))))
xlim([0 67.5])
ylim([0 6e4])
text(50.5,5.2e4,'N_5_0_H_z');
text(26.5,2.6e4,'I_E_a_c');
text(0.1,4.5e4,'I_E_d_c');
xlabel('Frequency (Hz)');
ylabel('Relative power');
set(gca,'YTickLabel',[])
set(gca,'fontsize',15)
print('Freqplot_Final_chp.png','-dpng')
close

t = 0:1/125:2999*1/125
plot(t,x(1:3000),'DisplayName', 'Original signal')
xlabel('Time (s)');
ylabel('Observed measure');
set(gca,'fontsize',15)
xlim([0 24])
print('Signal_Final_chp.png','-dpng')


IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 150);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125)
x = filter(IIR2_5,x(1:3000));
x = filter(IIR2_01,x(1:3000));
close
histogram(x(1500:3000),'Normalization','pdf')
hold on
mu = mean(a4(2500:48183));
sigma = std(a4(2500:48183));
h = 0.035;
txtoffset = 0.001;
line([mu mu],[0 h],'Color','red','LineWidth',2); text(mu+1,h-txtoffset,'\mu');
line([mu+sigma mu+sigma],[0 h]);text(mu+sigma+1,h-txtoffset,'\mu+\sigma');
line([mu+2*sigma mu+2*sigma],[0 h]); text(mu+2*sigma+1,h-txtoffset,'\mu+2\sigma');
line([mu+3*sigma mu+3*sigma],[0 h]); text(mu+3*sigma+1,h-txtoffset,'\mu+3\sigma');
line([mu+4*sigma mu+4*sigma],[0 h]); text(mu+4*sigma+1,h-txtoffset,'\mu+4\sigma');
line([mu+5*sigma mu+5*sigma],[0 h]); text(mu+5*sigma+1,h-txtoffset,'\mu+5\sigma');
line([mu-1*sigma mu-1*sigma],[0 h]); text(mu-1*sigma+1,h-txtoffset,'\mu-\sigma');
line([mu-2*sigma mu-2*sigma],[0 h]); text(mu-2*sigma+1,h-txtoffset,'\mu-2\sigma');
line([mu-3*sigma mu-3*sigma],[0 h]); text(mu-3*sigma+1,h-txtoffset,'\mu-3\sigma');

xlabel('RSS')
ylabel('Probability')
title('Distribution of PD after filtering')
print('distribution_filteredsum_PostFilters.png','-dpng')
