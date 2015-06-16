% pivot_plot.m // Jon Lee
% Make a 2-D plot in the space of the nonbasic variables (if n-m=2)

if (n-m ~= 2) 
    display('error: cannot plot unless n-m = 2')
    return
end

clf;
hold on

syms x_eta1 x_eta2;

% a bit annoying but apparently necessary to symbolically perturb (below) 
% in case a line is parallel to an axis. 
x_eta1_axis = ezplot('0*x_eta1+x_eta2');
x_eta2_axis = ezplot('x_eta1+0*x_eta2');

set(x_eta1_axis,'LineStyle','-','Color',[0 0 0],'LineWidth',2);
set(x_eta2_axis,'LineStyle','-','Color',[0 0 0],'LineWidth',2);

h = Abar_eta*[x_eta1 ; x_eta2] - xbar_beta;
h = [h ; 'x_eta1' ; 'x_eta2'];

jcmap = colormap(lines);
for i = 1:m
    % a bit annoying but apparently necessary to symbolically perturb (below) 
    % in case a line is parallel to an axis. 
    p(i) = ezplot(strcat(char(h(i)),'+0*x_eta1+0*x_eta2')); 
    set(p(i),'Color',jcmap(i,:),'LineWidth',2);
    name{i} = ['x_{\beta_{',num2str(i),'}} =  x_{' int2str(beta(i)),'}'];
end

title('Graph in the space of the nonbasic variables ($\bar{c}_\eta$ is magenta)',...
    'interpreter','Latex','FontSize',14);
legend(p, name);
xlabel(strcat('x_{\eta_1}= x_{',int2str(eta(1)),'}'));
ylabel(strcat('x_{\eta_2}= x_{',int2str(eta(2)),'}'));

if (xbar_beta >= 0)
    plot([0],[0],'Marker','o','MarkerFaceColor','green','MarkerEdgeColor',...
        'black','MarkerSize',5);
    polygonlist=[0,0];
    else
    plot([0],[0],'Marker','o','MarkerFaceColor','red','MarkerEdgeColor',...
        'black','MarkerSize',5);
    polygonlist=[ , ];
end    

for i = 1:m+1
    for j = i+1:m+2
        [M, d] = equationsToMatrix([h(i) == '0*x_eta1+0*x_eta2', ...
            h(j) == '0*x_eta1+0*x_eta2'], [x_eta1, x_eta2]);
        if (rank(M) == 2)
            intpoint=linsolve(M,d);
            [warnmsg, msgid] = lastwarn;
            if ~strcmp(msgid,'symbolic:sym:mldivide:warnmsg2')
                if ( [linsolve(A_beta, b-A_eta*intpoint) ; intpoint] >=0 )
                   plot([intpoint(1)],[intpoint(2)],'Marker','o', ...
                       'MarkerFaceColor','green','MarkerEdgeColor','black', ...
                       'MarkerSize',5);
                   polygonlist =[polygonlist;  intpoint'];
                else
                   plot([intpoint(1)],[intpoint(2)],'Marker','o', ...
                       'MarkerFaceColor','red','MarkerEdgeColor','black', ...
                       'MarkerSize',5);
                end
            end
        end
    end
end

if ( size(polygonlist,1) > 2 && ...
        any(pivot_direction(1) < 0) && any(pivot_direction(2) < 0) )
    polyx=polygonlist(:,1);
    polyy=polygonlist(:,2);
    K = convhull(double(polyx),double(polyy));
    hull = fill(polyx(K),polyy(K),'c');
    uistack(hull, 'bottom');
end
quiver([0],[0],cbar_eta(1),cbar_eta(2),'LineWidth',2,'MarkerSize',2, ...
    'Color','magenta','LineStyle','--');


