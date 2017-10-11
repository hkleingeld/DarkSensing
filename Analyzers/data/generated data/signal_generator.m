clear all
%in fdatool, lowpass, Fir, 8th order, chebyshev,sidelobe atten = 100, 
%Fs = 125Hz, Fc = 5Hz
filter = [0.0049    0.0348    0.1126    0.2152    0.2650    0.2152    0.1126    0.0348    0.0049]

simulation_time = 30

ts = 1/200000;
Fs = 1/ts;

t = 0:ts:simulation_time;

diff = 10;
T = 3;

[dc n] = size(t);

sigmaLvls = 0:20;
acLvls = 0:20;
acLLvls = 0:20;
carSpeed= [1/(15/(5/3.6)) 1/(15/(10/3.6)) 1/(15/(20/3.6)) 1/(15/(30/3.6)) 1/(15/(40/3.6)) 1/(15/(50/3.6)) 1/(15/(80/3.6)) 1/(15/(100/3.6))];
signalStrenght = [100 50 40 30 20 15 10 5];
for CS = 1:8
    for SS = 1:8
        mu(1:n) = 0;
        sigma(1:n) = 3;

        noise  = normrnd(mu,sigma);
        ac     = 2.5+5* cos(t*2*pi*50);
        acL    = 1.25+2.5* cos(t*2*pi*200);
        dc(1:n)= 200;
        signal(1:n) = 800;
        human  = ( signalStrenght(SS)/2  - signalStrenght(SS)/2 * cos(t * 2 * pi * carSpeed(CS))) .* (t > 0) .* (t < 1/carSpeed(CS));

        samples_index = 1:200000/125:simulation_time*200000;

        noise = noise(samples_index);
        ac = ac(samples_index);
        acL = acL(samples_index);
        dc = dc(samples_index);
        signal = signal(samples_index);
        human = human(samples_index);
        
        signal(2500:3499) = signal(2500:3499) + human(1:1000);
        
        tot = noise+ac+acL+dc+signal;
        
        cs = num2str(CS)
        ss = num2str(SS)
        dlmwrite(strcat('test_', cs, '_(', ss, ').txt'),[2500 1000])
        dlmwrite(strcat('test_', cs, '_(', ss, ').txt'),round(tot'),'-append')
    end
end

%plot(PD-PD_Dark)