% pivot_setup.m // Jon Lee
% set up a pivoting example

clear all;

global A b c m n beta eta

try 
    reply = input('NAME of NAME.m file holding input? [pivot_input]: ', 's');
    if isempty(reply)
       reply = 'pivot_input';
       end
catch
    reply = 'pivot_input'; % need catch for execution on MathWorks Cloud
end
eval(reply);
 
if (size(b) ~= m) 
    display('size(b) does not match number of rows of A')
    return
end
if (size(c) ~= n) 
    display('size(c) does not match number of columns of A')
    return
end
if(size(setdiff(beta,1:n)) > 0)
    display('beta has elements not in 1,2,...,n')
    return
end
if(size(setdiff(eta,1:n)) > 0)
    display('eta has elements not in 1,2,...,n')
    return
end
if (size(beta) ~= m) 
    display('size(beta) does not match number of rows of A')
    return
end
if (size(eta) ~= n-m) 
    display('size(eta) does not match number of cols minus number of rows of A')
    return
end

display('Available quantites: A, b, c, m, n, beta, eta');
display('Seems like a good time to run pivot_algebra');

