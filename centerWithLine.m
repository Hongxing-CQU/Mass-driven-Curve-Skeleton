function [ skel ] = centerWithLine( P,skelOne,OT, neighborMatrix, weightValue )
%CENTER Summary of this function goes here
%   Detailed explanation goes here
% 输入; P点云，OT传输计划,neighborMatrix 邻接矩阵
% 输出：skel更新后的采样点坐标
% 计算距离矩阵
% 
lambda = weightValue;
distance = 9999999.00;
thresholdDistance = 0.0001;
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
        %计算的第一部分
        for j = 1:size(OT,2)
            tempA = OT(i,j)/d(i,j);
            A = A + tempA ;
            x = x + tempA * P(j,1);
            y = y + tempA * P(j,2);
            z = z + tempA * P(j,3);
        end
        
        neighborOne = find(neighborMatrix(i,:) > 0.5); %
        numNeighborOne = length(neighborOne);
        if numNeighborOne > 1
            A = A + 2 * lambda;
            for  j = 1: numNeighborOne
                neighborTwo = find(neighborMatrix(neighborOne(j),:) > 0.5); 
                numNeighborTwo = length(neighborTwo);
                if numNeighborTwo > 1
                     A = A + 2 *  lambda  / numNeighborTwo / numNeighborTwo;
                end
            end
        else
            for  j = 1: numNeighborOne
                neighborTwo = find(neighborMatrix(neighborOne(j),:) > 0.5); 
                numNeighborTwo = length(neighborTwo);
                if numNeighborTwo > 1
                     A = A + 2 * lambda / numNeighborTwo / numNeighborTwo;
                end
            end            
        end
        
        if numNeighborOne > 1
            tempX = 0.0;
            tempY = 0.0;
            tempZ = 0.0;
            for  j = 1 : numNeighborOne
                tempX = tempX + skelOne(neighborOne(j),1);
                tempY = tempY + skelOne(neighborOne(j),2);
                tempZ = tempZ + skelOne(neighborOne(j),3);                
            end
            
            x = x + tempX * 2  * lambda / numNeighborOne;
            y = y + tempY * 2  * lambda  / numNeighborOne;
            z = z + tempZ * 2  * lambda  / numNeighborOne;
            
            for j = 1 : numNeighborOne
                neighborTwo = find(neighborMatrix(neighborOne(j),:) > 0.5); 
                numNeighborTwo = length(neighborTwo);
                if numNeighborTwo > 1
                     tempX = 0.0;
                     tempY = 0.0;
                     tempZ = 0.0;
                     for k = 1 : numNeighborTwo
                         if neighborTwo(k) ~= i
                             tempX = tempX + skelOne(neighborTwo(k),1);
                             tempY = tempY + skelOne(neighborTwo(k),2);
                             tempZ = tempZ + skelOne(neighborTwo(k),3);                             
                         end                         
                     end
                     
                     tempX = tempX / numNeighborTwo;
                     tempY = tempY / numNeighborTwo;
                     tempZ = tempZ / numNeighborTwo;    
                     
                     tempX = skelOne(neighborOne(j),1) - tempX;
                     tempY = skelOne(neighborOne(j),2) - tempY;
                     tempZ = skelOne(neighborOne(j),3) - tempZ; 
                     
                     tempX = tempX / numNeighborTwo;
                     tempY = tempY / numNeighborTwo;
                     tempZ = tempZ / numNeighborTwo;   
                     
                     x = x + 2 * lambda * tempX;
                     y = y + 2 * lambda * tempY;
                     z = z + 2 * lambda * tempZ;   
                end
            end
        else
             for j = 1 : numNeighborOne
                neighborTwo = find(neighborMatrix(neighborOne(j),:) > 0.5); 
                numNeighborTwo = length(neighborTwo);
                if numNeighborTwo > 1
                     tempX = 0.0;
                     tempY = 0.0;
                     tempZ = 0.0;
                     for k = 1 : numNeighborTwo
                         if neighborTwo(k) ~= i
                             tempX = tempX + skelOne(neighborTwo(k),1);
                             tempY = tempY + skelOne(neighborTwo(k),2);
                             tempZ = tempZ + skelOne(neighborTwo(k),3);                             
                         end                         
                     end
                     
                     tempX = tempX / numNeighborTwo;
                     tempY = tempY / numNeighborTwo;
                     tempZ = tempZ / numNeighborTwo;    
                     
                     tempX = skelOne(neighborOne(j),1) - tempX;
                     tempY = skelOne(neighborOne(j),2) - tempY;
                     tempZ = skelOne(neighborOne(j),3) - tempZ; 
                     
                     tempX = tempX / numNeighborTwo;
                     tempY = tempY / numNeighborTwo;
                     tempZ = tempZ / numNeighborTwo;   
                     
                     x = x + 2 * lambda * tempX;
                     y = y + 2 * lambda * tempY;
                     z = z + 2 * lambda * tempZ;   
                end
            end
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



