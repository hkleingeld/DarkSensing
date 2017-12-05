clear all
load('Human Walks By Results')

Human140 = reshape(M(1,1,:,:),[5 31])';
Human160 = reshape(M(1,2,:,:),[5 31])';
Human180 = reshape(M(1,3,:,:),[5 31])';

x = CarL/2:0.5:7.5+CarL
x = [fliplr(-x(2:16)) x]
sig1 = Human180(:,5)
sig2 = Human180(:,1)

sig3 = Human140(:,5)
sig4 = Human140(:,1)

for i = 0:29
    new1(2*i+1) = sig1(i+1)
    new1(2*i+2) = (sig1(i+1) + sig1(i+2))/2
   
    new2(2*i+1) = sig2(i+1)
    new2(2*i+2) = (sig2(i+1) + sig2(i+2))/2
    
    new3(2*i+1) = sig3(i+1)
    new3(2*i+2) = (sig3(i+1) + sig3(i+2))/2
   
    new4(2*i+1) = sig4(i+1)
    new4(2*i+2) = (sig4(i+1) + sig4(i+2))/2
end

% s = v*t
% s/v = t
t = 15 / (5/3.6)
% ts = t/60
ts = t/60
%fs = 1/ts
fs = 1/ts
f = fs./59.*(0:59)

hold on
x = 0:2*7.600/30:2*7.600;
plot(x,Human180(:,5),'DisplayName','H = 1.8, A = 0.5','LineWidth',2)
plot(x,Human180(:,1),'DisplayName','H = 1.8, A = 0.1','LineWidth',2)
plot(x,Human140(:,5),'DisplayName','H = 1.4, A = 0.5','LineWidth',2)
plot(x,Human140(:,1),'DisplayName','H = 1.4, A = 0.1','LineWidth',2)
xlim([0 15])
title('Human on the street')
xlabel('Distance traveled (m)')
ylabel('observed intensity (lx)')
legend('show')
print('Human_street_RSS.png','-dpng')

close
hold on
plot(f,abs(fft(new1)),'DisplayName','H = 1.8, A = 0.5','LineWidth',2)
plot(f,abs(fft(new2)),'DisplayName','H = 1.8, A = 0.1','LineWidth',2)
plot(f,abs(fft(new3)),'DisplayName','H = 1.4, A = 0.5','LineWidth',2)
plot(f,abs(fft(new4)),'DisplayName','H = 1.4, A = 0.1','LineWidth',2)
xlim([0 2.8])
ylim([0 0.02])
title('Frequency spectrum of the received signals')
xlabel('Frequency (Hz)')
ylabel('Relative power')
set(gca,'YTickLabel',[])
legend('show')
print('Human_street_FFT.png','-dpng')
close

copyfile ('Human_street_RSS.png','../../../thesis/pics')
copyfile ('Human_street_FFT.png','../../../thesis/pics')
