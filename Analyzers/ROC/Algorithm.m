function result = Algorithm(x,n,d,m,z,T,lesson)

[SIZE dc] = size(x);
les = zeros(SIZE,1);
les(lesson:SIZE) = 1;

X = movmean(x,[n-1 0]);
avg = [zeros(d-1,1);movmean(X,[m-1 0])];
std = [zeros(d-1,1);movstd(X,[m-1 0])];

TP = les .* ((X(1:SIZE) < avg(1:SIZE)-T*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+T*std(1:SIZE)));
FP = ~les .* ((X(1:SIZE) < avg(1:SIZE)-T*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+T*std(1:SIZE)));

result = [any(TP(n+m+d+100:SIZE)) any(FP(n+m+d+100:SIZE))];

end




