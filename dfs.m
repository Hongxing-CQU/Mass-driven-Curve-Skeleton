function [re,solute] = dfs(A,result,classNumValue)
    %获取维度
    n=length(result);
    %保存孤立点
    solute=[];
    %堆栈顶
    top=1;
    %如果a类遍历完毕，则退出
    if length(find(result>=classNumValue))==0
        re=[];
        solute=[];
        return
    end
    %将a类第一个节点入栈
    for i=1:length(result)
        if result(i)>=classNumValue
            stack(top)=find(result(i)== result);
            break;
        end
    end
    %标记某个节点是否访问过了
    flag=1;
    %%为添加b类节点的最终结果
    re=[];
    %判断堆栈是否为空
    while top~=0
        %搜寻下一个节点前的堆栈长度
        pre_len=length(stack);
        %取堆栈顶节点
        i=stack(top);
        for j=1:n
            %如果节点相连并且没有访问过并且是同一类a(值>=classNumValue)
            if A(i,j)==1 && isempty(find(flag==j,1)) && result(j)>=classNumValue
                %扩展堆栈
                top=top+1;
                %新节点入栈
                stack(top)=j;
                %对新节点进行标记
                flag=[flag j];
                %将边存入结果
                re=[re; i j];
                break;
            end
        end
        %孤立点时
        if isempty(re)
            result(stack(top))=0;
            solute=[solute,stack(top)];
        end
        %如果堆栈长度没有增加，则节点开始出栈
        if length(stack)==pre_len
            stack(top)=[];
            top=top-1;
        end

    end
end