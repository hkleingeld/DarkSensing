clear all
f = fread(fopen('MatlabInputs_analogfilter.txt'),'uint16');
g = fread(fopen('MatlabInputs_nofilter.txt'),'uint16');

f(f==hex2dec('FFFF')) = [];
g(g==hex2dec('FFFF')) = [];

[n dc] = size(f)
f = reshape(f,[800 n/800])

[n dc] = size(g)
g = reshape(g,[800 n/800])

close
plot(g(:,16),'LineWidth',2)
%title('Received flash, no filter')
ylabel('RSS (adc)')
xlabel('Sample number')
xlim([1 50])
print('no_filter','-dpng')
close

plot(f(:,16),'LineWidth',2)
%title('Received flash, no filter')
ylabel('RSS (adc)')
xlabel('Sample number')
xlim([1 50])
print('analog_filter','-dpng')
