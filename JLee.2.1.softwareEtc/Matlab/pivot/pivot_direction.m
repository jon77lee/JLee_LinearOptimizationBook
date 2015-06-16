% pivot_direction.m // Jon Lee
% view the direction zbar corresponding to increasing x_eta(j).
% syntax is pivot_direction(j)

function [zbar] = pivot_direction(j)
global beta eta m n Abar_eta
if (j > n-m) 
    display('error: not so many directions')
    return
end
zbar = zeros(n,1);
zbar(beta) = -Abar_eta(:,j);
zbar(eta(j))=1;
zbar;
end