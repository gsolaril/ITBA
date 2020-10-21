assignin('base','E',E);
assignin('base','m',m);
assignin('base','t',t);
assignin('base','inc',inc);
assignin('base','LH',LH);
assignin('base','LV',LV);
assignin('base','LR',LR);
assignin('base','LD',LD);
assignin('base','er',er);
assignin('base','eh',eh);
assignin('base','el',el);
assignin('base','em',em);

Q    = evalin('base','Q');
sub  = evalin('base','sub');

Ciso = evalin('base','Ciso');
Cmat = evalin('base','Cmat');
pg   = evalin('base','pg');
Cupg = evalin('base','Cupg');
Wupg = evalin('base','Wupg');

nupg = evalin('base','nupg');

fn   = evalin('base','fn');
fd   = evalin('base','fd');

 %% ----------------------- Cuadrícula inicial ----------------------- %%

npe = fix(Q/4);

stepr = 0:1/(er*npe):1;
steph = 0:1/(eh*npe):1;
stepl = 0:1/(el*npe):1;
stepm = 0:1/(em*npe):1;

nmid = 1 + em*npe/2;
nend = 1 + em*npe;
nwid = 1 + eh*npe;
nrad = 1 + er*npe;

 %% ------------------------ Mallado inferior ------------------------ %%

[Grid_x,Grid_y] = meshgrid(stepr,stepl);

xmin =  0;
xmax =  LD;
ymin = -LV;
ymax = -LD-LR ;

Grid_x = xmax + Grid_x*(xmin - xmax);
Grid_y = ymin + Grid_y*(ymax - ymin);

Coord_x = reshape(Grid_x',[],1);
Coord_y = reshape(Grid_y',[],1);
Coord_1 = [ Coord_x  Coord_y ];

 %% ----------------------- Mallado de esquina ----------------------- %%

[Grid_r,Grid_a] = meshgrid(stepr,stepm);
 
Grid_r = Grid_r*LD + LR;
Grid_a = Grid_a*(pi/2);

rmin = LR;
rmax = LR+LD;

r_inc_r = ((Grid_r - rmin)/(rmax - rmin)).^inc;
r_inc_a(1:nmid,:)    = -1 + 1 ./ cos(Grid_a(1:nmid,:));
r_inc_a(nmid:nend,:) = -1 + 1 ./ sin(Grid_a(nmid:nend,:));
r_inc = 1 + (r_inc_a).*(r_inc_r);

Grid_r = (Grid_r).*(r_inc);

[Grid_x,Grid_y] = pol2cart(Grid_a,Grid_r);

Grid_x = rmax - Grid_x;
Grid_y = Grid_y - rmax;

Grid_x(1,:)   = [];
Grid_x(end,:) = [];
Grid_y(1,:)   = [];
Grid_y(end,:) = [];

Coord_x = reshape(Grid_x',[],1);
Coord_y = reshape(Grid_y',[],1);
Coord_2 = [ Coord_x  Coord_y ];

 %% ------------------------ Mallado superior ------------------------ %%

[Grid_x,Grid_y] = meshgrid(steph,stepr);

xmin =  LD+LR;
xmax =  LH;
ymin = -LD;
ymax =  0 ;

Grid_x = xmin + Grid_x*(xmax - xmin);
Grid_y = ymin + Grid_y*(ymax - ymin);

Coord_x = reshape(Grid_x,[],1);
Coord_y = reshape(Grid_y,[],1);
Coord_3 = [ Coord_x  Coord_y ];

 %% ----------------- Matriz de coordenadas de nodos ----------------- %%

Coord = [ Coord_1
          Coord_2
          Coord_3 ];

 %% -------------------- Matriz de conectividades -------------------- %%

nnod = length(Coord);

Grid = 1:nnod;
Grid = reshape(Grid',nrad,[])';

nele = er*(eh+el+em);

switch Q
    case {4}
        iele = 1;
        rows = size(Grid,1) - 1;
        cols = size(Grid,2) - 1;
        for row = 1:1:rows
        for col = 1:1:cols
            if iele <= nele/2
                Elems(iele,:) = [ Grid(row+0,col+1)...
                                  Grid(row+0,col+0)...
                                  Grid(row+1,col+0)...
                                  Grid(row+1,col+1) ];
            else
                Elems(iele,:) = [ Grid(row+0,col+0)...
                                  Grid(row+1,col+0)...
                                  Grid(row+1,col+1)...
                                  Grid(row+0,col+1) ];
            end
            iele = iele + 1;
        end
        end
    case {8}
        iele = 1;
        rows = size(Grid,1) - 2;
        cols = size(Grid,2) - 2;
        for row = 1:2:rows
        for col = 1:2:cols
            if iele <= nele/2
                Elems(iele,:) = [ Grid(row+0,col+2)...
                                  Grid(row+0,col+1)...
                                  Grid(row+0,col+0)...
                                  Grid(row+1,col+0)... 
                                  Grid(row+2,col+0)...
                                  Grid(row+2,col+1)...
                                  Grid(row+2,col+2)...
                                  Grid(row+1,col+2) ];
            else
                Elems(iele,:) = [ Grid(row+0,col+0)... 
                                  Grid(row+1,col+0)...
                                  Grid(row+2,col+0)...
                                  Grid(row+2,col+1)... 
                                  Grid(row+2,col+2)...
                                  Grid(row+1,col+2)...
                                  Grid(row+0,col+2)...
                                  Grid(row+0,col+1) ];
            end
            iele = iele + 1;
        end
        end
    case {9}
        iele = 1;
        rows = size(Grid,1) - 2;
        cols = size(Grid,2) - 2;
        for row = 1:2:rows
        for col = 1:2:cols
            if iele <= nele/2
                Elems(iele,:) = [ Grid(row+0,col+2)...
                                  Grid(row+0,col+1)...
                                  Grid(row+0,col+0)...
                                  Grid(row+1,col+0)... 
                                  Grid(row+2,col+0)...
                                  Grid(row+2,col+1)...
                                  Grid(row+2,col+2)...
                                  Grid(row+1,col+2)...
                                  Grid(row+1,col+1)];
            else
                Elems(iele,:) = [ Grid(row+0,col+0)... 
                                  Grid(row+1,col+0)...
                                  Grid(row+2,col+0)...
                                  Grid(row+2,col+1)... 
                                  Grid(row+2,col+2)...
                                  Grid(row+1,col+2)...
                                  Grid(row+0,col+2)...
                                  Grid(row+0,col+1)...
                                  Grid(row+1,col+1)];
            end
            iele = iele + 1;
        end
        end
end

  %% ------------------ Matriz de grados de libertad ------------------ %%

DOFs = zeros(nele,2*Q);
 
for iele = 1:nele
    Nele = Elems(iele,:);
    dofx = 2*Nele - 1;
    dofy = 2*Nele;
    dofs = [ dofx
             dofy ];
    dofs = reshape(dofs,[],1);
    DOFs(iele,:) = dofs';
end

ndof = max(max(DOFs));


 %% -------------------- Matriz de rigidez global -------------------- %%

syms x y real

C = [ 1     m     0
      m     1     0
      0     0  (1-m)/2 ]*E/(1-m^2);
  
K = zeros(ndof);

for iele = 1:nele
    K_ele = zeros(2*Q);
    N_ele = Elems(iele,:);
    C_ele = Coord(N_ele,:);
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
        K_dxy = (B')*(C)*(B)*(t)*det(Jcb);
        K_ele = (K_ele) + (K_dxy)*Wupg(ipg);
    end
    dofs = DOFs(iele,:);
    K(dofs,dofs) = K(dofs,dofs) + K_ele;
end

 %% ---------------------- Condiciones de borde ---------------------- %%

BCnd = ones(nnod/nrad,nrad);
nvert = (length(BCnd)+1)/2;
BCnd((1:nvert),end) = 0;

BCnd = reshape(BCnd',[],1);
BCnd = [ BCnd      BCnd ];

if (Q == 8)
    Grid = 1:nnod;
    Grid = reshape(Grid',nrad,[])';
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

Fext_x = zeros(nnod/nrad,nrad);
Fext_y = zeros(nnod/nrad,nrad);

switch Q
    case {4}
        w = ones(1,nwid);
        w(1:2:nwid) = 2;
        w(2:2:nwid) = 2;
        w(1,[1 nwid]) = 1;
        w = w/sum(w);
    case {8,9}
        w = ones(1,nwid);
        w(1:2:nwid) = 2;
        w(2:2:nwid) = 4;
        w(1,[1 nwid]) = 1;
        w = w/sum(w);
end

Fext_x(((end-nwid+1):end),1) = w;

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

v_rext = K*D - (v_fext);
Rext = reshape(v_rext,2,[])';

 %% ---------------------- Cálculo de tensiones ---------------------- %%

for iele = 1:nele
    dofs = DOFs(iele,:);
    for ipg = 1:nupg                         % En puntos de Gauss
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
        Spg0(ipg,:) = C*B*D(dofs);
    end
    switch Q
        case {4,9}
            Spg = Spg0;
        case {8}
            if (sub == 1)
                Spg(1:2:Q,:) = Spg0;
                Spg(2,:) = (Spg0(1,:) + Spg0(2,:))/2;
                Spg(4,:) = (Spg0(2,:) + Spg0(3,:))/2;
                Spg(6,:) = (Spg0(3,:) + Spg0(4,:))/2;
                Spg(8,:) = (Spg0(4,:) + Spg0(1,:))/2;
            else
                Spg(1:1:Q,:) = Spg0(1:8,:);
            end
    end
    for node = 1:Q                           % Extrapolación "rs"
        xext = Ciso(node,1)/pg;
        yext = Ciso(node,2)/pg;
        exf  = subs(fn,{x,y},{xext,yext});
        STR(iele,node,:) = exf*Spg;
    end
end
    
% for iele = 1:nele
%     dofs  = DOFs(iele,:);
%     for ipg = 1:nupg
%         xpg = Cupg(ipg,1);
%         ypg = Cupg(ipg,2);
%         Dsf = subs(fd,{x,y},{xpg,ypg});
%         Jcb = Dsf*(C_ele);
%         Dsf = Jcb\Dsf;
%         for node = 1:1:Q
%             colx = 2*node-1;
%             coly = 2*node;
%             B(:,(colx:coly)) = [ Dsf(1,node)       0
%                                       0       Dsf(2,node)
%                                  Dsf(2,node)  Dsf(1,node) ];
%         end
%         STR(iele,ipg,:) = C*B*D(dofs);
%     end
% end

SVM = ( + STR(:,:,1).*STR(:,:,1)...
        + STR(:,:,2).*STR(:,:,2)...
        - STR(:,:,1).*STR(:,:,2)...
        + STR(:,:,3).*STR(:,:,3).*3 ).^(1/2);

 %% --------------------- Largos característicos --------------------- %%

switch Q
    case {4}
        Loop = [ 1 2 ; 2 3 ; 3 4 ; 4 1 ];
    case {8,9}
        Loop = [ 1 2 ; 2 3 ; 3 4 ; 4 5 ; 5 6 ; 6 7 ; 7 8 ; 8 1 ];
end

loop = length(Loop);

hmax = norm(Coord(2,:)-Coord(1,:));
hmin = norm(Coord(2,:)-Coord(1,:));

for iele = 1:nele
    N_ele = Elems(iele,:);
    C_ele = Coord(N_ele,:);
    for line = 1:loop
        vnod1 = C_ele(Loop(line,1),:);
        vnod2 = C_ele(Loop(line,2),:);
        h = norm(vnod2-vnod1);
        if h >= hmax
           hmax = h;
        end
        if h <= hmin
           hmin = h;
        end
    end
end

 %% ------------------- Diagonales características ------------------- %%

for iele = 1:nele
    N_ele = Elems(iele,:);
    C_ele = Coord(N_ele,:);
    switch Q
        case {4}
            vnoda = C_ele(1,:);
            vnodb = C_ele(2,:);
            vnodc = C_ele(3,:);
            vnodd = C_ele(4,:);
        case {8,9}
            vnoda = C_ele(1,:);
            vnodb = C_ele(3,:);
            vnodc = C_ele(5,:);
            vnodd = C_ele(7,:);
    end
    diag1 = norm(vnodc-vnoda);
    diag2 = norm(vnodd-vnodb);
    Diag(iele,:) = max([ diag1 diag2 ]);
end

dmax = max(Diag);
dmin = min(Diag);

  %% ------------------- Condicionamiento numérico ------------------- %%

qcnd  = reshape(TCnd',[],1);
qcnd  = logical(qcnd);
Kcond = K(qcnd,qcnd);
j = cond(Kcond);
jexp  = floor(log10(j));
jbase = j/(10^jexp);
jbase = ceil(jbase*1000)/1000;

 %% ------------------------------------------------------------------ %%
 
assignin('base','nele',nele)
assignin('base','nnod',nnod)
assignin('base','ndof',ndof)

assignin('base','DOFs' ,DOFs)
assignin('base','Elems',Elems)
assignin('base','Coord',Coord)

assignin('base','BCnd',BCnd)
assignin('base','QCnd',QCnd)
assignin('base','TCnd',TCnd)
assignin('base','Fext',Fext)

assignin('base','w',w)
assignin('base','C',C)
assignin('base','K',K)
assignin('base','D',D)

assignin('base','STR',STR)
assignin('base','SVM',SVM)

assignin('base','hmax',hmax)
assignin('base','hmin',hmin)
assignin('base','dmax',dmax)
assignin('base','dmin',dmin)
assignin('base','Diag',Diag)

assignin('base','j',j)
assignin('base','jexp',jexp)
assignin('base','jbase',jbase) 
assignin('base','Kcond',Kcond)