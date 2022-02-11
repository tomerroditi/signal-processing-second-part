function af2 = Rwave_detection(signal, PLFREQ)
% this function implement the AF2 algorithm from the paper, and a
% correlation test between the candidates QRS sections found by the AF2
% algorithm and QRS sections and not QRS sections.

% reshape the vector signal if needed
if size(signal,1) ~= 1
    signal = signal.';
end

signal = Filter_sig(signal.', PLFREQ);   % notch filter for grid noise and other noises
% filter the signal to denoise it and solve the base line wander problem
filtered_signal = filter_my_signal(signal.');


% % plot the signal and filtered signal in seconds 30-38. first plot should
% be before the notch filters...
% figure(101)
% subplot(2,1,1)
% plot((30000:38000)./1000, signal(30000:38000));ylabel('volt [micro volt]'); xlabel('time [sec]'); title('ECG 316048396 02 - original');
% subplot(2,1,2)
% plot((30000:38000)./1000, filtered_signal(30000:38000)); ylabel('volt [micro volt]'); xlabel('time [sec]'); title('ECG 316048396 02 - filtered signal');


% implement AF2 algorithm 
if length(filtered_signal) > 3000
    K = 2000;
else
    K = 1;
end
threshold = 0.3*max(filtered_signal(K:end));              % compute threshold 
signal_1 = abs(filtered_signal);                    % get abs values   
signal_1(signal_1 < threshold) = threshold;         % clipp the signal
deriv_1 = signal_1(2:end) - signal_1(1:end - 1);    % first derivative

indx = find(deriv_1 > 0.1*max(deriv_1(K:end)));

af2 = zeros(1,length(indx));                        % set af2 size in advanced to save computational time
half_window = 60;
for i = 1:length(indx) - 1
    if indx(i) - indx(i + 1) == -1 || indx(i) + half_window >= length(filtered_signal) || indx(i) - half_window < 1
        continue
    end

    % perform correlation tests
     [qrs_corr , not_qrs_corr] = corr_qrs_window(filtered_signal(indx(i) - half_window:indx(i) + half_window));
     if qrs_corr > not_qrs_corr && qrs_corr > 0.85
         [~,ind] = max(signal(indx(i) - half_window:indx(i) + half_window));
         ind = ind + indx(i) - half_window - 1;
         af2(1,i) = ind;
     end
end

af2 = af2(1, af2 ~= 0);     % drop any unused indices in af2 vector
af2 = unique(af2);          % drop any repetitive indices


% % plot the peaks on the filtered signal (we made sure there is no time shift)
% figure(10)
% plot(signal); hold on; plot(af2, signal(af2),'ro', 'MarkerSize', 3); hold off;
end



