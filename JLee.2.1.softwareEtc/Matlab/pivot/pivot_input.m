% pivot_input.m // Jon Lee
% data for pivoting example

A = [1 2 1 0 0 0; 3 1 0 1 0 0; 1.5 1.5 0 0 1 0; 0 1 0 0 0 1];
c = [6 7 -2 0 4 4.5]';
b = [7 9 6 3.3]';
beta = [1,2,4,6];
[m,n] = size(A);
eta = setdiff(1:n,beta); % lazy eta initialization