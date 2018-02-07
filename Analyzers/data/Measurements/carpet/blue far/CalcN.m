function MovAvgLen = CalcN(x,fmin,fmax,fs)

fftRes = abs(fft(x));

[sz1 sz2] = size(x);
sz = max(sz1,sz2);

fmin = floor(fmin*sz/fs);
fmax = ceil(fmax*sz/fs);

[size_result index_result] = max(fftRes(fmin:fmax));

freq_result = fs/sz*(fmin+index_result);

MovAvgLen = round(fs/freq_result);