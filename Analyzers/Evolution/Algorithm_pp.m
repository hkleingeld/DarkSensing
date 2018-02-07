function result = Algorithm_pp(x,n,d,m,z,Z,T,T_o,lesson)

if(z > Z)
    z = Z;
end

[SIZE dc] = size(x);
pass = zeros(SIZE,1);
pass(lesson:SIZE) = 1;
Fail = ~pass;

%ensure no false detections can occure while we are initialising.
Fail(1:25*125) = 0; %cant fail for the first 25 seconds.

filter(1:Z) = 1/z;

X = movmean(x,[n-1 0]);
avg = [zeros(d-1,1);movmean(X,[m-1 0])];
std = [zeros(d-1,1);movstd(X,[m-1 0])];

TP = (conv(filter,pass .* ((X(1:SIZE) < avg(1:SIZE)+ T_o*std(1:SIZE) -(T)*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+T_o*std(1:SIZE) +(T)*std(1:SIZE)))) >= 1);
FP = (conv(filter,Fail .* ((X(1:SIZE) < avg(1:SIZE)+ T_o*std(1:SIZE) -(T)*std(1:SIZE)) | (X(1:SIZE) > avg(1:SIZE)+T_o*std(1:SIZE) +(T)*std(1:SIZE)))) >= 1);

% Debug plots :)
% close
[s dc] = size(x);
t = 0:1/125:1/125*(s-1);

hold on
% plot(TP *18000)
% plot(FP *18000)
% plot(X(1:SIZE),'DisplayName','X','LineWidth',2)
% plot(avg(1:SIZE),'LineWidth',2)
plot(avg(1:SIZE)+(T+T_o)*std(1:SIZE),'DisplayName','\mu+T\sigma','LineWidth',2)
plot(avg(1:SIZE)-(T+T_o)*std(1:SIZE),'DisplayName','\mu-T\sigma','LineWidth',2)


result = [any(TP(1:SIZE)) any(FP(1:SIZE))];

end