% DualityWithMatlab1.m // Jon Lee

n1=7
n2=15
m1=2
m2=4

rng('default');
rng(1);  % set seed

A = rand(m1,n1);  
B = rand(m1,n2);
D = rand(m2,n1);

% Organize the situation 
%   so that the problem has a feasible solution
x = rand(n1,1);
w = -rand(n2,1);
b = A*x + B*w + 0.01 * rand(m1,1);  
g = D*x;                     

% Organize the situation 
%   so that the dual problem has a feasible solution
y = -rand(m1,1);
pi = rand(m2,1) - rand(m2,1);
c = A'*y + D'*pi + 0.01 * rand(n1,1);
f = B'*y - 0.01 * rand(n2,1);

% Here is how the 'linprog' function works:
%
% [v,z,exitflag] = linprog(c,A,b,Aeq,beq,lb,ub) 
%   minimizes c'v ,
%   with constraints A v <= b, Aeq v = beq, and 
%   variable bounds lb <= v <=ub. 
%   Some parts of the model can be null: for example,
%   set Aeq = [] and beq = [] if no equalities exist.
%   set ub = [] if no upper bounds exist.
%
% [v,z,exitflag] = linprog(...) returns values: 
%     v = solution vector
%     z = minimum objective value
%     exitflag = describes the exit condition:
%        1 optimal solution found.
%       -2 problem is infeasible.
%       -3 problem is unbounded.
%       -5 problem and its dual are both infeasible

% Study the following part carefully. This is how we set up
% a block problem. [c ; f] stacks vertically the vectors c and f.
% [A B] concatenates A and B horizontally. zeros(m2,n2) is an
% m2-by-n2 matrix of 0's. ones(n1,1) is an n1-vector of 1's, and
% Inf is +infinity, so Inf*ones(n1,1) is a vector of length n1
% with all components equal to +infinity. In this way we have 
% infinite upper bounds on some variables.
[v,z,exitflag] = linprog([c ; f],[A B],b,[D zeros(m2,n2)],g, ...
    [zeros(n1,1);-Inf*ones(n2,1)],[Inf*ones(n1,1);zeros(n2,1)])

if (exitflag < 1)
     disp('fail 1: LP did not have an optimal solution');
     return;
end;

% Extract the parts of the solution v to the formulation vectors
x = v(1:n1,1)
w = v(n1+1:n1+n2,1)
