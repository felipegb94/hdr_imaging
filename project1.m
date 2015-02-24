%% CS 766 Project 1 - HDR Imaging
% Isaac Sung and Felipe Gutierrez
%
% Create an High Dynamic Range Image (HDR)
% 
% Steps (Book): 
%
%   # Preprocessing: I/O, sampling, etc.
%   # Estimate the radiometric response function from the aligned images.
%   # Estimate a radiance map by selecting or blending pixels from
%   different exposures.
%   # Tone map the resulting HDR image back into a displayable gamut.
%
%% Preprocessing

directory = './library/';
[filenames, exposures, numExposures] = readImages(directory);

% read in images
disp('Reading images...');
[Zr, Zg, Zb, numCols] = getZ(filenames, numExposures);

%read in images in lab space
[Zl, Za, Zb2, numCols_lab] = getZ_lab(filenames, numExposures);
[Z_rows, Z_cols] = size(Zr);

% smoothness factor
lambda = 50;

%% calculate the weights
w = zeros(256,1);
for i = 0:255
    w(i+1,1) = weight(i);
end
[Zr_sample, Zg_sample, Zb_sample, idx] = random_sample(Zr, Zg, Zb, 1000);

[Zl_sample, idx] = datasample(Zl, 1000, 1);

%% calculate log exposures
disp('Creating log exposures matrix B...')
B = zeros(numExposures,1);
for i = 1:numExposures
    B(:,i) = log(exposures(i));
end


%% Radiometric Response function
disp('Calculating radiometric response functions...');
[g_r, lE_r] = solveG(Zr_sample, B, lambda, w);
[g_g, lE_g] = solveG(Zg_sample, B, lambda, w);
[g_b, lE_b] = solveG(Zb_sample, B, lambda, w);

[g_l, lE_l] = solveG(Zl_sample, B, lambda, w);


%% Radiance Map Generation
disp('Generating radiance maps. R channel...');
rW = radianceWeights(g_r);
gW = radianceWeights(g_g);
bW = radianceWeights(g_b);
lW = radianceWeights(g_l);
lE_r = getRadianceMap(g_r, rW, Zr, B);
disp('Generating radiance maps. G channel...');
lE_g = getRadianceMap(g_g, gW, Zg, B);
disp('Generating radiance maps. B channel...');
lE_b = getRadianceMap(g_b, bW, Zb, B);
disp('Generating radiance maps. L channel...');
lE_l = getRadianceMap(g_l, lW, Zl, B);

% Go from vector to matrix
lE_r = array_to_matrix(lE_r, numCols);
lE_g = array_to_matrix(lE_g, numCols);
lE_b = array_to_matrix(lE_b, numCols);
lE_l = array_to_matrix(lE_l, numCols_lab);

[rows, cols, dummy] = size(lE_r);

% reconstruct the HDR image
hdr_image = zeros(rows, cols, 3);
hdr_image(:,:,1) = lE_r;
hdr_image(:,:,2) = lE_g;
hdr_image(:,:,3) = lE_b;

hdr_image_lab = zeros(rows, cols, 1);
hdr_image_lab(:,:,1) = lE_l;
hdr_image_lab(:,:,2) = Za;
hdr_image_lab(:,:,3) = Zb2;


%% Tone Mapping
disp('Applying tone mapping...');
% Reinhard's local operator
saturation = 0.3;
eps = 0.05;
phi = 8;
rgbLocal = reinhardLocal(hdr_image, saturation, eps, phi);

% Reinahrd's global operator
a = 0.50;
rgbGlobal = reinhardGlobal(hdr_image, a, saturation);

% Lab space
labGlobal = reinhardGlobal_lab(hdr_image_lab, a, saturation);
labGlobal(:,:,2) = Za;
labGlobal(:,:,3) = Zb2;

labTonemap = tonemap(hdr_image_lab);
labTonemap(:,:,2) = Za;
labTonemap(:,:,3) = Zb2;

labGlobal = lab2rgb(labGlobal);
%labTonemap = lab2rgb(labTonemap);

rgb = tonemap(hdr_image);

figure
subplot(2,2,1);
imshow(labGlobal);
title('Lab global operator');
subplot(2,2,2);
imshow(rgb);
title('Matlab tone mapping');
subplot(2,2,3);
imshow(rgbGlobal);
title('Reinhards global operator');
subplot(2,2,4);
imshow(rgbLocal);
title('Reinhards local operator');


imwrite(rgb, 'library_HDR.jpg');
imwrite(rgbGlobal, 'library_HDR_global.jpg');
imwrite(rgbLocal, 'library_HDR_local.jpg');
imwrite(labGlobal, 'library_HDR_lab_only_l_global.jpg');


%imwrite(labTonemap, 'library_HDR_lab_only_l_tonemap.jpg');
