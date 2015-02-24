function [ img ] = KrawczykAnchoring_Tonemap( hdr )
% KrawczykLightness_Tonemap:
%   
%   This function attemps to implement the tone mapping algorithm described
%   in the paper: "Lightness Perception in Tone Reproduction for High
%   Dynamic Range Images". The algorithm is based on the theories of
%   lightness perception such as lightness constancy. 
%
%   Link: http://pages.cs.wisc.edu/~lizhang/courses/cs766-2012f/projects/hdr/Krawczyk2005LPT.pdf
%

luminanceMap = log(luminance(hdr));

[pixelCounts, luminanceLevels] = imhist(luminanceMap);
hist = imhist(luminanceMap);
minLuminanceLevel = min(luminanceLevels(:));
maxLuminanceLevel = max(luminanceLevels(:));
range = maxLuminanceLevel - minLuminanceLevel;

[idx,C] = kmeans(hist, range); 

end

