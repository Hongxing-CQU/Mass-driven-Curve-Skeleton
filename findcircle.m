function [boolcircle,circleindex,circle,boolnocircle,nocircleindex,nocircle]= findcircle(ClassAA,skel,lianjie)
    %找环
lj=zeros(size(skel,1),size(skel,1));
ll=lianjie;
lip=1;
flag=1;
nocircleindex=[];
circle={};
nocircle={};
circleindex=[];
for k=1:size(ClassAA,2)
    nocircleindex=[nocircleindex k];
    for i=1:length(ClassAA{k})
        for j=1:length(ClassAA{k})
            a=ClassAA{k}(i);
            b=ClassAA{k}(j);
            if ll(a,b)==1
                lj(a,b)=1;
            end
        end
    end
    loop=[]; %初始化环
    for i=1:size(lianjie,1)
        lj=deletetwo(loop,lj);  %删除环中度数为2的节点的边
        lj=deleteone(lj);   %删除度数为1的节点的边
        if lj==0
            break; %邻接矩阵为零矩阵时停止查找
        end
        d=findd(lj);    %查找非零度节点
        loop=findloop(d,lj);   %找出环
        if ~isempty(loop)
            disp('有环');
            disp(k);
        end
        disp(loop);   %输出环的节点
        circle{lip}=loop;
        circleindex=[circleindex k];
        lip=lip+1;
    end
end
%     if isempty(circle)
%         boolcircle=0;
%     else
%         boolcircle=1;
%     end
    boolcircle=~isempty(circle);
    for i=1:size(circleindex,2)
        x=find(nocircleindex==circleindex(i));
        nocircleindex(x)=[];
    end
    for i=1:length(nocircleindex)
        nocircle{flag}=ClassAA{nocircleindex(i)};
        flag=flag+1;
    end
    boolnocircle=~isempty(nocircle);
end