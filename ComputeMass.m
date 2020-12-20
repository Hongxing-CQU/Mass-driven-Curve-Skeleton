function [mass_p]=ComputeMass(P)
Neighbour=10;
rdis=[];
for i=1:size(P,1)
    d=pdist2(P,P(i,:));
    for j=1:Neighbour
        l=find(d==min(d));
        d(l,:)=1;
    end
        rind=find(d==min(d));
        r=d(rind(1));
        rdis=[rdis;r];
        disp(i);
end  

mass=rdis.*(1/sum(rdis));
mass_p=mass;
end
% Neighbour=10;
% rdis=[];
% for i=1:size(P,1)
%     d=pdist2(P,P(i,:));
%     for j=1:Neighbour
%         l=find(d==min(d));
%         d(l,:)=1;
%     end
%         rind=find(d==min(d));
%         r=d(rind(1));
%         rdis=[rdis;r];
%         disp(i);
% end  
% 
% mass=rdis.*(1/sum(rdis));

