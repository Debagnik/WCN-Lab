clc
clear all
close all
x = [3341,3506,3688,4040,4135,4113]
x3 = (x*8*512)/25
x = [2639,2628,3029,3188,3571,3132]
x4 = (x*8*512)/25
x = [2373,2132,2229,2552,3104,2610]
x5 = (x*8*512)/25
x = [2778,1356,959,554,0,0]
x9 = (x*8*512)/25
y = [2 7 15 31 63 127]

plot(y,x3)
hold on
plot(y,x4)
plot(y,x5)
plot(y,x9)
hold off
legend("3x3","4x4","5x5","9x9")
xlabel("Contention Window")
ylabel("Throughput (bits/secs)")