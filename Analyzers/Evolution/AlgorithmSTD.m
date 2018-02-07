function result = AlgorithmSTD(x,m,d,l,L,T,lesson)

[SIZE dc] = size(x);
Pass = zeros(SIZE,1);
Pass(lesson:SIZE) = 1;
Fail = ~Pass;

%ensure no false detections can occure while we are initialising.
Fail(1:25*125) = 0;

y = movvar(x,[m-1 0]);
D = [zeros(d-1,1);y];

filter(1:L) = 1/l;

TP = (conv(filter,Pass.*(y(1:SIZE) > T.*D(1:SIZE)))>= 1);
FP = (conv(filter,Fail(m+d+100:SIZE).*(y(m+d+100:SIZE) > T.*D(m+d+100:SIZE)))>= 1);

% close
% hold on
% plot(T.*D(1:SIZE))
% plot(y(1:SIZE))

result = [any(TP) any(FP)];
end