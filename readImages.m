% Create a list of all pictures in a directory and the exposure settings
%
% Enter the directory name to search for. Must include a .txt file named
% list.txt.

function [filenames, exposures, numExposures] = readImages(dirName)

    % read the list.txt file and extract strings
    file = fopen(strcat(dirName,'list.txt'));
    numExposures = 0;
    imagelist = {};
    filenames = {};
    exposures = [];
    
    while ~feof(file)
        imagename = textscan(file,'%s',1);
        exposure = textscan(file,'%f',1);
        imagelist = [imagelist imagename];
        exposures = [exposures exposure];
        numExposures = numExposures + 1;
    end
       
    for i = 1:size(imagelist,2)
        filenames = [filenames strcat(dirName,imagelist{1,i})];
    end    
    
    % sort ascending by exposure
    exposures = [exposures{:}];
    [exposures, indices] = sort(exposures, 'descend');
    filenames = filenames(indices);
    