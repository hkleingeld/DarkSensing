clear all

g = fread(fopen( 'MatlabInputs_nofilter.txt'),'uint16');

g(g==hex2dec('FFFF')) = [];

[n dc] = size(g)
g = reshape(g,[800 n/800])

hold off
plot(g(:,16),'LineWidth',2)
%title('Received flash, no filter')
ylabel('RSS (adc)')
xlabel('Sample number')
xlim([1 80])
set(gcf,'units','points','position',[-600,0,400,200])
print('no_filter','-dpng')
