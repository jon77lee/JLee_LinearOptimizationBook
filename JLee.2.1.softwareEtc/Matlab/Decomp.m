% Decomp.m  // Jon Lee 
%
% Apply Decomposition to 
%   z = min c'x
%            Ex  + Is = h
%            Ax       = b
%              x , s >= 0
%
% NOTE: WE ONLY HANDLE PROBLEMS WITH BOUNDED SUBPROBLEM LPs.
%       IF WE ENCOUNTER AN UNBOUNDED SUBPROBLEM, THEN WE QUIT.

% generate a random example
n = 50 % number of x variables
m1 = 15 % number of 'complicating' equations = number of s variables
m2 = 10 % number of 'nice' equations 

rng('default');
rng(1);  % set seed
E = rand(m1,n);  % random m1-by-n matrix
A = rand(m2,n);  % random m2-by-n matrix

w = rand(n,1);     % generate rhs's so problem is feasible
h = E*w + 0.01*rand(m1,1);
b = A*w;

c = rand(n,1);     % generate random objective

% first we will calculate the optimal value z of the original LP, just to
% compare later.
disp('Optimizing the original LP without decomposition');
%options = optimoptions(@linprog,'Algorithm','simplex');
%[x,z,exitflag,output,lambda]=linprog([c;zeros(m1,1)],[],[],...
%[horzcat(E,eye(m1)); horzcat(A,zeros(m2,m1))],[h; b],zeros(n+m1,1), ...
%[],[],options);
[x,z,exitflag,output,lambda]=linprog([c;zeros(m1,1)],[],[], ...
    [horzcat(E,eye(m1)); horzcat(A,zeros(m2,m1))],[h; b], ...
    zeros(n+m1,1),[],[]);
if (exitflag < 1)
     disp('fail 1: original LP without decomposition did not solve correctly');
     return;
end;
disp('Optimal value of the original LP:');
z
%disp('dual solution:');
%disp(- lambda.eqlin); % Need to flip the signs due to a Matlab convention

disp('Starting Decomposition Algorithm');

MAXIT = 50 % number of iterations

% Set up the initial master basis
% ... First, we need any extreme point of the subproblem
x1 = linprog(c',[],[],A,b,zeros(n,1),[]);
X = x1;      % start accumulating the extreme points
CX = c'*x1;  % and their costs
numx = 1;
%Next, we build out the initial master basis
B = [horzcat(eye(m1), E*x1) ; horzcat(zeros(1,m1), 1)];
numcol = m1+1;
% OK, now we have a basis matrix for the master.
% Let's see if this basis is feasible.
zeta = linsolve(B,[h ; 1])
% If it is not feasible, we need to adjoin an artificial column
if (min(zeta) < -0.00000001)
    disp('*** Phase-one needed');
    % adjoin an artificial column
    numcol = numcol + 1;
    artind = numcol;
    B(:,artind) = -B*ones(m1+1,1);
    xi = zeros(numcol,1);
    xi(artind) = 1;
    
    % OK, now we are going to solve a phase-one problem to drive the artificial
    % variable to zero. Of course, we need to do this with decomposition.
    k = 1; % iteration counter
    subval = -Inf;
    sigma = 0.0;
    while -sigma + subval < -0.00000001 && k <= MAXIT
      % Set the dual variables by solving the restricted master
      [zeta,masterval,exitflag,output,dualsol] = linprog(xi,[],[],B, ...
          [h ; 1],zeros(numcol,1),[]);
      masterval
      % Need to flip the signs due to a Matlab convention
        y = - dualsol.eqlin(1:m1); 
        sigma = - dualsol.eqlin(m1+1);
      % OK, now we can set up and solve the phase-one subproblem
      [x,subval,exitflag] = linprog((-y'*E)',[],[],A,b,zeros(n,1),[]);
      if (exitflag < 1)
          disp('fail 2: phase-one subproblem did not solve correctly');
          return;
      end;
      % Append [E*x; 1] to B, and set up new restricted master 
      numcol = numcol + 1;
      numx = numx + 1;
      X = [X x];
      CX = [CX ; c'*x];
      B = [B [E*x ; 1]];
      % Oh, we should build out the cost vector as well
      xi = [xi ; 0];
      k = k+1;
    end;
    
    % sanity check
    if (-sigma + subval < -0.00000001)
      disp('fail 3: we hit the max number of iterations for phase-one');
      return;
    end;

    % sanity check
    if (zeta(artind) > 0.00000001)
      disp('fail 4: we thought we finished phase-one');
      disp('   but it seems the aritifical variable is still positive');
      disp(zeta(artind));
      return;
    end;
    
% phase-one clean-up: peel off the last column --- which was not improving,
% and also delete the artifical column
B(:,numcol) =[];
numcol = numcol - 1;
X(:,numx) =[];
CX(numx,:) =[];
numx = numx - 1;
B(:,artind) = [];
numcol = numcol - 1;

end;

%
% Now time for phase-two
disp('*** Starting phase-two');

results1 = zeros(MAXIT,1);
results2 = zeros(MAXIT,1);

k = 0; % iteration counter
subval = -Inf;
sigma = 0.0;
while -sigma + subval < -0.00000001 && k <= MAXIT
  k = k + 1;
  % Set the dual variables by solving the restricted master
  obj = [zeros(m1,1) ; CX];
  [zeta,masterval,exitflag,output,dualsol] = linprog(obj,[],[],B, ...
      [h ; 1],zeros(numcol,1),[]);
  masterval 
  % Need to flip the signs due to a Matlab convention
    y = - dualsol.eqlin(1:m1);
    sigma = - dualsol.eqlin(m1+1);
  results1(k)=k;
  results2(k)=masterval;
  % OK, now we can set up and solve the phase-one subproblem
  [x,subval,exitflag] = linprog((c'-y'*E)',[],[],A,b,zeros(n,1),[]);
  if (exitflag < 1)
      disp('fail 5: phase-two subproblem did not solve correctly');
      return;
  end;
  % Append [E*x; 1] to B, and set up new restricted master 
  numcol = numcol + 1;
  numx = numx + 1;
  X = [X x];
  CX = [CX ; c'*x];
  B = [B [E*x ; 1]];
end;
    
% sanity check
if (-sigma + subval < -0.00000001)
  disp('fail 6: we hit the max number of iterations for phase-two');
  return;
end;
    
% Clean up from phase-two:
%
% Peel off the last column --- which was not improving
B(:,numcol) =[];
numcol = numcol -1;
X(:,numx) =[];
CX(numx,:) =[];
numx = numx - 1;

xdw = X*zeta(m1+1:numcol) % this is the solution in the original variables x

DWz = CX'*(zeta(m1+1:numcol))

z

if ((abs(DWz - z) < 0.01) && (abs(c'*xdw - DWz) < 0.00001) && ...
        (norm(b-A*xdw) < 0.00001) && (norm(min(h-E*xdw,0)) < 0.00001))
    disp('IT WORKED!!!'); % exactly what did we check?
end

clf; % clear figure
% plot the sequence of upper bounds
plot(results1(1:k),results2(1:k),'k--.','MarkerSize',15); 
hold on;
% plot a horizontal line at height z
plot([1,k],[ z z ], 'r-','LineWidth',1.5) 
axis tight;
xlabel('Iteration');
ylabel('Decomposition upper bound');
legend('Decomposition UB','z');

print -djpeg Decomp.jpeg;
