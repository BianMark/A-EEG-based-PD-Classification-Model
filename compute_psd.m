function y = compute_psd(signal)
pxx=pwelch(signal);   
y = sum(10*log10(pxx))/length(pxx);
end