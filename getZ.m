function [ Zr, Zg, Zb, cols ] = getZ(filenames, numImages)
%getZ: Creates the Z matrix for each RGB component

I = imread(num2str(cell2mat(filenames(1))));
[rows, cols, dummy] = size(I);
numRows = rows*cols;

Zr = zeros(numRows, numImages);
Zg = zeros(numRows, numImages);
Zb = zeros(numRows, numImages);

for i = 1 : numImages
    I = imread(num2str(cell2mat(filenames(i))));
    
    r = I(:,:,1);
    g = I(:,:,2);
    b = I(:,:,3);
    
    % Get pixel array and transpose it
    Zcol_r = mat_to_array(r).'; 
    Zcol_g = mat_to_array(g).';
    Zcol_b = mat_to_array(b).';
    
    Zr(:, i) = Zcol_r;
    Zg(:, i) = Zcol_g;
    Zb(:, i) = Zcol_b;
    
end

