clear all
load('Simulation_results')


Human140_L1 = reshape(M(1,1,:,:),[5 43])';
Human160_L1 = reshape(M(1,2,:,:),[5 43])';
Human180_L1 = reshape(M(1,3,:,:),[5 43])';

Human140_L2 = reshape(M(2,1,:,:),[5 43])';
Human160_L2 = reshape(M(2,2,:,:),[5 43])';
Human180_L2 = reshape(M(2,3,:,:),[5 43])';

Human140_L3 = reshape(M(3,1,:,:),[5 43])';
Human160_L3 = reshape(M(3,2,:,:),[5 43])';
Human180_L3 = reshape(M(3,3,:,:),[5 43])';

Human140_L4 = reshape(M(4,1,:,:),[5 43])';
Human160_L4 = reshape(M(4,2,:,:),[5 43])';
Human180_L4 = reshape(M(4,3,:,:),[5 43])';

x = -0.1:0.1:41*0.1;
close
hold on
plot(x,Human180_L1(:,5),'DisplayName','H = 1.8, A = 0.5','LineWidth',2)
plot(x,Human180_L1(:,1),'DisplayName','H = 1.8, A = 0.1','LineWidth',2)
plot(x,Human140_L1(:,5),'DisplayName','H = 1.4, A = 0.5','LineWidth',2)
plot(x,Human140_L1(:,1),'DisplayName','H = 1.4, A = 0.1','LineWidth',2)
title('Human walking in a hallway (y = 0)')
xlabel('Distance traveled (m)')
ylabel('observed intensity (lx)')
xlim([0 4])
legend('show');
print('Human_hallway1_RSS.png','-dpng')

% s = v*t
% s/v = t
t = 4 / (5/3.6)
% ts = t/60
ts = t/43
%fs = 1/ts
fs = 1/ts
f = fs./42.*(0:42)
close
hold on
plot(f,abs(fft(Human180_L1(:,5))),'DisplayName','H = 1.8, A = 0.5','LineWidth',2)
plot(f,abs(fft(Human180_L1(:,1))),'DisplayName','H = 1.8, A = 0.1','LineWidth',2)
plot(f,abs(fft(Human140_L1(:,5))),'DisplayName','H = 1.4, A = 0.5','LineWidth',2)
plot(f,abs(fft(Human140_L1(:,1))),'DisplayName','H = 1.4, A = 0.1','LineWidth',2)
ylim([0 60])
xlim([0 7])
title('Frequency spectrum of the received signals')
xlabel('Frequency (Hz)')
ylabel('Relative power')
set(gca,'YTickLabel',[])
legend('show')
print('Human_hallway1_FFT.png','-dpng')

close
hold on
plot(x,Human180_L4(:,5),'DisplayName','H = 1.8, A = 0.5','LineWidth',2)
plot(x,Human180_L4(:,1),'DisplayName','H = 1.8, A = 0.1','LineWidth',2)
plot(x,Human140_L4(:,5),'DisplayName','H = 1.4, A = 0.5','LineWidth',2)
plot(x,Human140_L4(:,1),'DisplayName','H = 1.4, A = 0.1','LineWidth',2)
title('Human walking in a hallway (y = 0.6)')
xlabel('Distance traveled (m)')
ylabel('observed intensity (lx)')
xlim([0 4])
legend('show');
print('Human_hallway2_RSS.png','-dpng')

close
hold on
plot(f,abs(fft(Human180_L4(:,5))),'DisplayName','H = 1.8, A = 0.5','LineWidth',2)
plot(f,abs(fft(Human180_L4(:,1))),'DisplayName','H = 1.8, A = 0.1','LineWidth',2)
plot(f,abs(fft(Human140_L4(:,5))),'DisplayName','H = 1.4, A = 0.5','LineWidth',2)
plot(f,abs(fft(Human140_L4(:,1))),'DisplayName','H = 1.4, A = 0.1','LineWidth',2)
ylim([0 7])
xlim([0 7])
title('Frequency spectrum of the received signals')
xlabel('Frequency (Hz)')
ylabel('Relative power')
set(gca,'YTickLabel',[])
legend('show')
print('Human_hallway2_FFT.png','-dpng')
close

copyfile ('Human_hallway1_RSS.png','../../../thesis/pics')
copyfile ('Human_hallway1_FFT.png','../../../thesis/pics')
copyfile ('Human_hallway2_RSS.png','../../../thesis/pics')
copyfile ('Human_hallway2_FFT.png','../../../thesis/pics')