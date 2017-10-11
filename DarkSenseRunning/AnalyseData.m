clear all
g = csvread('Debug\\example.txt');
g(1:300,:) = [];
plot(g)


%s=v*t, s/v = t
s = 2;%m LED Vision range
v = 2/3.6;%m/s (very slow person, 2.5km/h)
t = s/v;

%1/f = T, t = T ->
f = 1/t

test = designfilt('highpassiir', 'FilterOrder', 2, ...
                  'HalfPowerFrequency', 0.2, 'SampleRate', 125, ...
                  'DesignMethod', 'butter');

test2 = designfilt('highpassfir', 'FilterOrder', 5, 'CutoffFrequency', 0.2, 'SampleRate', 125)

