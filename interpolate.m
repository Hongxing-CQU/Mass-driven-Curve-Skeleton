function [resultskel,resultlianjie]=interpolate(lianjie,skel,n)
resultskel=[];%新的骨架点位置
resultlianjie=[];%新的骨架连接关系

%新骨架
leaf = [];  %每个分支起始节点
index = [];
gan=[];
for i=1:size(lianjie,1)
    len = find(lianjie(i,:)>0);
    if length(len)==1
        leaf=[leaf;i];
    end
    index(i)=i;
end
%     %%%
%     leaf(6)=[];
%     %%%
snode=[];
lnode=[];
cskel=skel;
clianjie=lianjie;
sizegan=0;
for i=1:size(leaf,1)
    k=findK(lianjie,leaf(i),index); %每个分支的原始节点索引
    for g=1:size(k,1)-1
    cskel(k(g),:)=0;
    clianjie(k(g),:)=0;
    clianjie(:,k(g))=0;
    end
end
ga=find(cskel(:,1)>0);
%     %%%
%     ga(3)=[];
%     %%% 
if length(ga)>1
gan=[];
%主干
for i=1:size(ga,1)
    le=length(find(clianjie(ga(i),:)==1));
    if le==1
        gan=[gan;ga(i)];
        break;
    end
end
for i=1:size(ga,1)-1
    lg=find(clianjie(gan(end),:)==1);
    if length(lg)>1
    for j=1:size(lg,2)
        if find(gan==lg(j))
            lg(j)=[];
            break;
        end
    end
    end
    gan=[gan;lg];
end
    newSkel=[];
    rskel={};
    newSkel=skel(gan,:);  %分支骨架点
    d=pdist2(newSkel,newSkel);  %计算距离
    dl=0;   %每个分支总长度
    for m=1:size(d,1)
        if m==size(d,1)
            break;
        end
        dl=dl+d(m,m+1);
    end
    dm=min(d(d~=0));    %最小长度
    s=1/n;  %比例
    di=dm*s;
    xd=floor(dl/di);    %插入节点数
    dis=dl/xd;  %插入节点长度
    len=size(gan,1)-1;    
    for m=1:len
    sk=[];    
    p1=newSkel(m,:);
    p2=newSkel(m+1,:);
    dp=pdist2(p1,p2);
    ss=dis/dp;
    kx=0:ss:1;
    x=p1(1)+kx*(p2(1)-p1(1));   %插入节点位置x坐标
    y=p1(2)+kx*(p2(2)-p1(2));   %插入节点位置y坐标
    z=p1(3)+kx*(p2(3)-p1(3));   %插入节点位置z坐标
    for j=1:size(x,2)
        sk(j,:)=[x(j),y(j),z(j)];
    end
    if m==len 
        sk=[sk;p2];
    end
    if  length(sk(:,1))>1
        if sk(end,:)==sk(end-1,:)  
            sk(end,:)=[];
        end
    end
    rskel=[rskel; sk];
    end
    for j=1:size(rskel,1)
        resultskel=[resultskel;rskel{j}];   %新的骨架点
    end
    sizegan=size(resultskel,1);
end
    
%分支
for i=1:size(leaf,1)
    newSkel=[];
    rskel={};
    finds=[];
    k=findK(lianjie,leaf(i),index); %每个分支的原始节点索引
    newSkel=skel(k,:);  %分支骨架点
    d=pdist2(newSkel,newSkel);  %计算距离
    dl=0;   %每个分支总长度
    for m=1:size(d,1)
        if m==size(d,1)
            break;
        end
        dl=dl+d(m,m+1);
    end
    dm=min(d(d~=0));    %最小长度
    s=1/n;  %比例
%     %%%
%     if i==2
%         s=1/4;
%     end
%     if i==4 || i==5
%        s=1/1;
%     end
%     %%%
    di=dm*s;
    xd=floor(dl/di);    %插入节点数
    dis=dl/xd;  %插入节点长度
    len=size(k,1)-1;    
    for m=1:len
    sk=[];    
    p1=newSkel(m,:);
    if m>1
        sizerskel=size(rskel{m-1},1);
        p1=rskel{m-1}(sizerskel,:);
    end
    p2=newSkel(m+1,:);
    dp=pdist2(p1,p2);
    ss=dis/dp;
    kx=0:ss:1;
    x=p1(1)+kx*(p2(1)-p1(1));   %插入节点位置x坐标
    y=p1(2)+kx*(p2(2)-p1(2));   %插入节点位置y坐标
    z=p1(3)+kx*(p2(3)-p1(3));   %插入节点位置z坐标
    for j=1:size(x,2)
        sk(j,:)=[x(j),y(j),z(j)];
    end
    if m>1 
        sk(1,:)=[];
    end
    if m==len 
        sk=[sk;p2];
    end
    if  length(sk(:,1))>1
        if sk(end,:)==sk(end-1,:)  
            sk(end,:)=[];
        end
    end
    rskel=[rskel; sk];
    end

    for j=1:size(rskel,1)
        resultskel=[resultskel;rskel{j}];   %新的骨架点
    end
    finds=find(resultskel==resultskel(end,1));
    finds(end)=[];
    if finds 
        snode=[snode;finds];
        resultskel(end,:)=[];
        lnode=[lnode size(resultskel,1)];
    end
    
%     figure;
%     for kk=1:size(resultskel,1)
%         hold on;
%         plot3(resultskel(kk,1),resultskel(kk,2),resultskel(kk,3),'.','color',[0 1 0],'MarkerSize',20);
%     end
%     axis off,axis equal;
%     view(0,90);
%     asd=1;
    
end


%计算新的骨架点连接关系
 for i = 1 :  size(resultskel,1)
     if find(lnode==i) 
        continue;
     end
     if i>=sizegan
        if find(unique(snode)==i)
         continue;
        end
     end
%      %%%
%      if i==136 && n==3
%          continue;
%      end
%      if i==91 && n==2
%          continue;
%      end
%      %%%
     if i==size(resultskel,1)
         break;
     end
             resultlianjie(i,i+1) = 1;
             resultlianjie(i+1,i) = 1;
 end

 for i=1:size(lnode,2)
    resultlianjie(snode(i),lnode(i))=1;
    resultlianjie(lnode(i),snode(i))=1;
 end
 

end