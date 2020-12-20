function [k] = findK(lianjie,leaf,index)
    
    k = leaf(1);
    index(index == leaf(1)) = [];
    m=1;
%     while ~isEmpty(leaf)
        while length(index) > 0
           m=m+1;
           if m>20
               break;
           end
            temp = k(length(k));    %找出最后加入的点
            len = find(lianjie(temp,:) == 1);  %与该点相连的点
            if length(len) > 2
                break;
            end
             
%             if length(len) == 1 && m>1
% %                 k = [k;len];
% %                 index(index == len) = [];
%                 break;
%             end
            for i=1:length(len)
                if length(find(index == len(i))) > 0 %如果该点还没加入k
                    k = [k;len(i)]; %该点加入k
                    index(index == len(i)) = [];    %该点从index中删除
                    break;
                end
            end
        end
%     end
end