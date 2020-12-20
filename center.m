function [ skel ] = center( P,skelOne,OT )
%CENTER Summary of this function goes here
%   Detailed explanation goes here
% 输入; P点云，OT传输计划
% 输出：skel更新后的采样点坐标
% 计算距离矩阵
distance = 9999999.00;
thresholdDistance = 0.1;
skel = skelOne;
theta = 0.2;
while distance > thresholdDistance
    d = pdist2(skelOne,P);
    d = sqrt(d);
    for i = 1:size(OT,1)
        for j=1:size(OT,2)
            if d(i,j) < 10e-6;
                d(i,j) = 10e-6;
            end
        end
    end
    
    distance = 0.0;
    for i=1:size(OT,1)
        A = 0;
        x = 0.0;
        y  = 0.0;
        z = 0.0;
        for j = 1:size(OT,2)
            tempA = OT(i,j)/d(i,j);
            A = A + tempA ;
            x = x + tempA * P(j,1);
            y = y + tempA * P(j,2);
            z = z + tempA * P(j,3);
        end
        skel(i,1) = (1-theta)* skelOne(i,1) + theta * x / A;
        skel(i,2) = (1-theta)* skelOne(i,2) + theta * y / A;
        skel(i,3) = (1-theta)* skelOne(i,3) + theta * z / A; 
        
        tempDistance = (skel(i,1)-skelOne(i,1)) * (skel(i,1)-skelOne(i,1));
        tempDistance = tempDistance + (skel(i,2)-skelOne(i,2)) * (skel(i,2)-skelOne(i,2));
        tempDistance = tempDistance + (skel(i,3)-skelOne(i,3)) * (skel(i,3)-skelOne(i,3));        
        distance = distance + sqrt(tempDistance);
    end
    skelOne = skel;      
end
end



