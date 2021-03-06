function [xy_ij,p_xy_ij] = NyquistSample(z,signal)

sampleRate = 1./mean(diff(z));
dz = mean(diff(z));

if max(signal) > min(signal)
y = (signal-min(signal))./(max(signal)-min(signal));
else
y = signal;
end

xy_ij = [];
p_xy_ij = [];

for tt = 1:length(z)
    
    xy_ij = [xy_ij (z(tt)+dz.*randn(1,floor(y(tt)*sampleRate))).*ones(1,floor(y(tt)*sampleRate))];
    p_xy_ij = [p_xy_ij y(tt).*ones(1,floor(y(tt)*sampleRate))];
    
end

end

