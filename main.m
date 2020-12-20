clc,clear
% % 读取数据
    load ('./data/leaf');
    Datapoints = (points(:,:)-min(min(points)))/(max(max(points))-min(min(points)));%归一化
    
    Pc = Datapoints;
    figure;
    plot3(Pc(:,1),Pc(:,2),Pc(:,3),'.','color',[0 0 0],'MarkerSize',3);
    axis off,axis equal
    view(0,90);
    title('原始点云')
% %加高斯噪声
%     ratio=1.2; %噪声比
%     [noisepoints]=addGaussianNoise(Pc,ratio);
%     Datapoints=noisepoints;
    P =Datapoints;
    figure;
    plot3(P(:,1),P(:,2),P(:,3),'.','color',[0 0 0],'MarkerSize',5);
    axis off,axis equal
    view(0,90);
% 点云点个数 
    dn = size(P,1);
% 随机选取采样点个数
    N = floor(dn/10); %10%
% 采样点集合
    r = randi([1 dn],1,N); %随机采样
%     r=[409,319,43,326,618,456,546,689,240,550,643,319,384,481,346,135,167,304,12,553,46,318,400,450,322,60,209,54,538,255,481,355,282,241,76,273];
    skel = P(r,:); %初始化骨架点
% 显示采样点
    hold on
    plot3(skel(:,1),skel(:,2),skel(:,3),'.','color',[1 0 0],'MarkerSize',20);
    title('采样');
% OT参数
    mass_p = ones(size(P,1),1) ./ size(P,1);     %分配初始质量p
%     [mass_p]=ComputeMass(P);                  %根据密度分布分配初始质量
    mass_s = ones(size(skel,1),1)./size(skel,1); % 初始化骨架点的质量
    lambda =200;    %Important Parameter
% 平滑参数
    n=0; % 插值个数 n=0不插值
    lamda=200;  %Smooth Parameter
    weightValue = 0.3;  %Smooth Parameter
% 画图参数
    % 缩放比例
    pscale=50000;  % 初始骨架
    mscale=50000; % 平滑骨架
    % 尺寸
    Dsize=5; %点云大小
    Linewidth=3; %线宽
% 最优传输计算骨架点
    [mass_s,skel,OT,mergep,nonskelpoints]=ComputeSkeleton(Datapoints,skel,mass_p,mass_s,lambda);
% 确定连接关系
    lianjie = showSkel(Datapoints,skel,OT);
    PlotSkeleton(Datapoints,Dsize,mass_s,skel,lianjie,pscale,Linewidth);
    title('初步骨架');
%     [skel,lianjie,OT,mass_s,lambda]=NewComputeSkeleton(Datapoints,skel,lianjie,OT,mass_s,mass_p,lambda);


% 最终骨架
    figure;
    plot3(P(:,1),P(:,2),P(:,3),'.','color',[0 0 0],'MarkerSize',5);
    for i=1:size(skel,1)
        hold on;
        plot3(skel(i,1),skel(i,2),skel(i,3),'.','color',[1 0 0],'MarkerSize',50);
    end
    axis off,axis equal;
    view(0,90);
    for i=1:size(skel,1)
        for j=i:size(skel,1)
            if lianjie(i,j) == 1
                hold on
                plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0],'LineWidth',5);
            end
        end
    end
   title('粗糙骨架');

% 根据质量画骨架+点云
    PlotSkeleton(Datapoints,Dsize,mass_s,skel,lianjie,pscale,Linewidth);
    title('粗糙骨架');

% 去环
    [OT,skel,lianjie,mass_s]=deloop(r,OT,skel,lianjie,mass_s,Datapoints);
    PlotSkeleton(Datapoints,Dsize,mass_s,skel,lianjie,pscale,Linewidth);
    title('去环');

% 骨架平滑
    [newskel,newlianjie,newmass_s]=smooth(Datapoints,lianjie,skel,mass_s,lamda,weightValue,n);
    PlotSmoothSkeleton(Datapoints,Dsize,newmass_s,newskel,newlianjie,mscale,Linewidth);
    title('平滑骨架');
