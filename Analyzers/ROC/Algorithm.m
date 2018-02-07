function result = Algorithm(x,n,d,m,z,Z,T,lesson)

if(z > Z)
    z = Z;
end

[SIZE dc] = size(x);
les = zeros(SIZE,1);
les(lesson:SIZE) = 1;

filter(1:Z) = 1/z;

X = movmean(x,[n-1 0]);
avg = [zeros(d-1,1);movmean(X,[m-1 0])];
std = [zeros(d-1,1);movstd(X,[m-1 0])];

TP = (conv(filter,les .* ((X(1:SIZE) < avg(1:SIZE)-T*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+T*std(1:SIZE)))) >= 1);
FP = (conv(filter,~les .* ((X(1:SIZE) < avg(1:SIZE)-T*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+T*std(1:SIZE)))) >= 1);

% Debug plots :)
% close
% hold on
% plot(TP *18000)
% plot(FP *18000)
% plot(X(1:SIZE))
% plot(avg(1:SIZE))
% plot(avg(1:SIZE)-T*std(1:SIZE))
% plot(avg(1:SIZE)+T*std(1:SIZE))

result = [any(TP(n+m+d+100:SIZE)) any(FP(n+m+d+100:SIZE))];

end




