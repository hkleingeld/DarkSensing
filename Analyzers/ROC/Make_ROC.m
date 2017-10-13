res1 = ROC_Curve_outside(0,0,800,1)
res1(:,2) = res1(:,2) / 66;
res1(:,3) = res1(:,3) / 66;

res2 = ROC_Curve_outside(0,0,800,2)
res2(:,2) = res2(:,2) / 66;
res2(:,3) = res2(:,3) / 66;

res3 = ROC_Curve_outside(0,0,800,3)
res3(:,2) = res3(:,2) / 66;
res3(:,3) = res3(:,3) / 66;

res4 = ROC_Curve_outside(0,0,800,4)
res4(:,2) = res4(:,2) / 66;
res4(:,3) = res4(:,3) / 66;

hold on
plot(res1(:,3),res1(:,2),'LineWidth',2,'DisplayName','z = 1')
plot(res2(:,3),res2(:,2),'LineWidth',2,'DisplayName','z = 2')
plot(res3(:,3),res3(:,2),'LineWidth',2,'DisplayName','z = 3')
plot(res4(:,3),res4(:,2),'LineWidth',2,'DisplayName','z = 4')


% hold on
% plot(res1(:,3),res1(:,2),'LineWidth',2,'DisplayName','n = 1')
% plot(res2(:,3),res2(:,2),'LineWidth',2,'DisplayName','n = 25')
% plot(res3(:,3),res3(:,2),'LineWidth',2,'DisplayName','n = 50')
% plot(res4(:,3),res4(:,2),'LineWidth',2,'DisplayName','n = 75')
% plot(res5(:,3),res5(:,2),'LineWidth',2,'DisplayName','n = 100')

ylabel('True Positive Ratio')
xlabel('False Positive Ratio')
title('Influence of scale')
axis([0 1 -0 1])

legend('show')