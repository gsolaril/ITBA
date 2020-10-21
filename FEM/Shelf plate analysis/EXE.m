clear all
clc

 %% ======================== DATOS RELEVANTES ======================== %%

Lx = 420   ;   Ly = 400   ;   ex = 10    ;   ey = 10   ;   t = 1   ;

E = 200000 ;   m = 0.3    ;   W = 1      ;   Z = 0     ;

s_f = 0    ;   s_b = 0    ;   s_l = 1    ;   s_r = 2   ;

assignin('base','E',E);      % Módulo de elasticidad
assignin('base','m',m);      % Módulo de Poisson
assignin('base','t',t);      % Espesor de placa

assignin('base','Lx',Lx);    % Profundidad de locker
assignin('base','Ly',Ly);    % Ancho de locker

assignin('base','ex',ex);    % Número de elementos en "x": a lo profundo
assignin('base','ey',ey);    % Número de elementos en "y": a lo ancho

assignin('base','s_f',s_f);  % Condiciones del borde frontal    ...x = Lx
assignin('base','s_b',s_b);  % Condiciones del borde trasero    ...x = 0
assignin('base','s_l',s_l);  % Condiciones del borde derecho    ...y = 0
assignin('base','s_r',s_r);  % Condiciones del borde izquierdo  ...y = Ly

 %% ========================== MODELIZACIÓN ========================== %%

lx = Lx/ex; % Largo del elemento en "x"
ly = Ly/ey; % Largo del elemento en "y"
 
mesh_x = (0:lx:Lx);                     % Saltos en "x"
mesh_x = fliplr(mesh_x);                % Se cuenta de derecha a izquierda
mesh_y = (0:ly:Ly);                     % Saltos en "y"
[mesh_x,mesh_y] = meshgrid(mesh_x,mesh_y); % De saltos a matrices

nele = (ex+0)*(ey+0);               % Cantidad de elementos
nnod = (ex+1)*(ey+1);               % Cantidad de nodos
grid_n = reshape(1:nnod,ex+1,[])';  % Matriz de posición de nodos
grid_e = reshape(1:nele,ex+0,[])';  % Matriz de posición de elementos
grid_m = grid_n(2:end-1,2:end-1);   % Matriz de nodos fuera del borde

for iy = 1:(ey)
for ix = 1:(ex)
    ie = grid_e(iy,ix);
    % Ahora, para el elemento "ie", me ubico    _________________________
    % en el nodo numero "grid_n(iy,ix)" que en |                  grid_n |
    % el plano es el nodo inferior izquierdo   |                         |
    % del elemento, y recorro una trayectoria  | (iy,ix)----->(iy,ix+1)  |
    % "cuadrada" dentro de la matriz "grid_n", |     A  1   2  |         |
    % identificando los otros tres nodos del   |     |         |         |
    % elemento "ie". Construyo un vector fila  |     |  4   3  V         |
    % con esos nodos, el cual es la fila "ie"  | (iy+1,ix)<--(iy+1,ix+1) |
    % de "Elems":                              |_________________________|
    
elems = [grid_n(iy,ix) grid_n(iy,ix+1) grid_n(iy+1,ix+1) grid_n(iy+1,ix)];
Elems(ie,:) = elems;
end
end

mesh_x = reshape(mesh_x',1,[])';      % Apilo coordenadas de nodos en "x"
mesh_y = reshape(mesh_y',1,[])';      % Apilo coordenadas de nodos en "y"
Coord = [ mesh_x  mesh_y  zeros(nnod,1)]; % Tabla de coordenadas nodales

% El mallado vendría a tener la siguiente forma:
%
%               (borde frontal: "x = Lx")
%          nnod______ _...._ _______ _______
%            |       |      |       |       |
%            |(ex*ey)|      |       |       |
%  (borde    |_______|_...._|_______|_______|  (borde
% izquierdo: |       |      |       |       |  derecho:
%  "y = Ly"  :       :      :       :       :  "y = 0")
%            |_______|_...._|_______|_______|
%            |       |      |       |       | A "x"
%            | (ey)  |      |  (2)  |  (1)  | |
%            |_______|_...._3_______2_______1 |
%                                  "y" <------+ (coordenadas
%               (borde trasero: "x = 0")          globales)
 
  %% ====================== GRADOS DE LIBERTAD ====================== %%
  
DOFs = zeros(nele,12);  % 3 grados de libertad por nodo ("w", "ox", "oy"),
                        % 4 nodos por elemento de Kirchhoff: "3 x 4 = 12";

% Cada elemento va a tener entonces 12 grados de libertad:
% ..."w1","ox1","oy1","w2","ox2","oy2","w3","ox3","oy3","w4","ox4","oy4"
                        
for ie = 1:nele
    Ne = Elems(ie,:);
    dof1 = 3*Ne - 2;
    dof2 = 3*Ne - 1;
    dof3 = 3*Ne - 0;
    dofs = [ dof1
             dof2
             dof3 ];
    dofs = reshape(dofs,[],1);
    DOFs(ie,:) = dofs';
end

ndof = 3*nnod; % Cantidad de grados de libertad en el mallado completo...

%% =========================== CONDICIONES =========================== %%

cond_1 = ones(size(grid_n));  % Restricción de desplazamiento "w"
cond_2 = ones(size(grid_n));  % Restricción de inclinación en torno a "x"
cond_3 = ones(size(grid_n));  % Restricción de inclinación en torno a "y"

switch s_f    % Condiciones borde frontal
    case 1    % Apoyo fijo en borde frontal
        cond_1(end,:) = 0;
    case 2    % Empotramiento en borde frontal
        cond_1(end,:) = 0;
        cond_2(end,:) = 0;
        cond_3(end,:) = 0;
end

switch s_b    % Condiciones borde trasero
    case 1    % Apoyo fijo en borde trasero
        cond_1(1,:) = 0;
    case 2    % Empotramiento en borde trasero
        cond_1(1,:) = 0;
        cond_2(1,:) = 0;
        cond_3(1,:) = 0;
end

switch s_l    % Condiciones borde izquierdo
    case 1    % Apoyo fijo en borde izquierdo
        cond_1(:,end) = 0;
    case 2    % Empotramiento en borde izquierdo
        cond_1(:,end) = 0;
        cond_2(:,end) = 0;
        cond_3(:,end) = 0;
end

switch s_r    % Condiciones borde derecho
    case 1    % Apoyo fijo en borde derecho
        cond_1(:,1) = 0;
    case 2    % Empotramiento en borde derecho
        cond_1(:,1) = 0;
        cond_2(:,1) = 0;
        cond_3(:,1) = 0;
end

% Apilamiento de condiciones de borde
cond_1 = reshape(cond_1',1,[])';
cond_2 = reshape(cond_2',1,[])';
cond_3 = reshape(cond_3',1,[])';

cond = [cond_1 cond_2 cond_3];
cond = reshape(cond',[],1);
cond = logical(cond);

 %% ======================= FUNCIONES DE FORMA ======================= %%

syms x y real

% Según la teoría, para interpolar un campo de 12 grados de libertad en un
% elemento, requiero de 12 funciones de forma. Para un elemento Kirchhoff,
% tengo 4 nodos, cada uno con 3 grados de libertad:
%  1) Grado de libertad "w"
%  2) Grado de libertad "ox" donde "ox = dw/dx".
%  3) Grado de libertad "oy" donde "oy = dw/dy".

p_xy = [                    1                      ...     % Polinomio de
                     x             y               ...     % 12 terminos;
               x^2         x*y         y^2         ...     % 4to grado
         x^3       x^2*y         x*y^2       y^3   ...     % (incompleto)
              x^3*y                   x*y^3         ];

% ...para interpolar al grado de libertad "w1", voy a tener que tomar un
% polinomio formado por términos de cada uno de los elementos del vector
% "p_xy", multiplicandolos por constantes "aw1(i)"...
% {aw1(1) ... aw1(12)} * "p_xy" = aw1(1) + aw1(2)*x + ... + aw1(12)*x*y^3
% ...para interpolar al grado de libertad "ox1 = dw1/dx", tengo que usar
% un polinomio formado por cada uno de los términos del vector "p_dx" que
% son iguales a la derivada de los terminos de "p_xy" por "x"...
% ...para interpolar al grado de libertad "oy1 = dw1/dy", voy a tener que
% repetir este ultimo procedimiento pero derivando los términos del vector
% "p_xy" por "y" para llegar a "p_dy"...

p_dx = diff(p_xy,x); 
p_dy = diff(p_xy,y);

% Por cada elemento (exactamente rectangular, de dimensiones "lx" y "ly"),
% tengo un sistema de coordenadas con origen en el centro del elemento con
% "x" que va de "-lx/2" a "+lx/2" y con "y" que va de "-ly/2" a "+ly/2"...
% (todos los elementos son iguales; no tengo que usar c. isoparametricas)

% Nodos "1", "2", "3", "4"             %  (-lx/2;+ly/2)<---(+lx/2;+ly/2)
                                       %        |{4}          {3}A
Cn = [  -lx  +lx  +lx  -lx             %        |                |
        -ly  -ly  +ly  +ly   ]'/2;     %        V{1}          {2}|
                                       %  (-lx/2;-ly/2)--->(+lx/2;-ly/2)
A = zeros(4,12);
for in = 1:4
    f1 = 3*in - 2;   % Armo ahora la matriz "A" formada principalmente por
    f2 = 3*in - 1;   % 4 bloques, que son los 3 polinomios interpoladores
    f3 = 3*in - 0;   % evaluados en las coordenadas de los nodos ("Cn") de
    xn = Cn(in,1);   % cada elemento; un bloque por nodo.
    yn = Cn(in,2);
    A([f1 f2 f3],:) = [ subs(p_xy,{x,y},{xn,yn})
                        subs(p_dx,{x,y},{xn,yn})
                        subs(p_dy,{x,y},{xn,yn}) ];
end

fn = p_xy/A;       % El vector de 12 funciones de forma es igual al vector
fn = simplify(fn); % de términos por la inversa de la matriz "A"...

%  calculo las derivadas segundas de cada grado
% de libertad 

for in = 1:12                         % Para armar la matriz "B":
    fi = fn(in);                      %      _                           _
    B(:,in) = [ diff(diff(fi,x),x)    % B = | d2(w1)/dx2     d2(oy4)/dx2  |
                diff(diff(fi,y),y)    %     | d2(w1)/dy2 ... d2(oy4)/dy2  |
              2*diff(diff(fi,x),y) ]; %     |_d2(w1)/dxdy    d2(oy4)/dxdy_|
end

 %% ==================== MATRIZ DE RIGIDEZ GLOBAL ==================== %%

C = [ 1     m     0
      m     1     0
      0     0  (1-m)/2 ]* (E*t^3) / (12*(1-m^2));
  
K = zeros(ndof);

k = (B')*(C)*(B);
k = int(k,x,-lx/2,+lx/2);
k = int(k,y,-ly/2,+ly/2);
k = eval(k);

for ie = 1:nele
    dofs = DOFs(ie,:);
    K(dofs,dofs) = K(dofs,dofs) + k;
end

 %% ======================== FUERZAS EXTERNAS ======================== %%

Fz = -ones(size(grid_n));        % Genero una matriz de grilla "Fz" donde
                                 % cada celda representa a su nodo (igual
Fz(1,:)   = (1/2)*Fz(1,:);       % que "grid_n"), y ubico la carga nodal
Fz(end,:) = (1/2)*Fz(end,:);     % equivalente en cada celda...
Fz(:,1)   = (1/2)*Fz(:,1);       %  - Celdas centrales: "Fz(i,j) = 1" 
Fz(:,end) = (1/2)*Fz(:,end);     %  - Celdas de bordes: "Fz(i,j) = 1/2"
                                 %  - Celdas de puntas: "Fz(i,j) = 1/4"
Fz = 10*W*Fz/sum(sum(abs(Fz)));  % ...luego la normalizo y la multiplico
                                 % por el peso "W[Kg] * 10 m/seg2".

Fz = reshape(Fz',1,[])';    % Paso de matriz "Fz" a vector columna "Fz"
Mx = zeros(nnod,1);         % Vector columna de momentos "Mx"
My = zeros(nnod,1);         % Vector columna de momentos "My"

F = [Fz Mx My];        % Vector de cargas externas, con las fuerzas y 
                       % momentos intercalados y agrupados por nodo:
F = reshape(F',[],1);  % F = [Fz(1) Mx(1) My(1) Fz(2) Mx(2) ... My(nnod)]

%% ============================ RESOLUCIÓN ============================ %%

% Reducción del sistema:
K_red = K(cond,cond);          
F_red = F(cond);

% Resolución del sistema de ecuaciones:
d_red = (K_red)\(F_red);

% Armado del vector columna "D" completo:
D = zeros(size(cond));
D(cond) = D(cond) + d_red;

% Reacciones:
R = K*D - F;
R = reshape(R,3,[])';

% Coordenadas desplazadas:
Cdisp = [ Coord(:,1) Coord(:,2) D(1:3:end) ];

 %% ======================= CÁLCULO DE MOMENTOS ======================= %%

M = zeros(nnod,3);
% En punta trasera derecha:
in = grid_n(1,1);  % Número de nodo del mallado
ie = grid_e(1,1);  % Elemento del cual tomo los interpoladores
dofs = DOFs(ie,:); % Grados de libertad correspondientes al elemento
M(in,:) = C*subs(B,{x,y},{Cn(1,1),Cn(1,2)})*D(dofs);
% En punta trasera izquierda:
in = grid_n(1,end);
ie = grid_e(1,end);
dofs = DOFs(ie,:);
M(in,:) = C*subs(B,{x,y},{Cn(2,1),Cn(2,2)})*D(dofs);
% En punta frontal izquierda:
in = grid_n(end,end);
ie = grid_e(end,end);
dofs = DOFs(ie,:);
M(in,:) = C*subs(B,{x,y},{Cn(3,1),Cn(3,2)})*D(dofs);
% En punta frontal derecha:
in = grid_n(end,1);
ie = grid_e(end,1);
dofs = DOFs(ie,:);
M(in,:) = C*subs(B,{x,y},{Cn(4,1),Cn(4,2)})*D(dofs);

% Borde frontal ---------------------------------------------------------
nn = grid_n(end,2:end-1); % Borde formado por los nodos "nn" (sin puntas)
ne = grid_e(end,1:end);   % ...que pertenecen a los elementos "ne".
cn = [ +lx/2   0 ];
% Calculo los momentos en el punto "{a}" del elemento       
% "ie"como muestra el dibujo ("x = +lx/2", "y = 0")     %  ,----{a}----,
for ie = 1:length(ne)                                   %  |           |
    dofs = DOFs(ne(ie),:);                              %  |     A (x) |
    % Voy armando una lista "Mctr" con ellos:           %  | (y) |     |
    Mctr(ie,:) = C*subs(B,{x,y},{cn(1),cn(2)})*D(dofs); %  :  <--+     :
end
% Momentos en el nodo "in" como promedio de los momentos  
% en los puntos {a} y {b} en los elementos vecinos:       -{a}--{c}--{b}-
for il = 1:length(nn)                                   %        |
    in = nn(il);                                        % (il+1) |  (il)
    % Los incluyo en la matriz de momentos nodales:     %        :
    M(in,:) = mean([ Mctr(il,:)  Mctr(il+1,:) ]);       %  Mc = (Ma+Mb)/2
end

% Borde trasero ---------------------------------------------------------
nn = grid_n(1,2:end-1);    % Borde formado por los nodos "nn" (sin puntas)
ne = grid_e(1,1:end);      % ...que pertenecen a los elementos "ne".
cn = [ -lx/2   0 ];
% Calculo los momentos en el punto "{a}" del elemento      
% "ie"como muestra el dibujo ("x = -lx/2", "y = 0")     %  :     A (x) :
for ie = 1:length(ne)                                   %  | (y) |     |
    dofs = DOFs(ne(ie),:);                              %  |  <--+     |
    % Voy armando una lista "Mctr" con ellos:           %  |           |
    Mctr(ie,:) = C*subs(B,{x,y},{cn(1),cn(2)})*D(dofs); %   ----{a}----
end
% Momentos en el nodo "in" como promedio de los momentos
% en los puntos {a} y {b} en los elementos vecinos:       (il+1) :  (il)
for il = 1:length(nn)                                   %        |
    in = nn(il);                                        % -{a}--{c}--{b}-
    % Los incluyo en la matriz de momentos nodales:     %
    M(in,:) = mean([ Mctr(il,:)  Mctr(il+1,:) ]);       %  Mc = (Ma+Mb)/2
end

% Borde derecho ---------------------------------------------------------
nn = grid_n(2:end-1,1);    % Borde formado por los nodos "nn" (sin puntas)
ne = grid_e(1:end,1);      % ...que pertenecen a los elementos "ne".
cn = [ 0   -ly/2 ];
% Calculo los momentos en el punto "{a}" del elemento         _________
% "ie"como muestra el dibujo ("x = 0", "y = -ly/2")     %        A (x) |
for ie = 1:length(ne)                                   %    (y) |     |
    dofs = DOFs(ne(ie),:);                              %     <--+    {a}
    % Voy armando una lista "Mctr" con ellos:           %              |
    Mctr(ie,:) = C*subs(B,{x,y},{cn(1),cn(2)})*D(dofs); %     _________|
end
% Momentos en el nodo "in" como promedio de los momentos      (il+1) {b}
% en los puntos {a} y {b} en los elementos vecinos:                   |
for il = 1:length(nn)                                   %      ------{c}
    in = nn(il);                                        %             |
    % Los incluyo en la matriz de momentos nodales:     %      (il)  {a}
    M(in,:) = mean([ Mctr(il,:)  Mctr(il+1,:) ]);       %  Mc = (Ma+Mb)/2
end

% Borde izquierdo -------------------------------------------------------
nn = grid_n(2:end-1,end);  % Borde formado por los nodos "nn" (sin puntas)
ne = grid_e(1:end,end);    % ...que pertenecen a los elementos "ne".
cn = [ 0   +ly/2 ];
% Calculo los momentos en el punto "{a}" del elemento        _________
% "ie"como muestra el dibujo ("x = 0", "y = +ly/2")     %   |     A (x)
for ie = 1:length(ne)                                   %   | (y) |
    dofs = DOFs(ne(ie),:);                              %  {a} <--+
    % Voy armando una lista "Mctr" con ellos:           %   |
    Mctr(ie,:) = C*subs(B,{x,y},{cn(1),cn(2)})*D(dofs); %   |_________
end
% Momentos en el nodo "in" como promedio de los momentos     {b} (il+1)
% en los puntos {a} y {b} en los elementos vecinos:           |
for il = 1:length(nn)                                   %    {c}------
    in = nn(il);                                        %     |
    % Los incluyo en la matriz de momentos nodales:     %    {a}  (il)
    M(in,:) = mean([ Mctr(il,:)  Mctr(il+1,:) ]);       %  Mc = (Ma+Mb)/2
end

% Nodos centrales -------------------------------------------------------
% Es un proceso similar a los anteriores, solamente que ahora calculo las
% tensiones en nodos vecinos a 4 elementos, no a 2... por lo tanto para
% cada elemento, enlisto las tensiones "Mctr" en su centro "(x;y)=(0;0)"
for ie = 1:nele
    dofs = DOFs(ie,:);
    Mctr(ie,:) = C*subs(B,{x,y},{0,0})*D(dofs);
end
% La matriz "grid_m" contiene los nodos "centrales", que no tocan ningún
% borde. Lo que hago es tomar un nodo, y promediar los momentos de los
% elementos vecinos (en "Mctr"):
for iy = 1:(ey-1)                     % "surr" identifica a los elementos
for ix = 1:(ex-1)                     % vecinos que rodean al nodo "in":
    in = grid_m(iy,ix);               %
    surr = [ grid_e(iy,ix)...         %    surr(3)    |    surr(4)
             grid_e(iy,ix+1)...       %               |
             grid_e(iy+1,ix+1)...     %      --------[c]--------
             grid_e(iy+1,ix) ];       %               |
    M(in,:) = mean(Mctr(surr,:));     %    surr(2)    |    surr(1)
end
end

 %% ------------------- CÁLCULO DE DESPLAZAMIENTOS ------------------- %%

figure(1)
 
plot3(Coord(:,1),Coord(:,2),Coord(:,3),'bo','MarkerEdgeColor','k',...
                                            'MarkerFaceColor','b',...
                                            'MarkerSize',3)
xlabel('x')
ylabel('y')
zlabel('w')
hold on
      
for ie = 1:nele
    Ne = [ Elems(ie,:)     Elems(ie,1) ];
    Xe = Coord(Ne,:);
    plot3(Xe(:,1),Xe(:,2),Xe(:,3),'-r','LineWidth',1.25)
    Xmid = mean(Xe);
    text(Xmid(1),Xmid(2),Xmid(3),strcat(num2str(ie)),...
    'FontSize',12/log10(nele),'FontWeight','bold',...
    'HorizontalAlignment','left')
end

Czoom = [ Cdisp(:,1:2)   Cdisp(:,3)*(10^Z) ];

for ie = 1:nele
    Ne = [ Elems(ie,:)     Elems(ie,1) ];
    Xe = Czoom(Ne,:);
    plot3(Xe(:,1),Xe(:,2),Xe(:,3),'--g','LineWidth',1.25)
end

axis([0 Lx 0 Ly -2*max(abs(D)) +2*max(abs(D))])

 %% ====================== CÁLCULO DE TENSIONES ====================== %%

% Para poder usar "bandplot", tengo que armar una matriz similar a la de
% conectividades "Elems", pero teniendo los momentos nodales para cada
% elemento: "Mxx", "Myy" y "Mxy"

for ie = 1:nele
for iv = 1:4
    in = Elems(ie,iv);
    Mn = M(in,:);
    Mxx(ie,iv) = Mn(1);
    Myy(ie,iv) = Mn(2);
    Mxy(ie,iv) = Mn(3);
end
end

% Relaciones entre tensiones (en "z = {+-}t/2") y momentos:

Sxx = Mxx * (-6)/(t^2);
Syy = Myy * (-6)/(t^2);
Txy = Mxy * (-6)/(t^2);

Tvm = (Sxx.*Sxx + Syy.*Syy - Sxx.*Syy + 3*Txy.*Txy).^(1/2);

figure(2)
hold on

bandplot(Elems,Coord,Tvm,[],'k')

Sxx_max = max(max(abs(Sxx)));
Syy_max = max(max(abs(Syy)));
Txy_max = max(max(abs(Txy)));
Tvm_max = max(max(abs(Tvm)));
