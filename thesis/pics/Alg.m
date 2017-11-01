function [mu_ std_ N_ result] = Alg(data,n,d,m,T)
% m = amount of samples in std
% d = amount of samples in delay field
% n = amount of samples in averager
% n is part of the delay field
%
% new sample -----> [       d field       ] [m field] -----> delete
%                   [n field  <-- ] -->

Start = m+d;

[dc NrOfSamples] = size(data);

N = movmean(data,[n-1 0]); % take data from most recent sample and n samples in the past
mu = movmean(data,[m-1 0]); % take data from most recent sample and m samples in the past
std= movstd(data,[m-1 0]);

std = std/sqrt(n);

NrOfSamples = NrOfSamples - Start;
result = zeros([1 NrOfSamples]);



for i = 1:NrOfSamples
    N_(i) = N(Start+i);
    mu_(i) = mu(Start-d+i);
    std_(i) = std(Start-d+i);
    result(i) = (N_(i) > mu_(i) + T*std_(i)) | (N_(i) < mu_(i) - T*std_(i));
end

