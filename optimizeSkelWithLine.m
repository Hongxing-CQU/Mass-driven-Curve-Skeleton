function [ skel, mass_s ] = optimizeSkelWithLine( points, skelOne, neighborMatrix, mass_p, lambda, weightValue )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
TPOne = 9999999; % 前一次的传输代价
TPTwo = 0;
thresholdTP = 0.0001; % 传输代价阈值
condition_OT = true;

%初始化骨架点的质量
skel = skelOne;
mass_s = zeros(size(skel,1),1);
nei = findNei(points,skel);
for i=1:size(skel,1)
   l = find(nei == i);
   mass_s(i) = length(l);
end
mass_s = mass_s ./ size(nei,1);
while (condition_OT)
    TPone = TPTwo;
    [OT,OTValue] = ot(points,skel,mass_p,mass_s,lambda);   % 计算传输计划
    skel = centerWithLine( points,skel,OT, neighborMatrix, weightValue );
    TPTwo = OTValue;
    if abs(TPone - TPTwo) < thresholdTP 
        condition_OT =false;
    end          
end
end
           