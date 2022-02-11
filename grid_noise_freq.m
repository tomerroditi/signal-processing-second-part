function freq = grid_noise_freq(signal)
% compute the fft of the signal and find the maximal frequency
Fs = 1000;
L = length(signal);
Y = fft(signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
f = Fs*(0:(L/2))/L;

P3 = P1(f >= 30 & f <= 70);
[M1,~] = max(P3);

freq = f(P1 == M1);