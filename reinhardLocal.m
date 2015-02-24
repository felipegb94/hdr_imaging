% Calculates the Reinhard local tone mapping of the HDR image
% algorithm taken from: 
% http://www.cmap.polytechnique.fr/~peyre/cours/x2005signal/hdr_photographic.pdf
function [ pic ] = reinhardLocal( hdr, sat, eps, phi )

luminanceMap = luminance(hdr);

    alpha = 1 / (2*sqrt(2));
    key = 0.18;
    
    v1 = zeros(size(luminanceMap,1), size(luminanceMap,2), 8);
    v = zeros(size(luminanceMap,1), size(luminanceMap,2), 8);
  
    
    % compute 9 gaussian filters
    for scale=1:9
        s = 1.6 ^ (scale-1);
        sigma = alpha * s;
        
        % dicretize gaussian filter
        radius = ceil(2*sigma);
        kernelSize = 2*radius+1;
        
        kernelHoriz = fspecial('gaussian', [kernelSize 1], sigma);
        v1(:,:,scale) = conv2(luminanceMap, kernelHoriz, 'same');
        kernelVert = fspecial('gaussian', [1 kernelSize], sigma);
        v1(:,:,scale) = conv2(v1(:,:,scale), kernelVert, 'same');
    end
    
    for i = 1:8    
        v(:,:,i) = abs((v1(:,:,i)) - v1(:,:,i+1)) ./ ((2^phi)*key / (s^2) + v1(:,:,i));    
    end
    
    sm = zeros(size(v,1), size(v,2));
    
    for i=1:size(v,1)
        for j=1:size(v,2)
            for scale=1:size(v,3)
                if v(i,j,scale) > eps
                    if (scale == 1) 
                        sm(i,j) = 1;
                    end
                    
                    if (scale > 1)
                        sm(i,j) = scale-1;
                    end
                    break;
                end
            end
        end
    end
    
    idx = find(sm == 0);
    sm(idx) = 8;
    
    v2 = zeros(size(v,1), size(v,2));

    for x=1:size(v1,1)
        for y=1:size(v1,2)
            v2(x,y) = v1(x,y,sm(x,y));
        end
    end
    
    % Do tonemapping
    luminanceComp = luminanceMap ./ (1 + v2);

    pic = zeros(size(hdr));
    for i=1:3
    
        % make sure to do clamping
        pic(:,:,i) = ((hdr(:,:,i) ./ luminanceMap) .^ sat) .* luminanceComp;
    end

    % clamp pic 
    idx = find(pic > 1);
    pic(idx) = 1;

end