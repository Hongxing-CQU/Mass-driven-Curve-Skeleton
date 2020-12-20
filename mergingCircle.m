function [ skelTwo,massSkelTwo ] = mergingCircle( skel, massSkel,nonCircle,circle ,boolCircle,boolNonCircle, OT)
% skel 骨架点位置
% massSkel 骨架点的质量
% nonCircle  不存在环的缺失点
% circle 存在环的缺失点
% skelTwo  调整后的骨架点位置
% massSkelTwo 调整后的骨架点质量
skelTwo = skel;
massSkelTwo = massSkel;

if boolCircle
    deletePoint = circle{1}(1);
    minMass = massSkelTwo(circle{1}(1));
    for i=1:size(circle,2)           
       for j = 1 : size(circle{i},2) 
           if minMass > massSkelTwo(circle{i}(j))
               minMass = massSkelTwo(circle{i}(j));
               deletePoint = circle{i}(j);
           end           
       end
    end
    
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
        massSkelTwo(m,:) = [];
        skelTwo(m,:)=[];       
        for i=1:size(OT,1)
            massSkelTwo(i,1) = sum(OT(i,:));
        end   
        sumMassSkel = sum(massSkelTwo);
        for i=1:size(OT,1)
            massSkelTwo(i,:) = massSkelTwo(i,:)/sumMassSkel;
        end    
   
else
%     if boolNonCircle
%         for i=1:size(nonCircle,2)
%             tempSumMass = 0;
%             for j = 1 : size(nonCircle{i},2)
%                 tempSumMass = tempSumMass + massSkelTwo(nonCircle{i}(j));
%             end
%             averageMass = tempSumMass / size(nonCircle{i},2);
%             for j = 1 : size(nonCircle{i},2)
%                 massSkelTwo(nonCircle{i}(j)) = averageMass;
%             end            
%         end
%     end
   
end

end

