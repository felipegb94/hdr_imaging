function [ m ] = array_to_matrix( array, numCols )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[rows, cols] = size(array);

numRows = rows / numCols;
m = zeros(numRows, numCols);
index = 1;

for i = 1 : numRows
    
    for j = 1:numCols
        
        m(i, j) = array(index);
        index = index + 1;
        
    end
    
end

