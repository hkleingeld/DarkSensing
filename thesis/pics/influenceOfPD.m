clear all
Ton1 = csvread('single_280cm_30_I1_PD1.txt')';
Ton2 = csvread('single_280cm_30_I1_PD2.txt')';
Ton2_2 = csvread('single_280cm_30_I3_PD2.txt')';
Ton3 = csvread('single_280cm_30_I1_PD3.txt')';

t = 0:1/0.21:50*1/0.21;

close
hold on
plot(t,Ton1(:,5),'LineWidth',2,'DisplayName','S_P_D_1, I_1')
plot(t,Ton3(:,5),'LineWidth',2,'DisplayName','S_P_D_2, I_1')
plot(t,Ton2(:,5),'LineWidth',2,'DisplayName','S_P_D_3, I_1')
plot(t,Ton2_2(:,5),'LineWidth',2,'DisplayName','S_P_D_3, I_3')

xlabel('time [\mus]');
ylabel('RSS [adc]');
title('Influence of PD (D = 280cm)')
legend('show')
xlim([0 49*1/0.21])

print('InfluenceOfPD.png','-dpng')