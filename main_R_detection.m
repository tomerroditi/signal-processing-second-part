clc; clear all; close all;
tic
% define the grid noise freq
PLFREQ1 = 42.386666666666660;
PLFREQ2 = 59.184000000000000;
PLFREQ3 = 37.553333333333335;
PLFREQ4 = 66.594666666666670;

%import all ecg signals
ecg1 = load('ECG_316048396_01.mat');
ecg2 = load('ECG_316048396_02.mat');
ecg3 = load('ECG_208119719_01.mat');
ecg4 = load('ECG_208119719_02.mat');

ecg1 = ecg1.sig;
ecg2 = ecg2.sig;
ecg3 = ecg3.sig;
ecg4 = ecg4.sig;

% R-wave detection 

% signal = Filter_sig(ecg1, PLFREQ1);   % notch filter for grid noise and other noises
% plot(signal);

Rwaves.R1 = Rwave_detection(ecg1 ,PLFREQ1); 
Rwaves.R2 = Rwave_detection(ecg2 ,PLFREQ2); 


% % HR plot
% figure(6)
% peaks = Rwaves.R2;
% RR=(peaks(2:end) - peaks(1:end - 1))./1000;
% heart_rate=1./RR;
% plot(peaks(11:end)./1000,heart_rate(10:end)); xlabel('Time [sec]'); ylabel('Heart Rate [Beat/sec]'); title('ECG 316048396 02 heart rate')


%% save the peaks vectors as instructed
save('316048396.mat','Rwaves');

toc

