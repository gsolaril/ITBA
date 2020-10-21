Q     = evalin('base','Q');
sub   = evalin('base','sub');

bp    = evalin('base','bp');
LH    = evalin('base','LH');
LV    = evalin('base','LV');
LD    = evalin('base','LD');
nele  = evalin('base','nele');
Coord = evalin('base','Coord');
Czoom = evalin('base','Czoom');
Cdisp = evalin('base','Cdisp');
Elems = evalin('base','Elems');

Ctest = evalin('base','Ctest');
Patch = evalin('base','Patch');
Disp_p = evalin('base','Disp_p');

S = evalin('base','S');
Smax = evalin('base','Smax');
xS = evalin('base','xS');
yS = evalin('base','yS');
Dmax = evalin('base','Dmax');
xD = evalin('base','xD');
yD = evalin('base','yD');

f = figure(1);
clf

NOW = clock;
mon = num2str(NOW(2));
day = num2str(NOW(3));
hrs = num2str(NOW(4));
min = num2str(NOW(5));
seg = num2str(floor(NOW(6)));

if str2double(mon) < 10
    mon = strcat('0',mon);
end
if str2double(day) < 10
    day = strcat('0',day);
end
if str2double(hrs) < 10
    hrs = strcat('0',hrs);
end
if str2double(min) < 10
    min = strcat('0',min);
end
if str2double(seg) < 10
    seg = strcat('0',seg);
end

date = strcat(mon,day,hrs,min,seg);

 %% ---------------------------- Plot_Mod ---------------------------- %%

plot(Coord(:,1),Coord(:,2),'bo','MarkerEdgeColor','k',...
                                'MarkerFaceColor','b',...
                                'MarkerSize',3)
hold on
grid on
      
for iele = 1:nele
    Nele = [ Elems(iele,:)     Elems(iele,1) ];
    if (Q==9)
        Nele([9 10]) = Nele([10 9]);
    end
    Xele = Coord(Nele,:);
    plot(Xele(:,1),Xele(:,2),'-r','LineWidth',1.25)
    Xmid = mean(Xele);
    text(Xmid(1),Xmid(2),strcat(num2str(iele)),...
    'FontSize',18/log10(nele),'FontWeight','bold',...
    'HorizontalAlignment','center')
end
axis(max(LH,LV)*[ -0.01  1  -1  0.01])

title('Mallado inicial')
saveas(f,'1.fig')
saveas(f,strcat('1_Mesh_',date,'.fig'))
clf

 %% ---------------------------- Plot_PTm ---------------------------- %%

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

Ctstd = Ctest + (Disp_p)*(20/max(max(Disp_p)));

for iele = 1:size(Patch,1)
    Nele = [ Patch(iele,:)     Patch(iele,1) ];
    if (Q == 9)
        Nele([9 10]) = Nele([10 9]);
    end
    Xele = Ctest(Nele,:);
    plot(Xele(:,1),Xele(:,2),'--b','LineWidth',1.5)
    Xfin = Ctstd(Nele,:);
    plot(Xfin(:,1),Xfin(:,2),'-m','LineWidth',1.25)
end
axis equal

title('Patch Test')
saveas(f,'2.fig')
saveas(f,strcat('2_Ptch_',date,'.fig'))
clf

 %% --------------------------- Plot_Disps --------------------------- %%

hold on
grid on

for iele = 1:nele
    Nele = [ Elems(iele,:)     Elems(iele,1) ];
    if (Q == 9)
        Nele([9 10]) = Nele([10 9]);
    end
    Xele = Coord(Nele,:);
    plot(Xele(:,1),Xele(:,2),':r','LineWidth',1.5)
    Xfin = Czoom(Nele,:);
    plot(Xfin(:,1),Xfin(:,2),'-k','LineWidth',1.5)
end
axis equal

title('Mallado deformado')
saveas(f,'3.fig')
saveas(f,strcat('3_Disp_',date,'.fig'))
clf

 %% ---------------------------- Plot_Str ---------------------------- %%
% 
% switch Q
%     case {4}
%         Bands = Elems;
%     case {8}
%         if (sub == 1)
%             Bands = Elems(:,[1 3 5 7]);
%         else
%             Bands = Elems;
%         end
%     case {9}
%         Bands = Elems(:,1:8);
%     otherwise
%         break
% end
 
if (Q == 9)
    Bands = Elems(:,1:8);
else
    Bands = Elems;
end

hold on

switch bp
    case {1}
        sf = 'Sxx';
    case {2}
        sf = 'Syy';
    case {3}
        sf = 'Txy';
    case {4}
        sf = 'Svm';
    otherwise
        break
end
bandplot(Bands,Coord,S(:,:,bp),[],'k')
axis equal
set(colorbar,'FontSize',8)

plot(xS,yS,'rd','LineWidth',1.5,'MarkerEdgeColor','k',...
                                'MarkerFaceColor','r',...
                                'MarkerSize',8)

text(LD*1.25,-LV*0.900,...
     strcat('Max. rel. stress: "',num2str(Smax),'" MPa'),...
            'FontSize',8,'FontName','Tahoma')
text(LD*1.25,-LV*0.950,...
     strcat('At node: "x=',num2str(xS),'mm" ; "y=',num2str(yS),'mm"'),...
            'FontSize',8,'FontName','Tahoma')

plot(xD,yD,'bd','LineWidth',1.5,'MarkerEdgeColor','k',...
                                'MarkerFaceColor','b',...
                                'MarkerSize',8)

text(LD*1.25,-LV*0.800,...
     strcat('Max. displacement: "',num2str(Dmax),'" mm'),...
            'FontSize',8,'FontName','Tahoma')
text(LD*1.25,-LV*0.850,...
     strcat('At node: "x=',num2str(xD),'mm" ; "y=',num2str(yD),'mm"'),...
            'FontSize',8,'FontName','Tahoma')

title(strcat('Campo de tensiones "',sf,'"'))
saveas(f,'4.fig')
saveas(f,strcat('4_Band_',date,'.fig'))
close(f)