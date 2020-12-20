%删除度为1的节点的边
function [ lj ] = deleteone( lj )
for m=1:size(lj,1)
    for i=1:size(lj,1)
     adj=find(lj(i,:)>0);
        if length(adj)==1
            lj(i,adj)=0;
            lj(adj,i)=0;
        end
    end
end
end