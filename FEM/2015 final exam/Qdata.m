assignin('base','Q',Q)
assignin('base','sub',sub)

%% ------------------------------------------------------------------ %%

% nodos:      n1   n2   n3   n4
Ciso_Q4 = [   -1   +1   +1   -1
              -1   -1   +1   +1   ]';
% nodos:      n1   n2   n3   n4   n5   n6   n7   n8
Ciso_Q8 = [   -1    0   +1   +1   +1    0   -1   -1
              -1   -1   -1    0   +1   +1   +1    0   ]';
% nodos:      n1   n2   n3   n4   n5   n6   n7   n8   n9
Ciso_Q9 = [   -1    0   +1   +1   +1    0   -1   -1    0
              -1   -1   -1    0   +1   +1   +1    0    0   ]';

% nodos:      n1   n2   n3   n4
Wupg_Q4 = [    1    1    1    1    ];
% nodos:      n1   n2   n3   n4   n5   n6   n7   n8   n9
Wupg_Q9 = [   25   40   25   40   25   40   25   40   64    ]/81;

 %% ------------------------------------------------------------------ %%

syms x y real
 
switch Q
    case {4}
        Ciso = Ciso_Q4;
        Cmat = (Ciso + 1)/2;
        pg   = sqrt(1/3);
        Cupg = Ciso_Q4*pg;
        Wupg = Wupg_Q4;
    case {8}
        Ciso = Ciso_Q8;
        Cmat = (Ciso + 1)/1;
        if sub == 1
           pg   = sqrt(1/3);
           Cupg = Ciso_Q4*pg;
           Wupg = Wupg_Q4;
        else
           pg   = sqrt(0.6);
           Cupg = Ciso_Q9*pg;
           Wupg = Wupg_Q9;
        end
    case {9}
        Ciso = Ciso_Q9;
        Cmat = (Ciso + 1)/1;
        pg   = sqrt(0.6);
        Cupg = Ciso_Q9*pg;
        Wupg = Wupg_Q9;
end

nupg = length(Wupg);

syms x y real

 %% ------------------------------------------------------------------ %%

switch Q
    case {4}
    pol   = [  1     x     y    x*y ];
    case {8}
    pol   = [  1     x     y    x^2   x*y   y^2  x^2*y x*y^2];
    case {9}
    pol   = [  1     x     y    x^2   x*y   y^2  x^2*y x*y^2 (x*y)^2];
end

syms x y real

A = zeros(Q);
for node = 1:Q
    xiso = Ciso(node,1);
    yiso = Ciso(node,2);
    A(node,:) = subs(pol,{x,y},{xiso,yiso});
end

fn = pol/A;           % Funciones de forma
fn = simplify(fn);

fd = [ diff(fn,x)
       diff(fn,y) ];  
fd = simplify(fd);    % Funciones desplazamiento/deformación

 %% ------------------------------------------------------------------ %%

assignin('base','Ciso',Ciso)
assignin('base','Cmat',Cmat)
assignin('base','pg',pg)
assignin('base','Cupg',Cupg)
assignin('base','Wupg',Wupg)

assignin('base','nupg',nupg)

assignin('base','fn',fn)
assignin('base','fd',fd)