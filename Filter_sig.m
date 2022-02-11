function filt_sig = Filter_sig(signal, grid_freq)

% compute the fft of the signal and find the maximal frequency
Fs = 1000;
L = length(signal);
Y = fft(signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
f = Fs*(0:(L/2))/L;

P4 = P1(f <= 5 & f > 0.01);
[M2,~] = max(P4);
breathing_frq = f(P1 == M2);

if breathing_frq == 0
    breathing_frq = 2;
end

% create a notch filter around the maximal frequency
[num,den] = iirnotch(grid_freq/(Fs*0.5), (grid_freq/(Fs*0.5))/100);
filt_sig = filtfilt(num, den, signal);   % apply filter on the signal
fvtool(num,den)  % filter response plot

[num,den] = iirnotch(breathing_frq/(Fs/2), (breathing_frq/(Fs/2))/20);
filt_sig = filtfilt(num, den, filt_sig);   % apply filter on the signal
fvtool(num,den)  % filter response plot
end

