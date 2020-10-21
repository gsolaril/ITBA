assignin('base','ne',ne);       %| Elemento elegido en GUI para Patch Test
assignin('base','pt',pt);       %| Tipo de Patch Test elegido

Q    = evalin('base','Q');
sub  = evalin('base','sub');

Ciso  = evalin('base','Ciso');
Cmat  = evalin('base','Cmat');
Cupg  = evalin('base','Cupg');
Wupg  = evalin('base','Wupg');

nupg  = evalin('base','nupg');

fn    = evalin('base','fn');
fd    = evalin('base','fd');

nele  = evalin('base','nele');
Elems = evalin('base','Elems');
Coord = evalin('base','Coord');

 %% ------------------------------------------------------------------ %%

side = round(log2(Q)); %| ...2 nodos por lado para un elemento "Q4".
                       %| ...3 nodos por lado para un elemento "Q8/Q9".

% CASO 1: probar elemento particular "ne"...
if (eq(ne,0) == 0)
    
    Patch = zeros(9,Q);                 % Patch cuadrado de 9 elementos
    npts = 3*side - 2;                  % Nodos por cada lado del Patch
    
    Nele = Elems(ne,:);                 % Nodos del elemento seleccionado
    Cele = Coord(Nele,:);               % Posición de dichos nodos
    Cmid = mean(Cele);                  % Posición de su baricentro
    Cept = Cele - ones(Q,1)*Cmid;       % Posición relativa de cada nodo
    Mept = Cept(:,1).^2 + Cept(:,2).^2; % Distancia relativa de cada nodo
    mmax = find(Mept==max(Mept));       % Nodo de distancia relativa máxima
    xext = abs(Cept(mmax(1),1));        % Distancia relativa máxima en "x"
    yext = abs(Cept(mmax(1),2));        % Distancia relativa máxima en "y"
    vext = max([xext yext]);            % Distancia relativa máxima neta
    
  % Creación de Patch de "npts"x"npts" nodos con centro en "(x,y)=(0;0)":
    lside = 2*vext;                              % Lado del cuadrado
    ltest = side*linspace(-1/2,1/2,npts)*lside;  % Distribución de puntos
    [Xtest,Ytest] = meshgrid(ltest);             % Malla de "npts"x"npts"
    
    for node = 1:Q
        row = Cmat(node,2);
        col = Cmat(node,1);
        Xtest(side+row,side+col)...     %| Ubica al elemento "ne" en el
                  = Cept(node,1);       %| centro del Patch y quiebra los
        Ytest(side+row,side+col)...     %| lados de los otros elementos,
                  = Cept(node,2);       %| que antes eran todos rectos.
    end
    
    if (Q == 8) || (Q == 9)
        run Q8ptbalancer.m     % "Rectifica" los lados de los elementos 
    end
    
% CASO 2: probar elementos arbitrarios...
else
    
    Patch = zeros(4,Q);                            % 4 elementos
    lside  = 60;                                   % Lado del cuadrado
    npts  = 5;                                     % 5 puntos por lado
    [Xtest Ytest] = meshgrid(linspace(0,lside,5)); % Malla de 5x5 genérica
    
    Xtest(1:5,3) = (ones(5,1) + rand(5,1))*(lside/3); 
    Xtest(2,:) = (Xtest(1,:) + Xtest(3,:))/2;
    Xtest(4,:) = (Xtest(3,:) + Xtest(5,:))/2;
    Xtest(:,2) = (Xtest(:,1) + Xtest(:,3))/2;
    Xtest(:,4) = (Xtest(:,3) + Xtest(:,5))/2;
    
    Ytest(3,1:5) = (ones(1,5) + rand(1,5))*(lside/3);
    Ytest(:,2) = (Ytest(:,1) + Ytest(:,3))/2;
    Ytest(:,4) = (Ytest(:,3) + Ytest(:,5))/2;
    Ytest(2,:) = (Ytest(1,:) + Ytest(3,:))/2;
    Ytest(4,:) = (Ytest(3,:) + Ytest(5,:))/2;
    
    xprop = Xtest(end,3)/lside; %| A que fracción del largo de lado se
    yprop = Ytest(3,end)/lside; %| ubica el nodo intermedio de las caras.
    
    if (Q == 4)  % El mallado es de 5x5 y debe volverse 3x3
        Xtest([2 4],:) = [ ]; % Eliminar columnas pares
        Xtest(:,[2 4]) = [ ]; % Eliminar filas pares
        Ytest([2 4],:) = [ ]; % Eliminar columnas pares
        Ytest(:,[2 4]) = [ ]; % Eliminar filas pares
        npts = 3;             % Si es Q4, cambia a 3 puntos por lado
    end
    
end

% Matriz de coordenadas absolutas de los nodos:
Ctest = [ reshape(Xtest',[],1) reshape(Ytest',[],1) ];

Grid = 1:npts^2;               
Grid = reshape(Grid,[],npts)'; % Enumeración de los nodos dentro del Patch

iele = 1;

for row0 = 1:(side-1):(npts-1)
for col0 = 1:(side-1):(npts-1)
    for node = 1:Q                   %| La vertice inferior izq. de cada
    row = Cmat(node,2);              %| elemento "iele" será el elemento
    col = Cmat(node,1);              %| "(row0,col0)" de la matriz "Grid".
    Patch0(node,:)...                %| Partiendo de ahí, ván variando 
        = Grid(row0+row,col0+col);   %| "(row,col)", haciendo el recorrido
    end                              %| que marca la matriz "Cmat", con el
    Patch(iele,:) = Patch0;          %| objetivo de formar la matriz de
    iele = iele + 1;                 %| conectividades, llamada "Patch".
end
end

 %% ------------------ Matriz de grados de libertad ------------------ %%

DOFs = zeros(size(Patch,1),2*Q);
 
for iele = 1:size(Patch,1)
    Nele = Patch(iele,:);
    dofx = 2*Nele - 1;
    dofy = 2*Nele;
    dofs = [ dofx
             dofy ];
    dofs = reshape(dofs,[],1);
    DOFs(iele,:) = dofs';
end

%% -------------------- Matriz de rigidez global -------------------- %%

syms x y real

C = [ 16    4    0
       4   16    0
       0    0    6]/15;

K = zeros(2*npts^2);

for iele = 1:size(Patch,1)
    K_ele = zeros(2*Q);
    N_ele = Patch(iele,:);
    C_ele = Ctest(N_ele,:);
    for ipg = 1:nupg
        xpg = Cupg(ipg,1);
        ypg = Cupg(ipg,2);
        Dsf = subs(fd,{x,y},{xpg,ypg});
        Jcb = Dsf*(C_ele);
        Dsf = Jcb\Dsf;
        for node = 1:1:Q
            colx = 2*node-1;
            coly = 2*node;
            B(:,(colx:coly)) = [ Dsf(1,node)       0
                                      0       Dsf(2,node)
                                 Dsf(2,node)  Dsf(1,node) ];
        end
        K_dxy = (B')*(C)*(B)*det(Jcb);
        K_ele = (K_ele) + (K_dxy)*Wupg(ipg);
    end
    dofs = DOFs(iele,:);
    K(dofs,dofs) = K(dofs,dofs) + K_ele;
end

 %% -------------------------- Modelización -------------------------- %%
 
plot(Ctest(:,1),Ctest(:,2),'ro','MarkerEdgeColor','k',...
                                'MarkerFaceColor','b',...
                                'MarkerSize',3)
hold on
grid on

for iele = 1:size(Patch,1)
    Nele = [ Patch(iele,:)     Patch(iele,1) ];
    if (Q == 9)
        Nele([9 10]) = Nele([10 9]);
    end
    Xele = Ctest(Nele,:);
    plot(Xele(:,1),Xele(:,2),'-b','LineWidth',1.25)
    Xmid = mean(Xele);
    text(Xmid(1),Xmid(2),strcat(num2str(iele)),...
    'FontSize',12,'FontWeight','bold',...
    'HorizontalAlignment','center')
end
axis equal

 %% ---------------------- Condiciones de borde ---------------------- %%

BCnd_x = ones(npts);
BCnd_y = ones(npts);

switch pt
    case {1}
        BCnd_x(1,1) = 0;
        BCnd_x(:,1) = 0;
        BCnd_y(1,1) = 0;
    case {2}
        BCnd_x(1,1) = 0;
        BCnd_y(1,1) = 0;
        BCnd_y(1,:) = 0;
    case {3}
        BCnd_x(1,:) = 0;
        BCnd_y(:,1) = 0;
end

BCnd_x = reshape(BCnd_x',[],1);
BCnd_y = reshape(BCnd_y',[],1);
BCnd = [ BCnd_x       BCnd_y ];

if (Q == 8)
    Grid = 1:npts^2;
    Grid = reshape(Grid',npts,[])';
    QCnd = ones(size(BCnd));
    rows = size(Grid,1);
    cols = size(Grid,2);
    remove = Grid((2:2:rows),(2:2:cols));
    remove = reshape(remove',[],1);
    QCnd(remove,:) = 0;
else
    QCnd = ones(size(BCnd));
end

BCnd = logical(BCnd);
QCnd = logical(QCnd);
TCnd = (BCnd)&(QCnd);

v_cond = reshape(TCnd',1,[])';
v_cond = logical(v_cond);

 %% ------------------------ Fuerzas externas ------------------------ %%

syms prop

Fext_x = zeros(npts);
Fext_y = zeros(npts);
if (sqrt(size(Patch,1)) == 3)
    switch Q
        case {4}
           V = [1 2 2 1];
           V = V/sum(V);
           xprop = ':';
           yprop = ':';
       case {8,9}
           V = [1 4 2 4 2 4 1];
           V = V/sum(V);
           xprop = ':';
           yprop = ':';
    end
else
    switch Q
        case {4}
            V = @(prop) [ prop              1             1-prop ]/2;
        case {8,9}
            V = @(prop) [ prop    4*prop    1  4*(1-prop) 1-prop ]/6;
    end
end
    
switch pt
    case {1}
        Fext_x(:,end) = +V(yprop)';
    case {2}
        Fext_y(end,:) = +V(xprop);
    case {3}
        Fext_y(:,end) = +V(yprop)';
        Fext_x(end,:) = +V(xprop);
end

Fext_x = reshape(Fext_x',[],1);
Fext_y = reshape(Fext_y',[],1);
Fext = [ Fext_x       Fext_y ];

v_fext = reshape(Fext',1,[])';

%% --------------------------- Resolución --------------------------- %%

K_red = K(v_cond,v_cond);
F_red = v_fext(v_cond);
d_red = (K_red)\(F_red);

D = zeros(size(v_cond));
D(v_cond) = D(v_cond) + d_red;

Disp_p = reshape(D',2,[])';
Cdisp = Ctest + (Disp_p)*(20/max(max(Disp_p)));

hold on
grid on

for iele = 1:size(Patch,1)
    Nele = [ Patch(iele,:)     Patch(iele,1) ];
    if (Q == 9)
        Nele([9 10]) = Nele([10 9]);
    end
    Xfin = Cdisp(Nele,:);
    plot(Xfin(:,1),Xfin(:,2),'-m','LineWidth',1.25)
end
axis equal

Disp_px = reshape(Disp_p(:,1),[],npts)';
Disp_py = reshape(Disp_p(:,2),[],npts);

 %% ---------------------- Cálculo de tensiones ---------------------- %%

for iele = 1:size(Patch,1)
    K_ele = zeros(2*Q);
    N_ele = Patch(iele,:);
    C_ele = Ctest(N_ele,:);
    for ipg = 1:nupg
        xpg = Cupg(ipg,1);
        ypg = Cupg(ipg,2);
        Dsf = subs(fd,{x,y},{xpg,ypg});
        Jcb = Dsf*(C_ele);
        Dsf = Jcb\Dsf;
        for node = 1:1:Q
            colx = 2*node-1;
            coly = 2*node;
            B(:,(colx:coly)) = [ Dsf(1,node)       0
                                      0       Dsf(2,node)
                                 Dsf(2,node)  Dsf(1,node) ];
        end
        dofs = DOFs(iele,:);
        SPT(iele,ipg,:) = C*B*D(dofs);
    end
end

 %% ------------------------------------------------------------------ %%
 
assignin('base','Ctest',Ctest);
assignin('base','Patch',Patch);
assignin('base','TCnd_p',TCnd);
assignin('base','Fext_p',Fext);
assignin('base','Disp_p',Disp_p);
assignin('base','Disp_px',Disp_px);
assignin('base','Disp_py',Disp_py);
assignin('base','SPT',SPT);