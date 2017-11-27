close
test1 = csvread('single_65cm_I2.txt');
test2 = csvread('single_95cm_I2.txt');
test3 = csvread('single_125cm_I2.txt');

t = 0:1/21*100:1/21*100*49;

%remove 0 in the end
test1(:,51) = [];
test2(:,51) = [];
test3(:,51) = [];

x1 = test1(1,:);
x2 = test2(1,:);
x3 = test3(1,:);

hold on

plot(t,x1,'LineWidth',2,'DisplayName','D = 65cm')
plot(t,x2,'LineWidth',2,'DisplayName','D = 95cm')
plot(t,x3,'LineWidth',2,'DisplayName','D = 125cm')

xlabel('time [\mus]');
ylabel('RSS [adc]');
title('Influence of D (with I_2)')
xlim([0 49*1/0.21])
legend('show')
print('InfluenceOfD.png','-dpng')
hold off