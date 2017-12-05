clear all
load('Car drives By Results')

Lane1 = reshape(M(1,1,:,:),[5 39])'
Lane2 = reshape(M(2,1,:,:),[5 39])'
close
hold on
x = 0:2*7.600/38:2*7.600;

plot(x,Lane1(:,5),'DisplayName','Lane 1, A = 0.5','LineWidth',2)
plot(x,Lane1(:,1),'DisplayName','Lane 1, A = 0.1','LineWidth',2)
% plot(Lane1(:,2),'DisplayName','Lane 1, A = 0.2','LineWidth',2)
% plot(Lane1(:,3),'DisplayName','Lane 1, A = 0.3','LineWidth',2)
% plot(Lane1(:,4),'DisplayName','Lane 1, A = 0.4','LineWidth',2)

plot(x,Lane2(:,5),'DisplayName','Lane 2, A = 0.5','LineWidth',2)
plot(x,Lane2(:,1),'DisplayName','Lane 2, A = 0.1','LineWidth',2)

title('Cars drving on the street')
xlabel('Distance traveled (m)')
ylabel('observed intensity (lx)')
xlim([0 15])
legend('show')
print('Car_street_RSS.png','-dpng')

% s = v*t
% s/v = t
t = 15 / (30/3.6)
% ts = t/39
ts = t/39
%fs = 1/ts
fs = 1/ts
f = fs./39.*(0:38)

close
hold on
plot(f,abs(fft(Lane1(:,5))),'DisplayName','Lane 1, A = 0.5','LineWidth',2)
plot(f,abs(fft(Lane1(:,1))),'DisplayName','Lane 1, A = 0.1','LineWidth',2)
plot(f,abs(fft(Lane2(:,5))),'DisplayName','Lane 2, A = 0.5','LineWidth',2)
plot(f,abs(fft(Lane2(:,1))),'DisplayName','Lane 2, A = 0.1','LineWidth',2)
xlim([0 10])
ylim([0 5])
title('Frequency spectrum of the received signals')
xlabel('Frequency (Hz)')
ylabel('Relative power')
set(gca,'YTickLabel',[])
legend('show')
print('Car_street_FFT.png','-dpng')
close
copyfile ('Car_street_FFT.png','../../../thesis/pics')
copyfile ('Car_street_RSS.png','../../../thesis/pics')



