function result = Algorithm_pp(x,n,d,m,z,Z,T,T_o,lesson)

if(z > Z)
    z = Z;
end

[SIZE dc] = size(x);
pass = zeros(SIZE,1);
pass(lesson:SIZE) = 1;
Fail = ~pass;

%ensure no false detections can occure while we are initialising.
Fail(1:2500) = 0;

filter(1:Z) = 1/z;

X = movmean(x,[n-1 0]);
avg = [zeros(d-1,1);movmean(X,[m-1 0])];
std = [zeros(d-1,1);movstd(X,[m-1 0])];

TP = (conv(filter,pass .* ((X(1:SIZE) < avg(1:SIZE)-(T+T_o)*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+(T+T_o)*std(1:SIZE)))) >= 1);
FP = (conv(filter,Fail .* ((X(1:SIZE) < avg(1:SIZE)-(T+T_o)*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+(T+T_o)*std(1:SIZE)))) >= 1);

% Debug plots :)

% close
% [s dc] = size(x);
% t = 0:1/125:1/125*(s-1);
% hold on
% plot(t,TP *18000)
% plot(t,FP *18000)
% plot(t,X(1:SIZE),'DisplayName','X')
% plot(t,avg(1:SIZE))
% plot(t,avg(1:SIZE)+T*std(1:SIZE),'DisplayName','\mu+T\sigma')
% plot(t,avg(1:SIZE)-T*std(1:SIZE),'DisplayName','\mu-T\sigma')


result = [any(TP(1:SIZE)) any(FP(1:SIZE))];

end