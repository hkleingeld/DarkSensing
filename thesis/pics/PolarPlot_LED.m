halfconeapex = (35.4/2*pi)/180;     %Angle at Half Power in radiance
m = -1/log2(cos(halfconeapex)); %some index describing the radiation pattern
theta = -0.5*pi:0.01:0.5*pi;
rho = ((m+1)/(2*pi)) * cos(theta).^m;

polarplot(theta,rho*264,'DisplayName', 'Calculated intensity','LineWidth', 2);
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaLim = [-90 90];
rticklabels({'0cd','200cd','400cd','600cd'})

measured = [1 5/6 4/6 3/6 2/6 1/6 0]


angle = [0 (9*pi)/180 (14*pi)/180 (35.4/2*pi)/180 (20*pi)/180 (25*pi)/180 (30*pi)/180];

measured = [fliplr(measured(2:7)) measured]
angle = [fliplr(angle(2:7)) -1.*angle]

hold on
polarplot(angle,measured*601,'x','DisplayName', 'Measured intensity','LineWidth', 2);
title('Estimated illumination pattern LED');
x = legend('show','Location','northoutside');
x.Position = [0.6120    0.3565    0.2604    0.0869];

print('polarplot_LED.png','-dpng');
hold off