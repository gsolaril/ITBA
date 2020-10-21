Q     = evalin('base','Q');
LH    = evalin('base','LH');
LV    = evalin('base','LV');
nele  = evalin('base','nele');
Coord = evalin('base','Coord');
Elems = evalin('base','Elems');

%% -------------------------- Modelización -------------------------- %%

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