function [ noisePoints ] = addGaussianNoise( points, ratio )
%addGaussianNoise Summary of this function goes here
%   Detailed explanation goes here
misDistance = 99999.0;
for i = 1:size(points,1)-1
    for j = i+1:size(points,1)
        distance = 0;
        for k = 1 : size(points,2)
            distance = distance + (points(i,k) - points(j,k)) * (points(i,k) - points(j,k));
        end
        if distance < misDistance  && distance > 0
            misDistance = distance;
        end
    end
end

misDistance = sqrt(misDistance);
noise=randn(size(points,1),size(points,2));
distG = noise*misDistance * ratio;
noisePoints = points;
for i=1:size(points,1)
    for j=1: size(points,2)
        noisePoints(i,j) = points(i,j) + distG(i,j);
    end
end
end

