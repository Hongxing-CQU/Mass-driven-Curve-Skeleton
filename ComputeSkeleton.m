function [mass_s,skel,OT,mergep,nonskelpoints]=ComputeSkeleton(Datapoints,skel,mass_p,mass_s,lambda)
TPOne = 9999999; % 前一次的传输代价
TPTwo = 0;
thresholdTP = 0.0001; % 传输代价阈值
condition = true;
condition_OT = true;
P =Datapoints;
ind=1;
mergep=[];
while ( condition  )  % 若存在需要合并的采样点
    numberOne_skel = size(skel,1); %合并前的骨架点的数量 
        while (condition_OT)
            TPone = TPTwo;
            if ind>0
                [OT,OTValue] = ot(Datapoints,skel,mass_p,mass_s,lambda);   % 计算传输计划
            end
            skel = center(Datapoints,skel,OT);
            TPTwo = OTValue;
            if abs(TPone - TPTwo) < thresholdTP 
                condition_OT =false;
            end           
%             hold off
%             plot3(skel(:,1),skel(:,2),skel(:,3),'.','color',[1 0 0],'MarkerSize',20);
        end
        condition_OT = true;
    [skelTwo,massSkel,OTTwo,mergepair,nonskelpoints] = ImMerge(P,OT,skel,mass_p);
%     [skelTwo,massSkel,OTTwo] = ImMerge1(P,OT,skel,mass_p);
%     mergep=[];
    mergep=[mergep;mergepair];
    numberTwo_skel = size(skelTwo,1);  %合并后骨架点的数量
    need_delete = [];
    if numberOne_skel > numberTwo_skel
        for j =numberTwo_skel+1 : numberOne_skel
            need_delete = [need_delete j];
        end 
        OT(need_delete,:) = [];
        mass_s(need_delete) = [];
        skel(need_delete, :) = [];
    end
    OT = OTTwo;
    mass_s = massSkel;
    skel = skelTwo;
    %删除质量是0的骨架点
    need_delete = [];
    for i =1 : size(skel,1)
        if mass_s(i,1) < 10e-6
            need_delete = [need_delete i];            
        end
    end
    OT(need_delete,:) = [];
    mass_s(need_delete) = [];
    skel(need_delete, :) = [];   
    if (  numberOne_skel == numberTwo_skel )
       
        condition = false;   
    end
end
end