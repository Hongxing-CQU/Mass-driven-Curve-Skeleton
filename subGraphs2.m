function [tmpA,ClassA,ClassAA,boolClassNum] = subGraphs2(A,result,classNumValue,skel)
    tmpA=zeros(size(A));
    lianjie=A;
    %分类存储
    ClassAA={};ClassA=[];ClassB=[];
    %获取维度
    n=length(result);
    %深度遍历
    saveNode=[1];num=0;
%     figure
%     plot3(skel(:,1),skel(:,2),skel(:,3),'.','color',[1 0 0],'MarkerSize',20);
%     for i=1:size(skel,1)
%         for j=i:size(skel,1)
%             if lianjie(i,j) == 1 
%                 hold on
%                 plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0]);
%             end
%         end
%     end
    while(saveNode~=0) 
        saveNode=[];
        num=num+1;
        %深度遍历得到连通子图
        [re,solute]=dfs(A,result,classNumValue);
        if re~=0       
            tmpre=re;
            ind1=tmpre(:,1);
            ind2=tmpre(:,2);
            tmpA(ind1(1),ind2(1))=1;
            tmpA(ind2(1),ind1(1))=1;
            saveNode=[saveNode,ind1(1),ind2(1)];
            ClassA=[ClassA,ind1(1),ind2(1)];
            ClassAA{num}=saveNode;
            for i=1:length(tmpre)
                                                            if i>length(ind2)
                                                                break;
                                                            end
                if length(find(ind2(i)==saveNode))==0
                    tmpA(ind1(i),ind2(i))=1;
                    tmpA(ind2(i),ind1(i))=1;
                    %用一个变量存储用过节点
                    saveNode=[saveNode,ind2(i)];
                    ClassA=[ClassA,saveNode];
                    ClassAA{num}=saveNode;
                end
            end
            %判断单个点是否相连
            for i=1:length(saveNode)
                for j=1:length(saveNode)
                    if A(saveNode(i),saveNode(j))==1
                        tmpA(saveNode(i),saveNode(j))=1;
                        tmpA(saveNode(j),saveNode(i))=1;
                    end
                end
            end
            %把所有用过的节点质量改为0
            for i=1:length(saveNode)
                result(saveNode(i))=0;
            end
        else
            saveNode=[saveNode,solute];
            ClassA=[ClassA,solute];
            ClassAA{num}=saveNode;
            result(solute)=0;
        end
        %作图部分
%         hold on
%         plot3(skel(saveNode,1),skel(saveNode,2),skel(saveNode,3),'.','color',[0 0 1],'MarkerSize',20);
%         NodeColor=rand(1,3);
%         for i=1:size(skel,1)
%             for j=i:size(skel,1)
%                 if tmpA(i,j) == 1 
%                     hold on
%                     plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',NodeColor,'LineWidth',2);
%                 end
%             end
%         end
    end
%加入节点--条件是：1、另外的类b(标记权值>=0.2)；2、长度为1,既只有一个其他类的点
    %布尔变量判断是否存在另外一类(boolClassNum=0表示有两类，boolClassNum=1表示只有一类)
    %先找到a类(当前值==1)节点
    ClassA=unique(ClassA);
    boolClassNum=0;
    if length(ClassA)==length(result) || length(ClassA)==0
        boolClassNum=1;
    end
    
    ClassANum=length(ClassA);
    if ClassANum~=0
        %根据连接关系找到与a类节点相连接的b类节点
        for i=1:ClassANum
            for j=1:n
                if A(ClassA(i),j)~=0 && result(j)<classNumValue && (length(find(j==ClassB))==0) && result(j)>0
                   ClassB=[ClassB,j];
                end
            end
        end
        %根据b类节点确定连接关系
        %tmpA=zeros(size(tmpA));
        for i=1:length(ClassB)
            for j=1:n
                if A(ClassB(i),j)~=0 &&  result(j)==0
                %其中一个唯一有链接关系的异类节点
                    %找到这个节点
                    thisNode=ClassB(i); 
                    tmpA(ClassB(i),j)=1;
                    tmpA(j,ClassB(i))=1;

%                     hold on
%                     plot3(skel(thisNode,1),skel(thisNode,2),skel(thisNode,3),'.','color',[0 1 0],'MarkerSize',20);
%                     NodeColor1=rand(1,3);
%                     for s1=1:size(skel,1)
%                         for s2=s1:size(skel,1)
%                              if tmpA(s1,s2) == 1 
%                                  hold on
%                                  plot3([skel(s1,1) skel(s2,1)],[skel(s1,2) skel(s2,2)],[skel(s1,3) skel(s2,3)],'color',NodeColor1,'LineWidth',2);
%                              end
%                         end
%                     end  

                end
            end
        end  
        %对于A类的所有相邻点，如果不是同一类的话，则输出该点和相邻点
        %如果是同一类点的话，找这两个点的所有非同类相邻点，以此类推
        %清除空值
        tmpClassAA={};
        for i=1:length(ClassAA)
            if length(ClassAA{i})~=0
                tmpClassAA=[tmpClassAA,ClassAA{i}];
            end
        end
        ClassAA=tmpClassAA;
        for i=1:length(ClassAA)
            addNode=[];
            for j=1:length(ClassAA{i})
                tmp=ClassAA{i}(j);
                for k=1:n
                    if tmpA(tmp,k)~=0 && result(k)<classNumValue &&result(k)>0
                        addNode=[addNode,k];
                    end
                end
            end
            ClassAA{i}=[ClassAA{i},addNode];
        end
    end
end