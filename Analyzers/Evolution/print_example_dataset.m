path = '..\data\Measurements\floor\blue right\Result_4.txt';
x = csvread(path)';
x_ = x(4,:);
x_(1) = [];
x_ = [x_(1:2000) x_];
IIR2_5 = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 5, 'SampleRate', 150);
IIR2_01 = designfilt('highpassiir', 'FilterOrder', 1, 'HalfPowerFrequency', 0.1, 'SampleRate', 125);

lesson = x(1,1)+2000;

x1 = filter(IIR2_5, x_);
x2 = filter(IIR2_01, x1);
n = CalcN(x2(2000:2511),3,50,125);


Algorithm_pp(x2',n,900,900,1,1,4,0,lesson)
set(gcf, 'Position', [100, 100, 800, 400])
xlim([0 41])
ylim([-1.5e4 3e4])

xlabel('Time (s)');
ylabel('Observed measure');
title('Example test-case')
legend('show');

line([25 25],[-1.5e4 3e4]);
line([lesson/125 lesson/125],[-1.5e4 3e4]);

text(11,1e4,'1','FontSize',20)
text(30.5,1e4,'2','FontSize',20)
text(38.5,1e4,'3','FontSize',20)
set(gca,'fontsize', 15);
print('Examplescenario.png','-dpng')
copyfile Examplescenario.png ../../thesis/pics
