assignin('base','W','W')
assignin('base','Z','Z')

Lx = evalin('base','Lx');
Ly = evalin('base','Ly');

nnod  = evalin('base','nnod');
nele  = evalin('base','nele');
Coord = evalin('base','Coord');
Cdisp = evalin('base','Cdisp');
Elems = evalin('base','Elems');

%% -------------------------------------------------------------------- %%

Czoom = [ Cdisp(:,1:2)   Cdisp(:,3)*W/(Lx*Ly) ];

hold on

for ie = 1:nele
    Ne = [ Elems(ie,:)     Elems(ie,1) ];
    Xe = Czoom(Ne,:);
    plot3(Xe(:,1),Xe(:,2),Xe(:,3),'--g','LineWidth',1.25)
end