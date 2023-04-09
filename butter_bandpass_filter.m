function y = butter_bandpass_filter(data, lowcut, highcut, fs, order)
nyq = 0.5 * fs;
	low = lowcut / nyq;
	high = highcut / nyq;
	[b,a]= butter(order, [low high]);
    y=filter(b,a,data);
end

