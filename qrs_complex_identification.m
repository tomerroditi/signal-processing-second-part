% Load ECG signal
ECG = load('normal signal 1/ECG_208119719_02.mat');
ECG = ECG.sig;

% Set anotation parameters
fs              = 1e3;                                      % [Hz]
Ts              = 1/fs;                                     % [sec]
numPoints       = 10;                                       % We want to mark 5 R-waves every iteration
BeatDuration    = 1/(Ts);                                   % [sec]/[sec]=[Samples]
nChunks         = length(ECG)/(numPoints*BeatDuration);     % number of sample frames to loop on
winSiz          = 150;                                      % Set the sample frame for searching R-wave
win             = -winSiz:winSiz;                           % Search the true R-wave in this sample frame
Rwaves          = [];
num_mark        = 10;

for iChunk = 0:(nChunks-1)                                  % Loop over chunks

    % Set the samples to plot every iteration
    sampleVec = (1:numPoints*BeatDuration) + (iChunk*numPoints*BeatDuration);
    
    % Plot the anotation figure
    figure('Units','normalized','Position',[0 0 1 1]);
    plot(sampleVec, ECG(sampleVec));
    title('Mark the R-wave in every heartbeat');
    xlabel('Sample [#]');
    ylabel('[\muV]');
    grid on;
    
    % Mark the R-wave using the graphical input from mouse cursor
    RwaveInd = ginput(num_mark);
    close;
    
    % Identify the closest sample to the vertical position of the graphical input
    for iPoint = 1:num_mark
        [~, ind(iPoint)] = min(abs(sampleVec - RwaveInd(iPoint,1)));
        ind(iPoint) = ind(iPoint) + (iChunk*numPoints*BeatDuration);
    end

    % find the index of the maximal value around the marked point 
    maxInd = []
    for iPoint = 1:num_mark
        [~, maxInd(iPoint)]  = max(ECG(ind(iPoint) + win));
        maxInd(iPoint) = ind(iPoint) + win(1) + maxInd(iPoint) - 1;
    end

    % delete any repeated indices in maxInd and change number of maraking 
    % points if needed
    old_len = length(maxInd);
    maxInd = unique(maxInd);
    new_len = length(maxInd);

    if old_len - new_len < 2
        num_mark = num_mark + 2;
    elseif old_len - new_len > 2
        num_mark = num_mark - 1;
    end

    Rwaves= [Rwaves, maxInd];
end

% after we extracted the R peaks indiced, we will create a support vector
% for the signal, indicating if a given sample belongs to a QRS complex (label 1) or
% not (label 0)
Rwaves = unique(Rwaves);
support_vec = zeros(1, length(ECG));
half_window_size = 50;                       % typical QRS complex is 0.06 - 0.1 seconds thus up to 100 samples in our signal
for i = 1:length(Rwaves)
    support_vec(Rwaves(i) - half_window_size : Rwaves(i) + half_window_size) = 1;
end

save('ECG_1_tomer_qrs', 'support_vec');
save('ECG_1_tomer_peaks', 'Rwaves');