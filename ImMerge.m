% 根据目前的实验代码的基本思想应该没问题，但代码比较慢，现在需要进一步改进：
% 1. 目前在骨架点融合中，每次只融合一个点，现在需要一次融合很多点：
%    现在的思路：每次找满足如下条件的点进行融合
%     不为骨架点且质量最小的点 （主点），与主点存在连接关系且距离主点最近的非骨架点
%    
%    加速的思路：
%    在原有思路的基础上，不满足于只找到两个点进行融合，而是一直找下去，再找到第一对点以后，继续寻找剩余点中，质量最小的不为骨架点的点（主点），
%     并同时寻找与其融合的点，这样一直循环下去，直到找完所有配对；
%    每一对按照原来的方法进行融合；：
% 
% 2. 目前的方案当中，每次融合完以后，都要重新初始化传输计划，这对计算最优传输计划是非常耗时的，现在修改思路如下：
%     每次融合完后，A B 两点融合为 A点，现在传输计划修改为，原先所有传输到 A B点的质量，修改为融合后全部传输到A。修改后的传输计划作为下一次计算点的位置
%     和最优传输计划的初始传输计划。


function[skelTwo,massSkel, OTTwo,mergepair,nonskelpoints] = ImMerge(P,OT,skelOne,mass_p)
  
  
  massSkel(size(skelOne,1),1) = 0;  %骨架点质量
  maxNumberSkel(size(skelOne, 1),1 ) = 0; % 记录传输到骨架点为最大质量的采样点的数量
  lineNumberSkel(size(skelOne, 1),1 ) = 0; % 最大的三个传输骨架点为线性的采样点的数量 包含 只有两个点的
  skeletonIndex(size(skelOne,1),1) = 0; %是骨架点为1，否则为0
  thresholdSkeletonPoint = 0.92; % 在所有传输给骨架点的采样点中，每个采样点被认为是传输到骨架上的点
  relationSkeleton(size(skelOne,1),size(skelOne,1))=0;  %骨架点连接关系
  needDelete = false;
 % thresholdTransport = 1/size(OT,2)*0.001; %每个采样点的质量有多少传输给两个最大的点
  
  %%%原来算法中判断是否为骨架点和确定连接关系部分
     for i = 1:size(OT,2)
          thresholdTransport=mass_p(i)*0.001;
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
                      relationSkeleton(len(2),maxCurrentIndex) =1;
                  else
                      relationSkeleton(maxCurrentIndex,len(1)) =1;
                      relationSkeleton(len(1),maxCurrentIndex) =1;
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
              relationSkeleton(mass(IX(1),1),mass(IX(2),1)) =1;
              relationSkeleton(mass(IX(1),1),mass(IX(3),1)) =1;
              end
          end
     end
     
  M = pdist2(skelOne,P);
  Tcost=OT.*M;
  cost(size(skelOne,1),1) = 0;
  for i = 1 : size(skelOne, 1)
      massSkel(i ,1) = sum(OT(i,:));
      cost(i,1)=sum(Tcost(i,:));
      if lineNumberSkel(i,1)/maxNumberSkel(i,1) > thresholdSkeletonPoint
           skeletonIndex(i,1) = 1;  %是骨架点为1，非骨架点为0
      end      
  end
  
  %%%融合算法
  nonskelpoints=find(skeletonIndex==0); %非骨架点
  indexSkel = 1;
  deletePoint=[];
  mergepoint=[];
  mergepair=[];
  [massC,nonskel]=sort(massSkel(nonskelpoints,:),'ascend');  %质量最小
%   [massC,nonskel]=sort(cost(nonskelpoints,:),'ascend');     %传输代价最小
  if ~isempty(nonskelpoints)
      IfNoMerge=true;  %是否未融合=true
      while (IfNoMerge)
%         [massC,nonskel]=min(massSkel(nonskelpoints,:)); %选择非骨架点中传输代价最小的点作为Candidate,  P1
        Candidate=nonskelpoints(nonskel(indexSkel),:);
        P1=skelOne(Candidate,:);
        if isempty(P1)
            break;
        end
        P2s=find(relationSkeleton(Candidate,:)==1); %与Candidate存在连接关系的骨架点
        deleteindex=[];
        for i=1:size(P2s,2)
            if isempty(find(nonskelpoints==P2s(i)))
                deleteindex=[deleteindex i];
            end
        end
        P2s(deleteindex)=[];            %与Candidate存在连接关系的非骨架点
            if ~isempty(P2s)
                P2i=skelOne(P2s,:);
                P2index=P2s(findNei(P1,P2i));       %P2的索引
                p2_p1=find(deletePoint==P2index);
                if ~isempty(p2_p1)
                    break;
                end
                P2=skelOne(P2index,:);         %选择与Candidate存在连接关系的最近非骨架点 P2
                m1=massSkel(Candidate,:);       %P1接受的质量
                m2=massSkel(P2index,:);     %P2接受的质量
                P2=(P1 * m1 + P2 * m2)/(m1 + m2);   %   计算新的骨架点位置
                skelOne(P2index,:)=P2;
                massSkel(P2index,:)=m1+m2;  
                deletePoint=[deletePoint;Candidate];  %删除点P1
                mergepoint=[mergepoint;P2index];      %与P1对应的融合点P2
                mergepair=[mergepair;Candidate P2index]; %融合的骨架点对
                needDelete=true;
%                 IfNoMerge=false;    %是否未融合= false
            end
            indexSkel = indexSkel + 1;
            if indexSkel > size(nonskel, 1)
                IfNoMerge=false;
            end
%             deletePoint=Candidate;  %删除点P1
%             needDelete=true;
%             if IfNoMerge==true;
%                  break;
%             end
      end
  end
  
   %原来算法中删除点的算法
 if needDelete
%      SortdeletePoint=sort(deletePoint,'ascend');
     for k=1:size(deletePoint)
          m = deletePoint(k);
%           m=SortdeletePoint(k)-(k-1);
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
     end
        m=deletePoint;
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