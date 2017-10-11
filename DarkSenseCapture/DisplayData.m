clear all
g = csvread('hajo center\Result_2.txt');
g = g(:,1) 
g(1) = [];
plot(g)

%highpass = designfilt('highpassfir', 'FilterOrder', 5, 'CutoffFrequency', 0.05, 'SampleRate', 125);
lowpass = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', 10, 'SampleRate', 125);

%y = filter(highpass,g)
y = filter(lowpass,g)
hold on
plot(y);