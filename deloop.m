function [OT,skel,lianjie,mass_s]=deloop(r,OT,skel,lianjie,mass_s,Datapoints)
P=Datapoints;
% r=r;
% OT=OT;
% skel=skel;

%分类阈值
classNumValue=0.15;
%tmpA是更新后的连接矩阵,ClassA是a类的节点子图，ClassAA是对节点按组分类
%(boolClassNum=0表示有两类，boolClassNum=1表示只有一类)
conditionRefine = true;
while(conditionRefine)
    result=testSymmetry(P,skel,OT);
    [tmpA,ClassA,ClassAA,boolClassNum]=subGraphs2(lianjie,result,classNumValue,skel);

    %找环 返回变量:是否有环(布尔变量)，有环的索引，有环的节点，是否存在无环分支(布尔变量)，无环索引，无环节点
    [boolcircle,circleindex,circle,boolnocircle,nocircleindex,nocircle]=findcircle(ClassAA,skel,lianjie);
    if  ~boolcircle
        conditionRefine = false;
    end

%     figure
%     plot3(skel(:,1),skel(:,2),skel(:,3),'.','color',[1 0 0],'MarkerSize',20);
    ClassANum=length(ClassA);
%     每一个连通子图画图
%     for i=1:size(skel,1)
%         for j=i:size(skel,1)
%             if lianjie(i,j) == 1 
%                 hold on
%                 plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0]);
%             end
%         end
%     end
    %
    if boolcircle || boolnocircle
        [ skel,mass_s ] = mergingCircle( skel, mass_s,nocircle,circle ,boolcircle,boolnocircle, OT);
        condition_OT = true;
        TPOne = 9999999; % 前一次的传输代价
        TPTwo = 0;
        thresholdTP = 0.0001; % 传输代价阈值
        lambda =500;
        mass_p = ones(size(P,1),1) ./ size(P,1); 
        while (condition_OT)
                    TPone = TPTwo;
                    [OT,OTValue] = ot(P,skel,mass_p,mass_s,lambda);   % 计算传输计划
                    skel = center(P,skel,OT);
                    TPTwo = OTValue;
                    if abs(TPone - TPTwo) < thresholdTP 
                        condition_OT =false;
                    end           
        end
        lianjie = showSkel(P,skel,OT);
    end
end
        
end