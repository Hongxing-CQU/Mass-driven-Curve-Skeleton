function []=PlotSmoothSkeleton(Datapoints,dsize,mass,skel,lianjie,scale,lwidth)
    figure;
    plot3(Datapoints(:,1),Datapoints(:,2),Datapoints(:,3),'.','color',[0 0 0],'MarkerSize',dsize);
    hold on
    for i=1:size(mass,1)
        hold on;
        plot3(skel(i,1),skel(i,2),skel(i,3),'.','color',[0 1 0],'MarkerSize',sqrt(mass(i)*scale)+5);%不同质量骨架点大小不一样
    end
    for i=1:size(skel,1)
        for j=i:size(skel,1)
            if lianjie(i,j) == 1
                hold on
                plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0],'LineWidth',lwidth);
            end
        end
    end
    axis off,axis equal;
    view(0,90);
%     set(gca,'position',[0 0 1 1]);
end