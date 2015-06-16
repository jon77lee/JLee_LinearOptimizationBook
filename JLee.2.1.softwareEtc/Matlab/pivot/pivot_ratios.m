% pivot_ratios.m // Jon Lee
% calculate ratios for determing a variable to leave the basis.
% syntax is ratios(j), where we are letting eta_j enter the basis

function ratios(j)
global xbar_beta Abar_eta m n;
if (j>n-m)
    display('error: j out of range.')
else
ratios = xbar_beta ./ Abar_eta(:,j)
end

