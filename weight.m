% calculates the weight value
% 
% assumes zmin = 0
% zmax = 255
%
% z = a pixel value from 0-255

function w = weight(z)

zmin = 0;
zmax = 255;
threshold = 0.5*(zmin+zmax);

if z <= threshold
    w = (z - zmin)+1; % make sure it's never zero!
else
    w = (zmax - z)+1;
end

    

