test1 = csvread('single_65cm_5.txt');
test2 = csvread('single_65cm_10.txt');
test3 = csvread('single_65cm_20.txt');
test4 = csvread('single_65cm_30.txt');

t = 0:1/21*100:1/21*100*49;

%remove 0 in the end
test1(:,51) = [];
test2(:,51) = [];
test3(:,51) = [];
test4(:,51) = [];

x1 = test1(1,:);
x2 = test2(1,:);
x3 = test3(1,:);
x4 = test4(1,:);

hold on

plot(t,x1,'LineWidth',2,'DisplayName','T_o_n = 50\mus')
plot(t,x2,'LineWidth',2,'DisplayName','T_o_n = 100\mus')
plot(t,x3,'LineWidth',2,'DisplayName','T_o_n = 200\mus')
plot(t,x4,'LineWidth',2,'DisplayName','T_o_n = \infty')

xlabel('time [\mus]');
ylabel('RSS [adc]');
title('Influence of T_o_n (I_1 with D = 95cm)')
xlim([0 225])

legend('show')
print('InfluenceOfTon.png','-dpng')
hold off