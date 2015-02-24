function [ Zl, Za, Zb, cols ] = getZ_lab( filenames, numExposures )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
I = imread(num2str(cell2mat(filenames(1))));
[rows, cols, dummy] = size(I);
numRows = rows*cols;

Zl = zeros(numRows, numExposures);


for i = 1 : numExposures
    [lab_img,l,a,b] = rgb_to_lab(num2str(cell2mat(filenames(i))));
    
    if (i == 3)
        Za = a; 
        Zb= b; 
    end
    
    % Get pixel array and transpose it
    Zcol_l = mat_to_array(l).'; 

    
    Zl(:, i) = Zcol_l;

    
end

end

