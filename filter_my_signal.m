function  filtered = filter_my_signal(signal)
% this function filters the ecg signal and returns the filtered signal

% Design a digital filter
designedFilter = designfilt('bandpassfir', ...
    'StopbandFrequency1',4,'PassbandFrequency1',7, ...
    'PassbandFrequency2',40,'StopbandFrequency2',43, ...
    'StopbandAttenuation1',60,'PassbandRipple',1, ...
    'StopbandAttenuation2',60,'SampleRate',1000);
filtered = filter(designedFilter,signal);           % pass the signal in the filter
delay = grpdelay(designedFilter);                   % group delay of the filter          
mdelay = round(mean(delay));                        % compute the delay of the signal caused by the filter
filtered(1:mdelay) = [];                            % cut the delay time from the filtered signal
fvtool(designedFilter);

end
