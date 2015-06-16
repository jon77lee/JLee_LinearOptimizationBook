% pivot_algebra.m // Jon Lee
% do the linear algebra

global A_beta Abar_eta c_beta ybar xbar_beta xbar c_eta cbar_eta

A_beta = A(:,beta);
if (rank(A_beta,0.0001) < size(A_beta,1))
    display('error: A_beta not invertible')
    return;
end;
A_eta = A(:,eta);
c_beta = c(beta);
c_eta = c(eta);
ybar = linsolve(A_beta',c_beta);
xbar = zeros(n,1);
xbar_beta = linsolve(A_beta,b);
xbar(beta) = xbar_beta;
xbar_eta = zeros(n-m,1);
xbar(eta) =  xbar_eta;

Abar_eta = linsolve(A_beta,A_eta);

if (norm(A * xbar - A_beta * xbar_beta + A_eta * xbar_eta) > 0.00001)
    display('error: something is very wrong')
    return
end

cbar_eta = (c(eta)' - ybar'*A(:,eta));
obj = c'*xbar;

display('Available display quantites:');
display('   A, b, c, m, n, beta, eta,');
display('   A_beta, A_eta, c_beta, c_eta,');
display('   xbar_beta, xbar, obj, ybar, Abar_eta, cbar_eta,');
display('   pivot_ratios(j), pivot_direction(j), pivot_plot');
display('Available functionality:');
display('   pivot_swap(j,i)');



