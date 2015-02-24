%% returns the weights list for radiance map equation
function [ weights ] = radianceWeights(g)

weights = zeros(256, 1);
g2 = diff(g) + 0.1;
for i = 1:255
    weights(i,1) = g(i) / g2(i);
    if weights(i,1) < 0
        weights(i,1) = exp(weights(i,1));
    end
end

weights(256) = g(256) / g2(255);

weights = weights + 1;