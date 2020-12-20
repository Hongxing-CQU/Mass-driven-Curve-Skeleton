function [TransportPlan,TransportValue] = ot(P,skel,massP, massSkel,lambda)
    %input P:point cloud ,skel:skeleton
    %output: T:transport plan
    
%    p = ones(size(P,1),1) ./ size(P,1);     %质量p
%    mass = zeros(size(skel,1),1);
%    nei = findNei(P,skel);
%    for i=1:size(skel,1)
%        l = find(nei == i);
%        mass(i) = length(l);
%    end
%    lambda = 50;
%    mass = mass ./ size(nei,1);
%    q = mass;   %质量q
    M = pdist2(skel,P);
    K=exp(-lambda*M);
    U=K.*M;
    [D,lowerEMD,l,m]=sinkhornTransport(massSkel,massP,K,U,lambda,[],[],[],[],1); % running with VERBOSE
    TransportPlan=bsxfun(@times,m',(bsxfun(@times,l,K))); % this is the optimal transport.
    TransportValue = sum(sum(TransportPlan.* M));    
end