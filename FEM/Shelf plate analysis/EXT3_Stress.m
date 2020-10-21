Elems = evalin('base','Elems');
Coord = evalin('base','Coord');
M     = evalin('base','M');

 %% ------------------------------------------------------------------ %%

hold on

for ie = 1:nele
for iv = 1:4
    in = Elems(ie,iv);
    Mn = M(in,:);
    Mxx(ie,iv) = Mn(1);
    Myy(ie,iv) = Mn(2);
    Mxy(ie,iv) = Mn(3);
end
end

Sxx = Mxx * 3/(t^2);
Syy = Myy * 3/(t^2);
Txy = Mxy * 3/(t^2);

Tvm = (Sxx.*Sxx + Syy.*Syy - Sxx.*Syy + 3*Txy.*Txy).^(1/2);

bandplot(Elems,Coord,Tvm,[],'k')

Sxx_max = max(max(abs(Sxx)));
Syy_max = max(max(abs(Syy)));
Txy_max = max(max(abs(Txy)));
Tvm_max = max(max(abs(Tvm)));