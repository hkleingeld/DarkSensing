function result = ROC_Curve(n,d,m,z)

path1 = '"..\\data\\cars\\stone\\black "';
path2 = '"..\\data\\cars\\stone\\red "';
path3 = '"..\\data\\cars\\stone\\silver "';

path4 = '"..\\data\\cars\\paper\\black "';
path5 = '"..\\data\\cars\\paper\\red "';
path6 = '"..\\data\\cars\\paper\\silver "';

prog_1 = 'DarkSenseAnalyzer_1_TP.exe';
prog_2 = 'DarkSenseAnalyzer_2_TP.exe';

prog_3 = 'DarkSenseAnalyzer_1_FP.exe';
prog_4 = 'DarkSenseAnalyzer_2_FP.exe';

N = num2str(n);
D = num2str(d);
M = num2str(m);
Z = num2str(z);

[dc SIZE] = size(1:1:200)

result = zeros(SIZE,3)
i = 0;
for T_ = 1:1:200
    i = i + 1;
    T = num2str(T_/10);
    TruePositive = 0;
    TruePositive = TruePositive + system([prog_1 ' ' path1 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    TruePositive = TruePositive + system([prog_1 ' ' path2 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    TruePositive = TruePositive + system([prog_1 ' ' path3 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    TruePositive = TruePositive + system([prog_2 ' ' path1 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    TruePositive = TruePositive + system([prog_2 ' ' path2 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    TruePositive = TruePositive + system([prog_2 ' ' path3 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    
%     TruePositive = TruePositive + system([prog_1 ' ' path4 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     TruePositive = TruePositive + system([prog_1 ' ' path5 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     TruePositive = TruePositive + system([prog_1 ' ' path6 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     TruePositive = TruePositive + system([prog_2 ' ' path4 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     TruePositive = TruePositive + system([prog_2 ' ' path5 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     TruePositive = TruePositive + system([prog_2 ' ' path6 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);

    FlasePositive = 0;
    FlasePositive = FlasePositive + system([prog_3 ' ' path1 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    FlasePositive = FlasePositive + system([prog_3 ' ' path2 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    FlasePositive = FlasePositive + system([prog_3 ' ' path3 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    FlasePositive = FlasePositive + system([prog_4 ' ' path1 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    FlasePositive = FlasePositive + system([prog_4 ' ' path2 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    FlasePositive = FlasePositive + system([prog_4 ' ' path3 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    
%     FlasePositive = FlasePositive + system([prog_3 ' ' path4 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     FlasePositive = FlasePositive + system([prog_3 ' ' path5 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     FlasePositive = FlasePositive + system([prog_3 ' ' path6 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     FlasePositive = FlasePositive + system([prog_4 ' ' path4 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     FlasePositive = FlasePositive + system([prog_4 ' ' path5 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
%     FlasePositive = FlasePositive + system([prog_4 ' ' path6 ' ' N ' ' D ' ' M ' ' Z ' ' T ' 3 13']);
    
    result(i,:) = [T_/10 TruePositive FlasePositive];
    T_
end


end