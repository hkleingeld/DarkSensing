STD1 = [960  890    7   9  4.5    0.2]
STD2 = [860  980    8   10 5.9   -0.7]
STD3 = [870  990    4   4  4.9    0.4]
% STD1 = [1000    960    4    5    4.9     0.9]
% STD2 = [790    980     3    2    5.3     0.7]
P = 0
R = 0
for(T = 1:0.1:13)
    T
    STD1(5) = T;
    res = ROC_rapid(STD1,2);
    P = [P res(1)];
    R = [R res(2)];
end
P(1) = [];R(1) = [];
close
hold on
x = 1:0.1:13;
plot(x,P,'DisplayName','False positive ratio','LineWidth',2)
plot(x,R,'DisplayName','Recall','LineWidth',2)

xlabel('T')
title('ALG_w_o_o_d tested on carpet')
legend('show')
set(gca,'fontsize', 15);
xlim([1 13])
print('STDs1_s2.png','-dpng')

P = 0
R = 0
for(T = 1:0.1:10)
    T
    STD2(5) = T;
    res = ROC_rapid(STD2,1);
    P = [P res(1)];
    R = [R res(2)];
end
P(1) = [];R(1) = [];
close
hold on
x = 1:0.1:10;
plot(x,P,'DisplayName','False positive ratio','LineWidth',2)
plot(x,R,'DisplayName','Recall','LineWidth',2)

xlabel('T')
title('ALG_c_a_r_p_e_t tested on wood')
legend('show')
set(gca,'fontsize', 15);
xlim([1 10])
print('STDs2_s1.png','-dpng')

copyfile STDs1_s2.png ../../thesis/pics
copyfile STDs2_s1.png ../../thesis/pics