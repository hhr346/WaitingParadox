# 用Matlab模拟等待公交车例子下的等待悖论（检查悖论）



## 引入

最近看到了李永乐老师关于检查悖论的内容，还是很有意思的，这个是[网页的链接](https://www.bilibili.com/read/cv8552928)，所以就来试试看能不能仿照一下文中的思路，用`Matlab`画一下这个等待悖论的图，并且比对一下结果吧。

首先来明确一下问题，抽离出数学模型之后再进行建模。

在等待公交车时，常常会遇到有很多乘客同时等待同一辆车的情况，此时公交车公司则会表示我们是平均10分钟就发一次车的。但是问题在于如果发车时间间隔不均等，就会造成很多人在一个较长的时间段一直在等待一辆车。这其实就是从不同的角度去观测公交车发车这一件事情。所以我们可以假设公交车和乘客都是随机到达来计算每个人的等待时间分布。

所以设定参数如下，假设公交车班次为N，一个循环有TIME分钟，然后每辆公交车都是随机到达，乘客也是随机到达，画出乘客的到达曲线图，并模拟NUM次绘制出各个乘客等待时间的柱状图。

<br>

## 程序设计

先把主函数写好，计算比较复杂的部分封装成一个函数，这里封装的函数是单个人在随机到达车站之后的等待时间。

### 参数

定义一些需要用到的参数：

```matlab
global N;
global TIME;
global NUM;

N = 6;			%公交车班数
TIME = 60;		%公交车单次循环时间
NUM = 10000;		%重复模拟次数
PIRIOD = 60;        	%绘图时所分类的区间数量
```

### 主函数

然后写一个简单的主函数来计算模拟多次的时间，并把结果存到`time2wait` 这个数组里。

```matlab
time2wait = zeros(NUM, 1);
for i=1:1:NUM
    timebus = rand(1, N)*TIME;
    timebus = sort(timebus, 2);
    fprintf("%g\n", timebus);
    
    time2wait(i, 1) = onepass(timebus);
    fprintf("the waiting time is %g\n", time2wait(i, 1));
    fprintf("\n");
end
```

### 等待时间函数

然后就是比较容易出错的等待时间函数的部分，这里最容易出错的就是取整函数的部分，我算是彻底认识到`round`这个四舍五入的函数的坑爹之处了，以后再也不用了，要么溢出要么有问题还难排查，所以还是用`floor` 和`ceil` 吧。还有就是取余函数也要当心，不过不是这里的问题。

```matlab
function [time] = onepass(timebus)
%计算单个人在单次的乘车过程中的等待时间
global TIME;
global N;

time_arrive = rand(1)*TIME;
fprintf("the arriving time is %g\n", time_arrive);
count = 1;
while count<=N && time_arrive > timebus(count)
    count = count+1;
end

if count <= N
    time = timebus(count) - time_arrive;
else
    time = TIME*floor(count/N) + timebus(mod(count, N)) - time_arrive;
end
```

### 画图

最后是比较简单的画图步骤

```matlab
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
```

<br>

## 结果

其中经过了艰难的debug过程，终于输出了结果，平均等待时间为8.41min。

![image](https://img2022.cnblogs.com/blog/2855365/202209/2855365-20220909111528940-586628062.png)

## 总结

检查悖论最关键的一点是在不均匀分布的前提情况下，以车为统计单位和以人为统计单位会有不同的结果。资源总数的平均数在分配的不均匀性很大的时候，具有巨大的欺骗性，和用户的实际体验是完全不同的。流量大的更容易被统计观察到，但不代表很多没有受到关注的部分就不存在。这是随机生成的有偏估计，而一切的前提都在于在于资源的时空不均匀性。

至于从数学角度去考虑一下就是因为到达的节点间隔不均匀，尽管节点间隔的平均数保持不变，但是乘客的随机到达相当于给这些间隔加上了权重，不均匀性越大这个结果就会偏离平均值越多（想到了高中的均值不等式），具体计算应该是用多重积分计算。

这个结论真的很有趣，和幸存者偏差里的条件筛选类似但不完全一样。这些结论都在告诉我们，要从不同的视角看，要看到整体而不是筛选出来的表象，要关注沉默的大多数，才能对全局有更加深入的了解。