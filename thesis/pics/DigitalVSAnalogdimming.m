t = 0:pi/100:4*pi

sq1 = (square(t,50)+1)*50;
sq2 = (square(t,25)+1)*50;
sq3 = (square(t,1)+1)*50;

hold on
plot(t,sq1,'LineWidth',2,'DisplayName','50%');
plot(t,sq2,'LineWidth',2,'DisplayName','25%');
plot(t,sq3,'LineWidth',2,'DisplayName','1%');

axis([0 12 -5 105]);

title('Digital dimming');
ylabel('Used power (%)');
xlabel('Time');