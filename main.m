%今天看到了李老师的检查悖论的视频 还是很有意思的 然后不想干别的事情就来试试看能不能画一下这个等待悖论的图吧
%假设公交车班次为N，一个循环有TIME分钟，然后每辆公交车都是随机到达，乘客也是随机到达，画出乘客的到达曲线图，模拟NUM次
clear;clc;

global N;
global TIME;
global NUM;

N = 6;             %公交车班数
TIME = 60;          %公交车单次循环时间
NUM = 10000;        %重复模拟次数
PIRIOD = 60;        %绘图时所分类的区间数量

time2wait = zeros(NUM, 1);
for i=1:1:NUM
    timebus = rand(1, N)*TIME;
    timebus = sort(timebus, 2);
    fprintf("%g\n", timebus);
    
    time2wait(i, 1) = onepass(timebus);
    fprintf("the waiting time is %g\n", time2wait(i, 1));
    fprintf("\n");
end

plot_wait = zeros(PIRIOD,1);
for i = 1:1:PIRIOD
    plot_wait(i) = (i-1)*TIME/PIRIOD;
end

%按照选定的间隔计数和画图
plot_num = zeros(PIRIOD,1);
for i=1:1:NUM
    j = floor(time2wait(i)/(TIME/PIRIOD));
    plot_num(j+1,1) = plot_num(j+1,1)+1;
end
bar(plot_wait, plot_num);
title('公交车等待时间悖论');
xlabel('等待时间');
ylabel('等待人数');
average_time = mean(time2wait);
fprintf("The average time is %g minutes.\n", average_time);
