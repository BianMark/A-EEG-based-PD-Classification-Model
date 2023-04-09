clear
disp("Start processing")
% The EEG data are segmented into pieces of 6-s epoch, then get the PSD of 4 frequency bands for each channels 
%% input the data from EEG file
EEG=importdata('PreprocessedData\hc1021.mat');
data = [];
data = [data;EEG.data'];
data = double(data);
signal = data;
[samples,channals] = size(data);
frequency = 500;
time_win = 6; % the length of time window is 6s
segments = floor(samples./frequency./time_win); % number of segments
%% extract the PSD of 4 bands from each channels
psd_decomposed = [];
for i = 1:channals
    delta = butter_bandpass_filter(data(:,i), 0.1, 4, frequency,3);  % extract 4 frequency bands from each channels
    theta = butter_bandpass_filter(data(:,i), 4, 8, frequency,3);
    alpha = butter_bandpass_filter(data(:,i), 8, 13, frequency,3);
    beta  = butter_bandpass_filter(data(:,i), 13, 30, frequency,3);

    psd_delta = [];
    psd_theta = [];
    psd_alpha = [];
    psd_beta  = [];
        for j = 1:segments   % extract the PSD from 4 bands for each segment
            psd_delta = [psd_delta;compute_psd(delta(((j-1)*frequency*time_win+1):j*frequency*time_win, 1))]; 
            psd_theta = [psd_theta;compute_psd(theta(((j-1)*frequency*time_win+1):j*frequency*time_win, 1))]; 
            psd_alpha = [psd_alpha;compute_psd(alpha(((j-1)*frequency*time_win+1):j*frequency*time_win, 1))]; 
            psd_beta  = [psd_beta;compute_psd(beta(((j-1)*frequency*time_win+1):j*frequency*time_win, 1))];   
        end
    psd_temp = [];
    psd_temp = [psd_temp; psd_delta,psd_theta,psd_alpha,psd_beta];
    psd_decomposed = [psd_decomposed,psd_temp];
end
psd_decomposed = reshape(psd_decomposed,segments,(channals*4)); % check if the psd_decomposed has right rows and cols
%% Set the class
Class = ones(segments,1);  % class 1 means hc
%Class = zeros(segments,1); % class 0 means pd
psd_decomposed = [psd_decomposed,Class];

disp("End processing")

