% This function computes the Reinhard global tone mapping algorithm
function [ pic ] = reinhardGlobal( hdr, a, sat)

luminanceMap = luminance(hdr);

numPixels = size(hdr,1) * size(hdr,2);

% small delta to avoid taking log(0)
d = 0.00001;

% compute key
key = exp((1/numPixels)*(sum(sum(log(luminanceMap + d)))));

% scale to desired brightness level
scaledLuminance = luminanceMap * (a/key);

newLuminanceMap = scaledLuminance ./ (scaledLuminance + 1);
pic = zeros(size(hdr));

for i=1:3   
    % value must be between 0 an 1
    % so apply clamping
    pic(:,:,i) = ((hdr(:,:,i) ./ luminanceMap) .^ sat) .* newLuminanceMap;
end

idx = find(pic > 1);
pic(idx) = 1;