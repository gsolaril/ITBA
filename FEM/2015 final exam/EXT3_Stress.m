assignin('base','W','W')
assignin('base','Z','Z')
assignin('base','bp',bp)

LH = evalin('base','LH');
LV = evalin('base','LV');
LR = evalin('base','LR');
LD = evalin('base','LD');
t  = evalin('base','t');

Q   = evalin('base','Q');
sub = evalin('base','sub');

STR = evalin('base','STR');
SVM = evalin('base','SVM');

Disp = evalin('base','Disp');
Dnrm = evalin('base','Dnrm');

 %% ------------------------------------------------------------------ %%

S(:,:,1:3) = STR*(W*t*(LH-LD-LR)/10e2);
S(:,:,4)   = SVM*(W*t*(LH-LD-LR)/10e2)*sign(W);

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

bandplot(Bands,Coord,S(:,:,bp),[],'k')
axis equal
set(colorbar,'FontSize',8)

Smax = max(max(abs(S(:,:,bp))));

[rS cS] = find(abs(S(:,:,bp))==Smax);

Smax = S(rS,cS,bp);

nS = Elems(rS,cS);
xS = Coord(nS,1);
yS = Coord(nS,2);

plot(xS,yS,'rd','LineWidth',1.5,'MarkerEdgeColor','k',...
                                'MarkerFaceColor','r',...
                                'MarkerSize',8)

text(LD*1.25,-LV*0.900,...
     strcat('Max. rel. stress: "',num2str(Smax),'" MPa'),...
            'FontSize',8,'FontName','Tahoma')
text(LD*1.25,-LV*0.950,...
     strcat('At node: "x=',num2str(xS),'mm" ; "y=',num2str(yS),'mm"'),...
            'FontSize',8,'FontName','Tahoma')

Dmax = max(Dnrm);

nD = find(Dnrm==Dmax);
xD = Coord(nD,1);
yD = Coord(nD,2);

plot(xD,yD,'bd','LineWidth',1.5,'MarkerEdgeColor','k',...
                                'MarkerFaceColor','b',...
                                'MarkerSize',8)

text(LD*1.25,-LV*0.800,...
     strcat('Max. displacement: "',num2str(Dmax),'" mm'),...
            'FontSize',8,'FontName','Tahoma')
text(LD*1.25,-LV*0.850,...
     strcat('At node: "x=',num2str(xD),'mm" ; "y=',num2str(yD),'mm"'),...
            'FontSize',8,'FontName','Tahoma')

 %% ------------------------------------------------------------------ %%

assignin('base','S',S)
assignin('base','Smax',Smax)
assignin('base','xS',xS)
assignin('base','yS',yS)
assignin('base','Dmax',Dmax)
assignin('base','xD',xD)
assignin('base','yD',yD)