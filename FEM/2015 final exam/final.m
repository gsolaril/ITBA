% Modelo Q4 Tracción simple. Integración por Gauss.

tic
clc
close all
format long

% Discretizacion

% Selección de mallado
disp ('Seleccione el mallado deseado de los elementos:')
disp ('1: Mallado de 1x2')
disp ('2: Mallado de 2x4')
disp ('3: Mallado de 4x8')
disp ('4: Mallado de 8x16')
disp ('5: Mallado de 16x32')
disp ('6: Patch test tensión normal x')
disp ('7: Patch test tension normal y')
disp ('8: Patch test tensión de corte xy')
caso = input('Mallado :');

disp ('Seleccione el tipo de elemento deseado:')
disp ('1: Q4')
disp ('2: Q9')
tipoelemento = input('Elemento :');

switch tipoelemento
    case 1
        switch caso
            case 1
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\1x2\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\1x2\elementos.xlsx');
            case 2
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\2x4\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\2x4\elementos.xlsx');
            case 3
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\4x8\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\4x8\elementos.xlsx');
            case 4
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\8x16\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\8x16\elementos.xlsx');
            case 5
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\16x32\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q4\mallado variable\16x32\elementos.xlsx');
            case 6
            case 7
            case 8
            otherwise
                disp ('Error en la selección del mallado')
                break
        end
        
    case 2
        switch caso
            case 1
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\1x2\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\1x2\elementos.xlsx');
            case 2
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\2x4\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\2x4\elementos.xlsx');
            case 3
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\4x8\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\4x8\elementos.xlsx');
            case 4
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\8x16\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\8x16\elementos.xlsx');
            case 5
                nodesraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\16x32\nodos.xlsx');
                elementsraw = xlsread ('C:\Nick\ITBA\Elementos finitos\Final\Q9\mallado variable\16x32\elementos.xlsx');
            case 6
            case 7
            case 8
            otherwise
                disp ('Error en la selección del mallado')
                break
        end

    otherwise
        disp ('Error en la selección del tipo de elemento')
        break
end

switch tipoelemento
    case 1
        nNodEle = 4;                    % Número de nodos por elemento
    case 2
        nNodEle = 9;                    % Número de nodos por elemento
end

if caso >= 6;
        switch tipoelemento
            case 1
                nodes = [ 0.0  0.0
                          1.0  0.0
                          2.0  0.0
                          0.0  1.0
                          0.8  0.8
                          2.0  1.0
                          0.0  2.0
                          1.0  2.0
                          2.0  2.0 ];

                elements = [1  2  5  4
                            2  3  6  5
                            4  5  8  7
                            5  6  9  8 ];
            case 2
                nodes = [ 0.0	0.0
                          1.0	0.0
                          0.0	1.0
                          0.8	0.8
                          0.5	0.0
                          0.4	0.9
                          0.0	0.5
                          0.9	0.4
                          0.45	0.45
                          2.0	0.0
                          2.0	1.0
                          1.5	0.0
                          1.4	0.9
                          2.0	0.5
                          1.45	0.45
                          1.0	2.0
                          2.0	2.0
                          1.5	2.0
                          0.9	1.4
                          2.0	1.5
                          1.45	1.45
                          0.0	2.0
                          0.5	2.0
                          0.0	1.5
                          0.45	1.45 ];

                elements = [1	2	4	3	5	8	6	7	9
                            2	10	11	4	12	14	13	8	15
                            4	11	17	16	13	20	18	19	21
                            3	4	16	22	6	19	23	24	25 ];
        end
end

if caso <= 5;
    nodes = nodesraw (:,3:4);
    elements = elementsraw (:,2:nNodEle+1);
end
     

nDofNod = 2;                    % Número de grados de libertad por nodo

nel = size(elements,1);         % Número de elementos
nNod = size(nodes,1);           % Número de nodos
nDofTot = nDofNod*nNod;         % Número de grados de libertad

% Matriz de condiciones de borde

bc = false(nNod,nDofNod);

switch caso
    case 6
        switch tipoelemento
            case 1
                bc(1,1:2) = true;
                bc(4,1) = true;
            case 2
                bc(1,1:2) = true;
                bc(3,1) = true;
        end
    case 7
        switch tipoelemento
            case 1
                bc(1,1:2) = true;
                bc(2,2) = true;
            case 2
                bc(1,1:2) = true;
                bc(2,2) = true;
        end
    case 8
        switch tipoelemento
            case 1
                bc(1,1:2) = true;
            case 2
                bc(1,1:2) = true;
        end
    otherwise
        for i = 1:nNod;
            if nodes(i,1) == 0;
                bc(i,1:2) = true;
            end
        end
end


% Vector de cargas

R = zeros(nNod,nDofNod);

q = -0.05; 

switch caso
    case 6
        switch tipoelemento
            case 1
                R([3 9],1) = 0.5;
                R(6,1) = 1.0;
                R(7,1) = -0.5;
            case 2
                R([10 17],1) = 1/6;
                R([14 20],1) = 2/3;
                R(11,1) = 1/3;
                R([7 24],1) = -2/3;
                R(22,1) = -1/6;
        end
    case 7
        switch tipoelemento
            case 1
                R([7 9],2) = 0.5;
                R(8,2) = 1.0;
                R(3,2) = -0.5;
            case 2                
                R([17 22],2) = 1/6;
                R([18 23],2) = 2/3;
                R(16,2) = 1/3;
                R([5 12],2) = -2/3;
                R(10,2) = -1/6;
        end
    case 8
        switch tipoelemento
            case 1
                R(2,1:2) = [-1.0  0.0];
                R(3,1:2) = [-0.5  0.5];
                R(4,1:2) = [ 0.0 -1.0];
                R(6,1:2) = [ 0.0  1.0];
                R(7,1:2) = [ 0.5 -0.5];
                R(8,1:2) = [ 1.0  0.0];
                R(9,1:2) = [ 0.5  0.5];
            case 2                
                R( 2,1:2) = [-1/3  0.0];
                R( 3,1:2) = [ 0.0 -1/3];
                R( 5,1:2) = [-2/3  0.0];
                R( 7,1:2) = [ 0.0 -2/3];
                R(10,1:2) = [-1/6  1/6];
                R(11,1:2) = [ 0.0  1/3];
                R(12,1:2) = [-2/3  0.0];
                R(14,1:2) = [ 0.0  2/3];
                R(16,1:2) = [ 1/3  0.0];
                R(17,1:2) = [ 1/6  1/6];
                R(18,1:2) = [ 2/3  0.0];
                R(20,1:2) = [ 0.0  2/3];
                R(22,1:2) = [ 1/6 -1/6];
                R(23,1:2) = [ 2/3  0.0];
                R(24,1:2) = [ 0.0 -2/3];
        end
        
    otherwise
        switch tipoelemento
            case 1
                nodoscargados = zeros(1,1);
                j = 1;
                for i = 1:nNod;
                    if nodes(i,2) == 200;
                        if nodes(i,1) >= 100;
                            nodoscargados(j,1) = i;
                            nodoscargados(j,2:3) = nodes(i,1:2);
                            j = j+1;
                        end
                    end
                end

                nodoscargados = sortrows(nodoscargados,2);
                d = nodoscargados(2,2) - nodoscargados(1,2);
                
                for i = 1:length(nodoscargados);
                    R(nodoscargados(i,1),1) = q*d;
                end
                
                R(nodoscargados(1,1),1) = q*d/2;
                R(nodoscargados(end,1),1) = q*d/2;
                
            case 2
                nodoscargados = zeros(1,1);
                j = 1;
                for i = 1:nNod;
                    if nodes(i,2) == 200;
                        if nodes(i,1) >= 100;
                            nodoscargados(j,1) = i;
                            nodoscargados(j,2:3) = nodes(i,1:2);
                            j = j+1;
                        end
                    end
                end

                nodoscargados = sortrows(nodoscargados,2);
                d = nodoscargados(3,2) - nodoscargados(1,2);

                nodosesquina = zeros(1,1);
                j = 1;

                for i = 1:2:length(nodoscargados);
                    nodosesquina(j,1:3) = nodoscargados(i,1:3);
                    R(nodosesquina(j,1),1) = q*d/3;
                    j = j+1;
                end

                R(nodosesquina(1,1),1) = q*d/6;
                R(nodosesquina(end,1),1) = q*d/6;

                nodoscentrales = zeros(1,1);
                j = 1;

                for i = 2:2:length(nodoscargados);
                    nodoscentrales(j,1:3) = nodoscargados(i,1:3);
                    R(nodoscentrales(j,1),1) = 2*q*d/3;
                    j = j+1;
                end

        end
end



% Propiedades del material

if caso <= 5;
    E = 200000;
end
if caso >= 6;
    E = 20;
end
NU = 1/3;
t = 1;



%% Matriz Constitutiva (plane stress)

C = E/(1 - NU^2)*[ 1.0     NU         0.0
                    NU    1.0         0.0
                   0.0    0.0     (1 - NU)/2 ];
               

%% Gauss

switch tipoelemento
    case 1
        a = 1/sqrt(3);
        % Ubicaciones puntos de Gauss
        upg = [ -a  -a
                 a  -a
                 a   a
                -a   a ];
        % Número de puntos de Gauss
        npg = size(upg,1);
        wpg = ones(npg,1);
        
    case 2
        a = sqrt(3/5);
        % Ubicaciones puntos de Gauss
        upg = [ -a  -a
                 a  -a
                 a   a
                -a   a
                 0  -a
                 a   0
                 0   a
                -a   0
                 0   0 ];
        % Número de puntos de Gauss
        npg = size(upg,1);
        wpg(1:4,1) = (5/9)^2;
        wpg(5:8,1) = (5/9 * 8/9);
        wpg(9,1) = (8/9)^2;
end
        

%% Matriz de rigidez

switch tipoelemento
    case 1
        K = zeros(nDofTot);
        for iele = 1:nel;
            Ke = zeros(nDofNod*nNodEle);
            nodesEle = nodes(elements(iele,:),:);
            for ipg = 1:npg;
                % Punto de Gauss
                ksi = upg(ipg,1);
                eta = upg(ipg,2);
                % Derivadas de las funciones de forma respecto de ksi, eta
                dN = 1/4*[-(1-eta)   1-eta    1+eta  -(1+eta)
                          -(1-ksi) -(1+ksi)   1+ksi    1-ksi ];
                % Derivadas de x,y, respecto de ksi, eta
                jac = dN*nodesEle;
                % Derivadas de las funciones de forma respecto de x,y.
                dNxy = jac\dN;          % dNxy = inv(jac)*dN

                B = zeros(size(C,2),nDofNod*nNodEle);
                B(1,1:2:7) = dNxy(1,:);
                B(2,2:2:8) = dNxy(2,:);
                B(3,1:2:7) = dNxy(2,:);
                B(3,2:2:8) = dNxy(1,:);

                Ke = Ke + B'*C*B*wpg(ipg)*det(jac)*t;
            end
            eleDofs = node2dof(elements(iele,:),nDofNod);
            K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
        end
    case 2
        K = zeros(nDofTot);
        for iele = 1:nel;
            Ke = zeros(nDofNod*nNodEle);
            nodesEle = nodes(elements(iele,:),:);
            for ipg = 1:npg;
                % Punto de Gauss
                ksi = upg(ipg,1);
                eta = upg(ipg,2);
                % Derivadas de las funciones de forma respecto de ksi, eta
                
                dN1k = 1/4*(2*ksi-1)*(eta-1)*eta;
                dN1e = 1/4*(ksi-1)*(2*eta-1)*ksi;
                dN2k = 1/4*(2*ksi+1)*(eta-1)*eta;
                dN2e = 1/4*(ksi+1)*(2*eta-1)*ksi;
                dN3k = 1/4*(2*ksi+1)*(eta+1)*eta;
                dN3e = 1/4*(ksi+1)*(2*eta+1)*ksi;
                dN4k = 1/4*(2*ksi-1)*(eta+1)*eta;
                dN4e = 1/4*(ksi-1)*(2*eta+1)*ksi;
                dN5k = -(eta-1)*ksi*eta;
                dN5e = -1/2*(ksi^2-1)*(2*eta-1);
                dN6k = -1/2*(eta^2-1)*(2*ksi+1);
                dN6e = -(ksi+1)*ksi*eta;
                dN7k = -(eta+1)*ksi*eta;
                dN7e = -1/2*(ksi^2-1)*(2*eta+1);
                dN8k = -1/2*(eta^2-1)*(2*ksi-1);
                dN8e = -(ksi-1)*ksi*eta;
                dN9k = 2*(eta^2-1)*ksi;
                dN9e = 2*(ksi^2-1)*eta;
                
                
                dN = [ dN1k   dN2k   dN3k   dN4k   dN5k   dN6k   dN7k   dN8k   dN9k
                       dN1e   dN2e   dN3e   dN4e   dN5e   dN6e   dN7e   dN8e   dN9e ];
                % Derivadas de x,y, respecto de ksi, eta
                jac = dN*nodesEle;
                % Derivadas de las funciones de forma respecto de x,y.
                dNxy = jac\dN;          % dNxy = inv(jac)*dN

                B = zeros(size(C,2),nDofNod*nNodEle);
                B(1,1:2:17) = dNxy(1,:);
                B(2,2:2:18) = dNxy(2,:);
                B(3,1:2:17) = dNxy(2,:);
                B(3,2:2:18) = dNxy(1,:);

                Ke = Ke + B'*C*B*wpg(ipg)*det(jac)*t;
            end
            eleDofs = node2dof(elements(iele,:),nDofNod);
            K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
        end
end

%% Reduccion Matriz
isFixed = reshape(bc',[],1);
isFree = ~isFixed;

Rr = reshape(R',[],1);

% Solver
Dr = K(isFree,isFree)\Rr(isFree);

% Reconstrucción
D = zeros(nDofTot,1);
D(isFree) = D(isFree) + Dr;

% Reacciones
Rv = K(isFixed,isFree)*D(isFree);
reacciones = nan(nDofTot,1);
reacciones(isFixed) = Rv;
reacciones = (reshape(reacciones,nDofNod,[]))';

%% Recuperación de tensiones en los nodos
stress = zeros(nel,nNodEle,3);

switch tipoelemento
    case 1
        uNod = [ -1 -1
                  1 -1
                  1  1
                 -1  1 ];
        for iele = 1:nel;
            nodesEle = nodes(elements(iele,:),:);
            for inode = 1:nNodEle;
                % Punto de Gauss
                ksi = uNod(inode,1);
                eta = uNod(inode,2);
                % Derivadas de las funciones de forma respecto de ksi, eta
                dN = 1/4*[-(1-eta)   1-eta    1+eta  -(1+eta)
                          -(1-ksi) -(1+ksi)   1+ksi    1-ksi ];
                % Derivadas de x,y, respecto de ksi, eta
                jac = dN*nodesEle;
                % Derivadas de las funciones de forma respecto de x,y.
                dNxy = jac\dN;          % dNxy = inv(jac)*dN

                B = zeros(size(C,2),nDofNod*nNodEle);
                B(1,1:2:7) = dNxy(1,:);
                B(2,2:2:8) = dNxy(2,:);
                B(3,1:2:7) = dNxy(2,:);
                B(3,2:2:8) = dNxy(1,:);

                eleDofs = node2dof(elements(iele,:),nDofNod);
                stress(iele,inode,:) = C*B*D(eleDofs);
            end
        end
        
    case 2
        uNod = [ -1 -1
                  1 -1
                  1  1
                 -1  1
                  0 -1
                  1  0
                  0  1
                 -1  0
                  0  0 ];
        for iele = 1:nel;
            nodesEle = nodes(elements(iele,:),:);
            for inode = 1:nNodEle;
                % Punto de Gauss
                ksi = uNod(inode,1);
                eta = uNod(inode,2);
                % Derivadas de las funciones de forma respecto de ksi, eta
                
                dN1k = 1/4*(2*ksi-1)*(eta-1)*eta;
                dN1e = 1/4*(ksi-1)*(2*eta-1)*ksi;
                dN2k = 1/4*(2*ksi+1)*(eta-1)*eta;
                dN2e = 1/4*(ksi+1)*(2*eta-1)*ksi;
                dN3k = 1/4*(2*ksi+1)*(eta+1)*eta;
                dN3e = 1/4*(ksi+1)*(2*eta+1)*ksi;
                dN4k = 1/4*(2*ksi-1)*(eta+1)*eta;
                dN4e = 1/4*(ksi-1)*(2*eta+1)*ksi;
                dN5k = -(eta-1)*ksi*eta;
                dN5e = -1/2*(ksi^2-1)*(2*eta-1);
                dN6k = -1/2*(eta^2-1)*(2*ksi+1);
                dN6e = -(ksi+1)*ksi*eta;
                dN7k = -(eta+1)*ksi*eta;
                dN7e = -1/2*(ksi^2-1)*(2*eta+1);
                dN8k = -1/2*(eta^2-1)*(2*ksi-1);
                dN8e = -(ksi-1)*ksi*eta;
                dN9k = 2*(eta^2-1)*ksi;
                dN9e = 2*(ksi^2-1)*eta;
                
                
                dN = [ dN1k   dN2k   dN3k   dN4k   dN5k   dN6k   dN7k   dN8k   dN9k
                       dN1e   dN2e   dN3e   dN4e   dN5e   dN6e   dN7e   dN8e   dN9e ];

                % Derivadas de x,y, respecto de ksi, eta
                jac = dN*nodesEle;
                % Derivadas de las funciones de forma respecto de x,y.
                dNxy = jac\dN;          % dNxy = inv(jac)*dN

                B = zeros(size(C,2),nDofNod*nNodEle);
                B(1,1:2:17) = dNxy(1,:);
                B(2,2:2:18) = dNxy(2,:);
                B(3,1:2:17) = dNxy(2,:);
                B(3,2:2:18) = dNxy(1,:);

                eleDofs = node2dof(elements(iele,:),nDofNod);
                stress(iele,inode,:) = C*B*D(eleDofs);
            end
        end
end
        
%% Configuración deformada
D = (reshape(D,nDofNod,[]))';
nodePosition = nodes + D(:,1:2);

%Tensiones de von mises
stresse = sqrt(((stress(:,:,1)).^2) + ((stress(:,:,2)).^2) - (stress(:,:,1)) .* (stress(:,:,2)) + 3 * ((stress(:,:,3)).^2));

%Graficación
switch caso
    case 6
        bandplot(elements,nodePosition,stress(:,:,1),[],'k');
        meshplot(elements,nodes,'b');
    case 7
        bandplot(elements,nodePosition,stress(:,:,2),[],'k');
        meshplot(elements,nodes,'b');
    case 8
        bandplot(elements,nodePosition,stress(:,:,3),[],'k');
        meshplot(elements,nodes,'b');
    otherwise
        bandplot(elements,nodePosition,stresse(:,:),[],'k',10);
        meshplot(elements,nodes,'c');
end

%% Condition number
hmax = 0;
hmin = inf;

switch tipoelemento
    case 1
        for i = 1:nel;
            a = elements(i,[1 2]);
            b = elements(i,[2 3]);
            c = elements(i,[3 4]);
            d = elements(i,[4 1]);

            h1 = norm( [nodes(a(1,2),1) - nodes(a(1,1),1) , nodes(a(1,2),2) - nodes(a(1,1),2)]);
            h2 = norm( [nodes(b(1,2),1) - nodes(b(1,1),1) , nodes(b(1,2),2) - nodes(b(1,1),2)]);
            h3 = norm( [nodes(c(1,2),1) - nodes(c(1,1),1) , nodes(c(1,2),2) - nodes(c(1,1),2)]);
            h4 = norm( [nodes(d(1,2),1) - nodes(d(1,1),1) , nodes(d(1,2),2) - nodes(d(1,1),2)]);

            H = [h1 h2 h3 h4];

            hmaxlocal = max(H);
            hminlocal = min(H);

            if hmaxlocal >= hmax;
                hmax = hmaxlocal;
            end

            if hminlocal <= hmin;
                hmin = hminlocal;
            end
        end
    case 2
                for i = 1:nel;
                    a = elements(i,[1 5]);
                    b = elements(i,[5 2]);
                    c = elements(i,[2 6]);
                    d = elements(i,[6 3]);
                    e = elements(i,[3 7]);
                    f = elements(i,[7 4]);
                    g = elements(i,[4 8]);
                    h = elements(i,[8 1]);

                    h1 = norm( [nodes(a(1,2),1) - nodes(a(1,1),1) , nodes(a(1,2),2) - nodes(a(1,1),2)]);
                    h2 = norm( [nodes(b(1,2),1) - nodes(b(1,1),1) , nodes(b(1,2),2) - nodes(b(1,1),2)]);
                    h3 = norm( [nodes(c(1,2),1) - nodes(c(1,1),1) , nodes(c(1,2),2) - nodes(c(1,1),2)]);
                    h4 = norm( [nodes(d(1,2),1) - nodes(d(1,1),1) , nodes(d(1,2),2) - nodes(d(1,1),2)]);
                    h5 = norm( [nodes(e(1,2),1) - nodes(e(1,1),1) , nodes(e(1,2),2) - nodes(e(1,1),2)]);
                    h6 = norm( [nodes(f(1,2),1) - nodes(f(1,1),1) , nodes(f(1,2),2) - nodes(f(1,1),2)]);
                    h7 = norm( [nodes(g(1,2),1) - nodes(g(1,1),1) , nodes(g(1,2),2) - nodes(g(1,1),2)]);
                    h8 = norm( [nodes(h(1,2),1) - nodes(h(1,1),1) , nodes(h(1,2),2) - nodes(h(1,1),2)]);

                    H = [h1 h2 h3 h4 h5 h6 h7 h8];

                    hmaxlocal = max(H);
                    hminlocal = min(H);

                    if hmaxlocal >= hmax;
                        hmax = hmaxlocal;
                    end

                    if hminlocal <= hmin;
                        hmin = hminlocal;
                    end
                end
end

condition = cond (K(isFree,isFree));

disp ('Con la funcion cond de matlab')
disp (condition)


switch caso
    case 9
    otherwise
        switch tipoelemento
            case 1
                resultadosQ4(caso,1) = condition;
                resultadosQ4(caso,2) = hmax/hmin;
                resultadosQ4(caso,3) = nel;
            case 2
                resultadosQ9(caso,1) = condition;
                resultadosQ9(caso,2) = hmax/hmin;
                resultadosQ9(caso,3) = nel;
        end
end


toc


