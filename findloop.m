%深度优先遍历
function [ loop ] = findloop( d,lj )
top=1;                  %堆栈顶
stack(top)=d(1);           %将第一个节点入栈
flag=1;                 %标记某个节点是否访问过了
re=[];                  
result=[];
loop=[];            %找出的环
while top~=0            %判断堆栈是否为空
    pre_len=length(stack);    %搜寻下一个节点前的堆栈长度
    i=stack(top);             %取堆栈顶节点
    for j=1:length(d)
       if  lj(i,d(j))==1 && ~isempty(find(flag==j,1)) %如果节点相连并且被访问过
           ind=find(stack==d(j));   %堆栈中找到被访问的节点索引
           if ind~=top-1    %非前一连接节点
            loop= stack(1,ind:length(stack));   %形成环
           end
           continue;
       end
       if lj(i,d(j))==1 && isempty(find(flag==j,1))    %如果节点相连并且没有访问过 
            top=top+1;                          %扩展堆栈
            stack(top)=d(j);                       %新节点入栈
%             disp(stack);
            flag=[flag j];                      %对新节点进行标记
            re=[re;i d(j)];                        %将边存入结果
            break;   
        end
    end    
     if lj(i,stack(top))==1
           result=stack;
     end
    if length(stack)==pre_len   %如果堆栈长度没有增加，则节点开始出栈
        stack(top)=[];
        top=top-1;
    end    
end
end