function [arr] = mat_to_array(matrix)
    [rows,cols] = size(matrix);
    arr = zeros(1, rows*cols);
    counter = 1;
    for i = 1:rows
        for j = 1:cols
            arr(counter) = matrix(i,j);
            counter = counter + 1;
        end
    end
    
    
