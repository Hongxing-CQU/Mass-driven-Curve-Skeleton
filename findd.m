%找出非零度节点
function [ d ] = findd( lj )
[~, col] = find( lj ~= 0 );
d=unique(col);
d= d(randperm(length(d)));
end