% SubgradientOpt.m // Jon Lee
% 
% Apply Subgradient Optimization to 
%   z = min c'x
%        Ex  = h
%        Ax  = b
%         x >= 0
%
% NOTE: WE ONLY HANDLE PROBLEMS WITH BOUNDED SUBPROBLEM LPs.
%       IF WE ENCOUNTER AN UNBOUNDED SUBPROBLEM, THEN WE QUIT.

% generate a random example
n = 50; % number of variables
m1 = 15; % number of equations to relax
m2 = 10; % number of equations to keep

rng('default');
rng(1);  % set seed
E = rand(m1,n);  % random m1-by-n matrix
A = rand(m2,n);  % random m2-by-n matrix

w = rand(n,1);     % generate rhs's so problem is feasible
h = E*w;
b = A*w;

c = rand(n,1);     % generate random objective
% first we will calculate the optimal value z of the original LP, just to
% compare later
disp('Optimizing the original LP without Lagrangian relaxation');
[x,z,exitflag] = linprog(c,[],[],[E; A],[h; b],zeros(n,1),[]);
if (exitflag < 1)
     disp('fail 1: original LP (without using LR) did not solve correctly');
     return;
end;

disp('Optimal value of the original LP:');
z

disp('Starting Subgradient Optimization');

MAXIT = 100; % number of iterations

results1 = zeros(MAXIT,1);
results2 = zeros(MAXIT,1);

k = 0; % iteration counter
y = zeros(m1,1); % initialize y as you like
g = zeros(m1,1); % initialize g arbitrarily --- it will essentially be ignored
stepsize = 0;    % just to have us really start at the initialized y
bestlb = -Inf;
while k < MAXIT 
   k = k + 1; % increment the iteration counter
   y = y + stepsize*g; % take a step in the direction of the subgradient
   % solve the Lagrangian
   [x,subval,exitflag,output,dualsol] = linprog((c'-y'*E)',[],[],A,b,zeros(n,1),[]); 
   v = h'*y + (c'-y'*E)*x;  % calculate the value of the Lagrangian
   disp(v);
   bestlb = max(bestlb,v);
   results1(k)=k;
   results2(k)=v;
   g = h - E*x; % calculate the subgradient  
   stepsize = 1/k; % calculate the step size
end

bestlb

z

clf;  % clear figure
% plot the sequence of MAXIT lower bounds
plot(results1,results2,'k--.','MarkerSize',15); 
hold on;
% plot a horizontal line at height z
plot([1,MAXIT],[ z z ], 'r-','LineWidth',2.5) 
axis tight;
xlabel('Iteration');
ylabel('Lagrangian lower bound');
legend('Lagrangian LB','z','Location','SouthEast');

print -djpeg SubgradientOpt.jpeg;

% Next, if y really solves the Lagrangian dual, and pi is the 
% optimal solution to the Lagrangian subproblem corresponding to y,
% then y and pi should be an optimal dual solution to the given problem.
% 
% Let's see if y and pi are nearly dual feasible.

pi = - dualsol.eqlin;
Total_Dual_Infeasibility = norm(min(c' - y'*E - pi'*A,zeros(1,n)))





