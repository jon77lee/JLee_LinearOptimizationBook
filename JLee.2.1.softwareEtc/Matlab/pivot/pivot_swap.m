% pivot_swap.m // Jon Lee
% swap eta_j with beta_i 
% syntax is pivot_swap(j,i)

function swap(j,i)
global beta eta m n;
if ((i>m) | (j>n-m))
    display('error: i or j out of range. swap not accepted');
else
savebetai = beta(i);
beta(i) = eta(j);
eta(j) = savebetai;
display('swap accepted --- new partition:')
display(beta);
display(eta);
display('*** MUST APPLY pivot_algebra! ***')
end


