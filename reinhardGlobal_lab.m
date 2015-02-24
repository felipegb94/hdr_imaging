function [ pic ] = reinhardGlobal_lab( hdr_lab, a, sat )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
luminanceMap = hdr_lab(:,:,1);

numPixels = size(hdr_lab,1) * size(hdr_lab,2);

% small delta to avoid taking log(0)
d = 0.00001;

% compute key
key = exp((1/numPixels)*(sum(sum(log(luminanceMap + d)))));

% scale to desired brightness level
scaledLuminance = luminanceMap * (a/key);

newLuminanceMap = scaledLuminance ./ (scaledLuminance + 1);
pic = zeros(size(hdr_lab));

for i=1:3   
    % value must be between 0 an 1
    % so apply clamping
    pic(:,:,i) = ((hdr_lab(:,:,i) ./ luminanceMap) .^ sat) .* newLuminanceMap;
end

idx = find(pic > 1);
pic(idx) = 1;

end

