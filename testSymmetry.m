function [ result ] = testSymmetry( P, skel, OT )
%计算每一个骨架点的对称性测试值
%   P 采样点
% skel 骨架点
% OT 传输计划
% result 测试值
result = [];
sumP=size(P,1);
 threshold=(1/sumP)*0.01;
for n=1:size(skel,1)
%    in1 = find(OT(n,:) > 10e-7);
      in1 = find(OT(n,:) > threshold);
%     in1=[];
%     for i=1:size(OT,2)
%        [~,maxid]=max(OT(:,i));
%        if maxid==n
%             in1=[in1 i];
%        end
%     end
    Pin1 = P(in1,:);
%     figure   
%     %axis off
%     hold on
%     plot3(Pin1(:,1),Pin1(:,2),Pin1(:,3),'.','color',[0 0 0],'MarkerSize',5);
%     hold on 
%     plot3(skel(n,1),skel(n,2),skel(n,3),'.','color',[1 0 0],'MarkerSize',20);
    meanMatrix = zeros(1,3);
    weightSum = 0.0;
%    for i =1:length(in1)
%        meanMatrix(1,1) =meanMatrix(1,1) + OT(n,in1(i)) * Pin1(i,1);
%        meanMatrix(1,2) =meanMatrix(1,2) + OT(n,in1(i))* Pin1(i,2);
%        meanMatrix(1,3) =meanMatrix(1,3) + OT(n,in1(i))* Pin1(i,3);
%        weightSum = weightSum + OT(n,in1(i));        
%    end
%    meanMatrix = meanMatrix/weightSum;
%     hold on
%     plot3(meanMatrix(:,1),meanMatrix(:,2),meanMatrix(:,3),'.','color',[1 0 0],'MarkerSize',20);
   
%    Pin = Pin1 - ones(size(Pin1,1), 1) * meanMatrix; 

     newPin1=Pin1-repmat(skel(n,:),size(Pin1,1),1);
%      Pin =  OT(n,in1) * newPin1;
     Pin =  newPin1;
 %       Pin=OT(n,in1)*Pin;
%      Pin =  OT(n,in1) * (Pin1 - P(n,:));
    covMatrix = (Pin' * Pin); 
    [V,D] = eig(covMatrix);  % 特征值分解

     [f1,f2,f3] = testValue(P,skel(n,:),V,in1,OT,n);    	% max(f1,f2,f3)就是testing value
%    [f1,f2,f3] = testValuenew(P,skel(n,:),V,in1,OT,n);    	% max(f1,f2,f3)就是testing value
    [f4,f5,f6] = testValuenew(P,skel(n,:),V,in1,OT,n);    	% max(f1,f2,f3)就是testing value
%     n1=[2,6,8,9];
%     n2=[1,3,4,5,7];
%     n1=[2,4,6,9];
%     n2=[1,3,5,7,8];
%     n1=[1,2,4,6,7,8,9];
%     if find(n==n1)
%         result = [result,max(max(f1,f2),f3)];
%     else
%         result=[result,max(f2,f3)];
%     end
%     f8=max(max(f1,f2),f3);
%     f9=max(max(f4,f5),f6);
% %     result = [result,max(max(f1,f2),f3)];
%     result = [result,max(f8,f9)];
%     result=[result,max(f1,f2)];

    re=[];
    re=[re f1 f2 f3];
    re=sort(re,'descend');
    re1=[];
    re1=[re1 f4 f5 f6];
    re1=sort(re1,'descend');
    rx1=re(2);
    rx2=re1(2);
    re3=max(rx1,rx2);
    result=[result,re3];
end
end

