clear all
delay = 0:1/10^5:25/10^5;

f = [25 50 100 200 400]
T = 1./f;

shift = delay'./T * 100

subplot(2,1,1)
shift = shift'
hold on
grid on
plot(0:10:250,shift(1,:),'LineWidth',2,'DisplayName','25Hz')
plot(0:10:250,shift(2,:),'LineWidth',2,'DisplayName','50Hz')
plot(0:10:250,shift(3,:),'LineWidth',2,'DisplayName','100Hz')
plot(0:10:250,shift(4,:),'LineWidth',2,'DisplayName','200Hz')
plot(0:10:250,shift(5,:),'LineWidth',2,'DisplayName','400Hz')
axis([0 100 0 5])
legend('show')


ylabel('Phase shift [%]')
title('Phase shift VS time for PD-PD_d_a_r_k')

subplot(2,1,2)
grid on
hold on
absdiff = (sin(0.5*delay'*2*pi*f) - sin(-0.5*delay'*2*pi*f));
plot(0:10:250,absdiff(:,1),'LineWidth',2,'DisplayName','25Hz')
plot(0:10:250,absdiff(:,2),'LineWidth',2,'DisplayName','50Hz')
plot(0:10:250,absdiff(:,3),'LineWidth',2,'DisplayName','100Hz')
plot(0:10:250,absdiff(:,4),'LineWidth',2,'DisplayName','200Hz')
plot(0:10:250,absdiff(:,5),'LineWidth',2,'DisplayName','400Hz')
xlabel('Time difference PD and PD_d_a_r_k [\mus]')
ylabel('Worst case power ratio')
axis([0 100 0 0.4])
legend('show')
