function result = Algorithm(x,n,d,m,z,Z,T,lesson)

if(z > Z)
    z = Z;
end

[SIZE dc] = size(x);
lesTP = zeros(SIZE,1);
lesTP(lesson:SIZE) = 1;

lesFP = ~lesTP;
lesFP(1:d+m+265) = 0;

filter(1:Z) = 1/z;

X = movmean(x,[n-1 0]);
avg = [zeros(d-1,1);movmean(X,[m-1 0])];
std = [zeros(d-1,1);movstd(X,[m-1 0])];

TP = (conv(filter,lesTP .* ((X(1:SIZE) < avg(1:SIZE)-T*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+T*std(1:SIZE)))) >= 1);
FP = (conv(filter,lesFP .* ((X(1:SIZE) < avg(1:SIZE)-T*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+T*std(1:SIZE)))) >= 1);

result = [any(TP(n+m+d+100:SIZE)) any(FP(n+m+d+100:SIZE))];

end




