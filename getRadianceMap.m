% Calculate the HDR image by using weighted averaging.
%
% Input:
%
% * g(z) = inverse response curve E, log exposure corresponding to pixel.
% Vector of size 256, each element corresponds to one pixel (0-255).
%
% * Z(i,j) = pixel values (either R G or B) of pixel at location i from
% image j. So the matrix dimensions are: Number of Pixels * Number of
% Images
% 
% * B(j) = Vector that contains the log delta t (shutter speed) used when
% taking each image j.
% 
% Output:
%
% * lE(i): Vector that contains the weighted sum of all pixels at location
% i for each image. This is done to obtain a better estimation of lE, than
% the one obtained when solving the overdetermined system.
%
%

function [lE] = getRadianceMap(g, w, Z, B)

[numRows_Z, numCols_Z] = size(Z);
lE = zeros(numRows_Z, 1); % Num of rows in Z is the number of pixels per image

for i = 1 : numRows_Z
    
    numerator = 0;
    denominator = 0;
    
    for j = 1 : numCols_Z
        
        pixelVal = Z(i, j);
        weightedVal = w(pixelVal+1);
        
        numerator = numerator + (weightedVal * (g(pixelVal+1) - B(j)));   
        denominator = denominator + weightedVal;
        
    end
    
    lE(i) = numerator/denominator;
    lE(i) = exp(lE(i));
end

