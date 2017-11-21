close
test1 = csvread('single_65cm_I1.txt');
test2 = csvread('single_65cm_I2.txt');
test3 = csvread('single_65cm_I3.txt');

t = 0:1/21*100:1/21*100*49;

%remove 0 in the end
test1(:,51) = [];
test2(:,51) = [];
test3(:,51) = [];

x1 = test1(1,:);
x2 = test2(1,:);
x3 = test3(1,:);

hold on

plot(t,x1,'LineWidth',2,'DisplayName','I_1 (R = 1\Omega)');
plot(t,x2,'LineWidth',2,'DisplayName','I_2 (R = 3\Omega)');
plot(t,x3,'LineWidth',2,'DisplayName','I_3 (R = 10\Omega)');

xlabel('time [\mus]');
ylabel('RSS [adc]');
title('Influence of I (D = 65cm)');

legend('show');
print('InfluenceOfI.png','-dpng')
hold off