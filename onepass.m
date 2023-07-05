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
