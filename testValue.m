function [f1,f2,f3] = testValue(P,skel,V,in,T,n)
%计算三个方向的测试值
% P 采样点
% skel骨架点坐标
% V 三个方向向量
% in 传输到骨架点skel的采样点
% T 传输计划
% n 骨架点索引
   t = T(n,:);
    %1,2
    left = 0;   right = 0;
    a = V(:,1); b = V(:,2);
    for i=1:length(in)
        x = P(in(i),:);
        c = skel - x;
        flag = dot(c',cross(a,b));
        if flag < 0
%             left = left + 1;
            left = left + t(in(i));
        else
%             right = right + 1;
            right = right + t(in(i));
        end
    end
    f1 = abs(right-left) / sum(t);
    
    %1,3
    left = 0;   right = 0;
    a = V(:,1); b = V(:,3);
    for i=1:length(in)
        x = P(in(i),:);
        c = skel - x;
        flag = dot(c',cross(a,b));
         if flag < 0
%             left = left + 1;
            left = left + t(in(i));
        else
%             right = right + 1;
            right = right + t(in(i));
        end
    end
    f2 = abs(right-left) / sum(t);
    
    %2,3
    left = 0;   right = 0;
    a = V(:,2); b = V(:,3);
    for i=1:length(in)
        x = P(in(i),:);
        c = skel - x;
        flag = dot(c',cross(a,b));
         if flag < 0
%             left = left + 1;
            left = left + t(in(i));
        else
%             right = right + 1;
            right = right + t(in(i));
        end
    end
    f3 = abs(right-left) / sum(t);
end

