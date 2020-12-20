function [newskel,newlianjie,newmass_s]=smooth(Datapoints,lianjie,skel,mass_s,lamda,weightValue,n)
P =Datapoints;
pmass=mass_s;
mass_p = ones(size(P,1),1) ./ size(P,1); 
% n=2;
pscale=800;
mscale=1000;
% lamda=200;
% weightValue = 0.3;
if n==0
    resultskel=skel;
    newlianjie=lianjie;
else
    [resultskel,newlianjie]=interpolate(lianjie,skel,n);
end
[newskel,newmass_s]=optimizeSkelWithLine(P,resultskel,newlianjie,mass_p,lamda,weightValue);

%画图
%原始点云
% figure;
% plot3(Datapoints(:,1),Datapoints(:,2),Datapoints(:,3),'.','color',[0 0 0],'Markersize',10);
% axis off,axis equal;
% view(0,90);
% set(gca,'position',[0 0 1 1]);
% %原始点云+骨架点
% figure;
% plot3(Datapoints(:,1),Datapoints(:,2),Datapoints(:,3),'.','color',[0 0 0],'Markersize',10);
% for i=1:size(skel,1)
%     hold on;
%     plot3(skel(i,1),skel(i,2),skel(i,3),'.','color',[1 0 0],'MarkerSize',pmass(i)*pscale);
% end 
% axis off,axis equal;
% view(0,90);
% set(gca,'position',[0 0 1 1]);
% 
% %原始骨架
% figure;
% plot3(po(:,1),po(:,2),po(:,3),'.','color',[1 1 1],'Markersize',5);
% for i=1:size(skel,1)
%     hold on;
%     plot3(skel(i,1),skel(i,2),skel(i,3),'.','color',[1 0 0],'MarkerSize',pmass(i)*pscale);
% end 
% axis off,axis equal;
% view(0,90);
% for i=1:size(skel,1)
%     for j=i:size(skel,1)
%         if lianjie(i,j) == 1
%             hold on
%             plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0]);
%         end
%     end
% end
% set(gca,'position',[0 0 1 1]);
% %原始骨架+原始点云
% figure;
% plot3(Datapoints(:,1),Datapoints(:,2),Datapoints(:,3),'.','color',[0 0 0],'Markersize',10);
% for i=1:size(skel,1)
%     hold on;
%     plot3(skel(i,1),skel(i,2),skel(i,3),'.','color',[1 0 0],'MarkerSize',pmass(i)*pscale);
% end 
% axis off,axis equal;
% view(0,90);
% for i=1:size(skel,1)
%     for j=i:size(skel,1)
%         if lianjie(i,j) == 1
%             hold on
%             plot3([skel(i,1) skel(j,1)],[skel(i,2) skel(j,2)],[skel(i,3) skel(j,3)],'color',[1 0 0]);
%         end
%     end
% end
% set(gca,'position',[0 0 1 1]);
% 
% 
% %平滑骨架
% figure;
% plot3(po(:,1),po(:,2),po(:,3),'.','color',[1 1 1],'Markersize',5);
% for i=1:size(newskel,1)
%     hold on;
%     plot3(newskel(i,1),newskel(i,2),newskel(i,3),'.','color',[0 1 0],'MarkerSize',newmass_s(i)*mscale+1);
% end 
% axis off,axis equal;
% view(0,90);
% for i=1:size(newskel,1)
%     for j=i:size(resultskel,1)
%         if newlianjie(i,j) == 1
%             hold on
%             plot3([newskel(i,1) newskel(j,1)],[newskel(i,2) newskel(j,2)],[newskel(i,3) newskel(j,3)],'color',[1 0 0],'LineWidth',2);
%         end
%     end
% end
% set(gca,'position',[0 0 1 1]);
%平滑骨架+原始点
% figure;
% plot3(Datapoints(:,1),Datapoints(:,2),Datapoints(:,3),'.','color',[0 0 0],'Markersize',5);
% for i=1:size(newskel,1)
%     hold on;
%     plot3(newskel(i,1),newskel(i,2),newskel(i,3),'.','color',[0 1 0],'MarkerSize',newmass_s(i)*mscale+1);
% end 
% axis off,axis equal;
% view(0,90);
% for i=1:size(newskel,1)
%     for j=i:size(resultskel,1)
%         if newlianjie(i,j) == 1
%             hold on
%             plot3([newskel(i,1) newskel(j,1)],[newskel(i,2) newskel(j,2)],[newskel(i,3) newskel(j,3)],'color',[1 0 0],'LineWidth',2);
%         end
%     end
% end
% set(gca,'position',[0 0 1 1]);