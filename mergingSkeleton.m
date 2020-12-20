function[skelTwo,massSkel, OTTwo] = mergingSkeleton(OT,skelOne)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%输入传输计划OT，骨架点坐标skel
%更新后的传输计划OT，融合后的骨架点的坐标skel

  massSkel(size(skelOne,1),1) = 0;
  maxNumberSkel(size(skelOne, 1),1 ) = 0; % 记录传输到骨架点为最大质量的采样点的数量
  lineNumberSkel(size(skelOne, 1),1 ) = 0; % 最大的三个传输骨架点为线性的采样点的数量 包含 只有两个点的
  skeletonIndex(size(skelOne,1),1) = 0; %是骨架点为1，否则为0
  thresholdSkeletonPoint = 0.92; % 在所有传输给骨架点的采样点中，每个采样点被认为是传输到骨架上的点
  relationSkeleton(size(skelOne,1),size(skelOne,1))=0;  
  needDelete = false;
  thresholdTransport = 1/size(OT,2)*0.001; %每个采样点的质量有多少传输给两个最大的点
  
  for i = 1:size(OT,2)
      t = OT(:,i);
      len = find(t>thresholdTransport);
      mass = [];
      for j = 1 : length(len)
          mass = [mass;len(j),t(len(j))];
      end
    
      if length(len) <3  && length(len) > 1
          [maxValue maxValueIndex] = max(mass(:,2));
          maxCurrentIndex = len(maxValueIndex);
          maxNumberSkel(maxCurrentIndex,1) = maxNumberSkel(maxCurrentIndex,1)+1;
          lineNumberSkel(maxCurrentIndex,1) = lineNumberSkel(maxCurrentIndex,1)+1;
          if length(len) > 1
              if len(1)== maxCurrentIndex 
                  relationSkeleton(maxCurrentIndex,len(2)) =1;
              else
                  relationSkeleton(maxCurrentIndex,len(1)) =1;
              end
              
          end
      else if length(len) >2 
          [B,IX] = sort(mass(:,2),'descend');
          maxNumberSkel(mass(IX(1),1),1) =  maxNumberSkel(mass(IX(1),1),1) +1;
          
          lengthSideA = 0.0;
          lengthSideB = 0.0;
          lengthSideC = 0.0;
          
          for k = 1 : 3
              lengthSideC = lengthSideC + (skelOne(mass(IX(2),1),k) - skelOne(mass(IX(3),1),k)) * (skelOne(mass(IX(2),1),k) - skelOne(mass(IX(3),1),k));
              lengthSideA = lengthSideA + (skelOne(mass(IX(2),1),k) - skelOne(mass(IX(1),1),k)) * (skelOne(mass(IX(2),1),k) - skelOne(mass(IX(1),1),k));
              lengthSideB = lengthSideB + (skelOne(mass(IX(3),1),k) - skelOne(mass(IX(1),1),k)) * (skelOne(mass(IX(3),1),k) - skelOne(mass(IX(1),1),k));
          end
          
          cosAngle = (lengthSideA + lengthSideB - lengthSideC)/2/sqrt(lengthSideA)/sqrt(lengthSideB);
          if cosAngle < -0.9
              lineNumberSkel(mass(IX(1),1),1) = lineNumberSkel(mass(IX(1),1),1)+1;
          end
          end
      end
  end
 
  for i = 1 : size(skelOne, 1)
      massSkel(i ,1) = sum(OT(i,:));
      if lineNumberSkel(i,1)/maxNumberSkel(i,1) > thresholdSkeletonPoint
           skeletonIndex(i,1) = 1;
      end      
  end

  boolFindDeletePoint = true;
  indexSkel = 1;
 
  [massC,indexSkeleton] = sort(massSkel(:,1));

  while boolFindDeletePoint
       if skeletonIndex(indexSkeleton(indexSkel)) > 0.5  % 是骨架点
           indexSkel = indexSkel + 1;
       else
           j = 1;
           boolTemporary = true;
           while boolTemporary
               if  relationSkeleton(indexSkeleton(indexSkel),j) <  0.5 % 两个骨架点没有连接关系
                   j = j + 1;
                   if j > size(skelOne, 1)
                       boolTemporary = false;
                   end
               else
                   if  skeletonIndex(j,1) < 0.5 % 非骨架点
                       deletePoint = indexSkeleton(indexSkel);
                       needDelete = true;
                       boolTemporary = false;
                       boolFindDeletePoint = false;
                   else
                       j = j + 1;
                       if j > size(skelOne, 1)
                           boolTemporary = false;
                       end
                   end
                       
               end
                   
                   
           end
           indexSkel = indexSkel + 1;           
       end
       
       if indexSkel > size(skelOne, 1)
           boolFindDeletePoint = false;
       end       
  end
  

  % 把传输到删除骨架点的质量分配给最大的采样点上
 if needDelete
          m = deletePoint;
          t1 = OT(m,:);%m点对应的传输计划
          X = find(t1>0);%所有传输到骨架点m的质量大于0的采样点集X 
          for i =1 : length(X)
              tt = find(OT(:,X(i)) == max(OT(:,X(i))));
              if tt(1) == m
                  [B,IX] = sort(OT(:,i),'descend');
                  if IX(1) == m
                    OT(IX(2),X(i)) = OT(IX(2),X(i)) + OT(m,X(i));
                  else
                      OT(IX(1),X(i)) = OT(IX(1),X(i)) + OT(m,X(i));
                  end
              else
                  OT(tt,X(i)) = OT(tt,X(i))+ OT(m,X(i));
              end
          end

        OT(m,:) = [];
        OTTwo = OT;
        massSkel(m,:) = [];
        skelOne(m,:)=[];
        skelTwo = skelOne;
        for i=1:size(OT,1)
            massSkel(i,1) = sum(OT(i,:));
        end   
        sumMassSkel = sum(massSkel);
        for i=1:size(OT,1)
            massSkel(i,:) = massSkel(i,:)/sumMassSkel;
        end 
 else
        OTTwo = OT;
        skelTwo = skelOne;
        for i=1:size(OT,1)
            massSkel(i,1) = sum(OT(i,:));
        end   
        sumMassSkel = sum(massSkel);
        for i=1:size(OT,1)
            massSkel(i,:) = massSkel(i,:)/sumMassSkel;
        end 
     
 end
end

   
  
