IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 150);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125)


x = csvread('GAUSSIAN.txt')';
x2 = csvread('ME_MID.txt')';
y2 = filter(IIR2_5, x2(4,:));
z2 = filter(IIR2_01, y2);
a2 = movmean(z2 ,[27 0])

x2 = x2(4,500:1500)

x4 = x(4,:);
y4 = filter(IIR2_5, x4);
z4 = filter(IIR2_01, y4);
a4 = movmean(z4 ,[27 0])

close
histogram(x4(25000:48183),'Normalization','pdf')
hold on
mu = mean(x4(25000:48183));
sigma = std(x4(25000:48183));
h = 6e-3;
txtoffset = 0.1e-3;

line([mu mu],[0 h],'Color','red','LineWidth',2); text(mu+5,h-txtoffset,'\mu');
line([mu+sigma mu+sigma],[0 h]);text(mu+sigma+5,h-txtoffset,'\mu+\sigma');
line([mu+2*sigma mu+2*sigma],[0 h]); text(mu+2*sigma+5,h-txtoffset,'\mu+2\sigma');
line([mu+3*sigma mu+3*sigma],[0 h]); text(mu+3*sigma+5,h-txtoffset,'\mu+3\sigma');
line([mu+4*sigma mu+4*sigma],[0 h]); text(mu+4*sigma+5,h-txtoffset,'\mu+4\sigma');
line([mu+5*sigma mu+5*sigma],[0 h]); text(mu+5*sigma+5,h-txtoffset,'\mu+5\sigma');
line([mu-1*sigma mu-1*sigma],[0 h]); text(mu-1*sigma+5,h-txtoffset,'\mu-\sigma');
line([mu-2*sigma mu-2*sigma],[0 h]); text(mu-2*sigma+5,h-txtoffset,'\mu-2\sigma');
line([mu-3*sigma mu-3*sigma],[0 h]); text(mu-3*sigma+5,h-txtoffset,'\mu-3\sigma');
xlim([1.665e4 1.76e4]);
xlabel('RSS')
ylabel('Probability')
title('Distribution of PD')
print('distribution_filteredsum.png','-dpng')

close
f = 125/1000.*(0:1000)
plot(f,abs(fft(x2)))
xlim([0 125/2])
ylim([0 4.5e4])
set(gca,'YTickLabel',[])
xlabel('Frequency (Hz)')
ylabel('Relative power')
text(51, 3e4, 'N_5_0_H_z');
text(1, 3e4, 'I_E_d_c');
text(23.25, 1e4, 'I_E_a_c');
text(27.13, 0.7e4, 'I_E_a_c');
title('Frequency spectrum of PD')
print('PSD_original.png','-dpng')



close
f = 125/500.*(0:500)
plot(f,abs(fft(a2(1500:2000))))
xlim([0 30])
xlabel('Frequency (Hz)')
ylabel('Relative power')
set(gca,'YTickLabel',[])
title('Frequency spectrum of PD after filtering')
print('PSD_PostFilters.png','-dpng')

close
histogram(a4(2500:48183),'Normalization','pdf')
xlim([-50 80])
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
