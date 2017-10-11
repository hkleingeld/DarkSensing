function result = ROC_Curve(n,d,m,scale)

path1 = '"generated data\\test_1_("';
path2 = '"generated data\\test_2_("';
path3 = '"generated data\\test_3_("';
path4 = '"generated data\\test_4_("';
path5 = '"generated data\\test_5_("';
path6 = '"generated data\\test_6_("';
path7 = '"generated data\\test_7_("';
path8 = '"generated data\\test_8_("';

prog_1 = 'DarkSenseAnalyzer_1_TP_generated.exe';


prog_3 = 'DarkSenseAnalyzer_1_FP_generated.exe';


N = num2str(n);
D = num2str(d);
M = num2str(m);
scale = num2str(scale);

[dc SIZE] = size(10:5:250)

result = zeros(SIZE,3)
i = 0;
for T_ = 10:5:250
    i = i + 1;
    T = num2str(T_/10);
    TruePositive = 0;
    TruePositive = TruePositive + system([prog_1 ' ' path1 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    TruePositive = TruePositive + system([prog_1 ' ' path2 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    TruePositive = TruePositive + system([prog_1 ' ' path3 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    TruePositive = TruePositive + system([prog_1 ' ' path4 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    TruePositive = TruePositive + system([prog_1 ' ' path5 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    TruePositive = TruePositive + system([prog_1 ' ' path6 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    TruePositive = TruePositive + system([prog_1 ' ' path7 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    TruePositive = TruePositive + system([prog_1 ' ' path8 ' ' N ' ' D ' ' M ' ' T ' ' scale]);

    FlasePositive = 0;
    FlasePositive = FlasePositive + system([prog_3 ' ' path1 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    FlasePositive = FlasePositive + system([prog_3 ' ' path2 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    FlasePositive = FlasePositive + system([prog_3 ' ' path3 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    FlasePositive = FlasePositive + system([prog_3 ' ' path4 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    FlasePositive = FlasePositive + system([prog_3 ' ' path5 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    FlasePositive = FlasePositive + system([prog_3 ' ' path6 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    FlasePositive = FlasePositive + system([prog_3 ' ' path7 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    FlasePositive = FlasePositive + system([prog_3 ' ' path8 ' ' N ' ' D ' ' M ' ' T ' ' scale]);
    
    result(i,:) = [T_/10 TruePositive FlasePositive];
    T_
    end


end