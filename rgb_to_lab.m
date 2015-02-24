
function [lab_img,l,a,b] = rgb_to_lab(src)

%load rgb image
rgb_img = imread(src);

%convert to lab
labTransformation = makecform('srgb2lab');
lab_img = applycform(rgb_img,labTransformation);

%seperate l,a,b
l = lab_img(:,:,1);
a = lab_img(:,:,2);
b = lab_img(:,:,3);

% figure(1), imshow(l); 
% title('l');
% figure(2), imshow(a);
% title('a');
% figure(3), imshow(b); 
% title('b');