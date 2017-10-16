function result = AlgorithmSTD(x,m,d,T,lesson)

[SIZE dc] = size(x);
les = zeros(SIZE,1);
les(lesson:SIZE) = 1;

y = movstd(x,[m-1 0]);
D = [zeros(d-1,1);y];

TP = les.*(y(1:SIZE) > T.*D(1:SIZE));
FP = ~les(m+d+100:SIZE).*(y(m+d+100:SIZE) > T.*D(m+d+100:SIZE));

result = [any(TP) any(FP)];
end
% axis([SIZE-1000 SIZE 0 20])
