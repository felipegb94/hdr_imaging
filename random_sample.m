function [ Zr_sample, Zg_sample, Zb_sample, idx ] = random_sample( Zr, Zg, Zb, numSamples )
% Get a random sampling of the 3 color channels

[Zr_sample,idx] = datasample(Zr, numSamples, 1);
[rows, cols] = size(Zr_sample);
Zg_sample = zeros(rows, cols);
Zb_sample = zeros(rows, cols);

%keyboard
for i = 1:size(Zr,2)
    %index = idx(i);
    Zg_sample(:,i) = Zg(idx,i);
    Zb_sample(:,i) = Zb(idx,i);  
end

