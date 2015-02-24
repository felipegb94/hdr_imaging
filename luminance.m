function [ luminanceMap ] = luminance( image )
%Creates a luminance map from an image
%
% The input image should be rows*cols*3

luminanceMap = 0.2125 * image(:,:,1) + 0.7154 * image(:,:,2) + 0.0721 * image(:,:,3);

