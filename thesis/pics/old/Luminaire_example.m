lumI = 100;

angle = -0.5*pi: pi/180 : 0.5*pi;
num = -90:90;

halfconeapex = (20*pi)/180;
m = -1/log2(cos(halfconeapex));
I__ = @(x) lumI .* ((m+1)/(2*pi)) .* cos(x).^m
plot(num,I__(angle),'LineWidth',2,'DisplayName','\phi_1_/_2 = 20, n = 11.1')
hold on

halfconeapex = (30*pi)/180;
m = -1/log2(cos(halfconeapex));
I__ = @(x) lumI .* ((m+1)/(2*pi)) .* cos(x).^m
plot(num,I__(angle),'LineWidth',2,'DisplayName','\phi_1_/_2 = 30, n = 4.8')
hold on
halfconeapex = (60*pi)/180;
m = -1/log2(cos(halfconeapex));
I__ = @(x) lumI .* ((m+1)/(2*pi)) .* cos(x).^m

plot(num,I__(angle),'LineWidth',2,'DisplayName','\phi_1_/_2 = 60, n = 1')
halfconeapex = (75*pi)/180;
m = -1/log2(cos(halfconeapex));
I__ = @(x) lumI .* ((m+1)/(2*pi)) .* cos(x).^m

plot(num,I__(angle),'LineWidth',2,'DisplayName','\phi_1_/_2 = 75, n = 0.5')

axis([-90 90 0 200])
title('Light output of a luminaire','FontSize',12)
xlabel('Angle (degree)','FontSize',12)
ylabel('Luminous Intencity (cd)','FontSize',12)

legend('show')