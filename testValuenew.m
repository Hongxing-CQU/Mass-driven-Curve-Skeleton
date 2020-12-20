function [f1,f2,f3] = testValuenew(P,skel,V,in,T,n)
%计算三个方向的测试值
% P 采样点
% skel骨架点坐标
% V 三个方向向量
% in 传输到骨架点skel的采样点
% T 传输计划
% n 骨架点索引
%    aa=V(:,1);
%    bb=V(:,2);
%    cc=V(:,3);
   Pin=P(in,:);
   VV = V./repmat(sqrt(sum(V.^2,1)),size(V,1),1);
   v1=VV(:,1);
   v2=VV(:,2);
   v3=VV(:,3);
   newV=Pin-repmat(skel,size(Pin,1),1);
   massp = ones(size(Pin,1),1) ./ size(Pin,1);
   %f1
   A1=0;
   B1=0;
   for i=1:size(Pin,1)
        if newV(i,:)*v1>0
            A1=A1+newV(i,:)*v1*massp(i);
        else
            B1=B1-newV(i,:)*v1*massp(i);
        end
   end
   f1=abs(A1-B1)/abs(A1+B1);
   
   %f2
   A2=0;
   B2=0;
   for i=1:size(Pin,1)
        if newV(i,:)*v2>0
            A2=A2+newV(i,:)*v2*massp(i);
        else
            B2=B2-newV(i,:)*v2*massp(i);
        end
   end
   f2=abs(A2-B2)/abs(A2+B2);
   %f3
   A3=0;
   B3=0;
   for i=1:size(Pin,1)
        if newV(i,:)*v3>0
            A3=A3+newV(i,:)*v3*massp(i);
        else
            B3=B3-newV(i,:)*v3*massp(i);
        end
   end
   f3=abs(A3-B3)/abs(A3+B3);
%    t = T(n,:);
%     %1,2
%     left = 0;   right = 0;
%     a = V(:,1); b = V(:,2);
%     for i=1:length(in)
%         x = P(in(i),:);
%         c = skel - x;
%         flag = dot(c',cross(a,b));
%         if flag < 0
% %             left = left + 1;
%             left = left + t(in(i));
%         else
% %             right = right + 1;
%             right = right + t(in(i));
%         end
%     end
%     f1 = abs(right-left) / sum(t);
%     
%     %1,3
%     left = 0;   right = 0;
%     a = V(:,1); b = V(:,3);
%     for i=1:length(in)
%         x = P(in(i),:);
%         c = skel - x;
%         flag = dot(c',cross(a,b));
%          if flag < 0
% %             left = left + 1;
%             left = left + t(in(i));
%         else
% %             right = right + 1;
%             right = right + t(in(i));
%         end
%     end
%     f2 = abs(right-left) / sum(t);
%     
%     %2,3
%     left = 0;   right = 0;
%     a = V(:,2); b = V(:,3);
%     for i=1:length(in)
%         x = P(in(i),:);
%         c = skel - x;
%         flag = dot(c',cross(a,b));
%          if flag < 0
% %             left = left + 1;
%             left = left + t(in(i));
%         else
% %             right = right + 1;
%             right = right + t(in(i));
%         end
%     end
%     f3 = abs(right-left) / sum(t);
end

