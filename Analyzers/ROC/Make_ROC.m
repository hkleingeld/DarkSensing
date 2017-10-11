res1 = ROC_Curve(25,300,600,1,0.02)
res1(:,2) = res1(:,2) / 90;
res1(:,3) = res1(:,3) / 90;

hold on
plot(res1(:,3),res1(:,2),'LineWidth',2,'DisplayName','z = 1')

res2 = ROC_Curve(25,300,600,2,0.02)
res2(:,2) = res2(:,2) / 90;
res2(:,3) = res2(:,3) / 90;
plot(res2(:,3),res2(:,2),'LineWidth',2,'DisplayName','z = 2')

res3 = ROC_Curve(1,300,600,3,0.02)
res3(:,2) = res3(:,2) / 90;
res3(:,3) = res3(:,3) / 90;
plot(res3(:,3),res3(:,2),'LineWidth',2,'DisplayName','z = 3')

res4 = ROC_Curve(1,300,600,4,0.02)
res4(:,2) = res4(:,2) / 90;
res4(:,3) = res4(:,3) / 90;
plot(res4(:,3),res4(:,2),'LineWidth',2,'DisplayName','z = 4')

res5 = ROC_Curve(1,300,600,5,0.02)
res5(:,2) = res5(:,2) / 90;
res5(:,3) = res5(:,3) / 90;
plot(res5(:,3),res5(:,2),'LineWidth',2,'DisplayName','z = 5')

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