p20 = fread(fopen('paper_120cm.txt'),'uint16');
p20(p20==hex2dec('FFFF')) = [];
[n dc] = size(p20)
p20 = reshape(p20,[800 n/800])



plot(p20)
