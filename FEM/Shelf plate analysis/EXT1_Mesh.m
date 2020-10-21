Elems = evalin('base','Elems');
Coord = evalin('base','Coord');
nele  = evalin('base','nele');

%% -------------------------- Modelización -------------------------- %%

plot3(Coord(:,1),Coord(:,2),Coord(:,3),'bo','MarkerEdgeColor','k',...
                                            'MarkerFaceColor','b',...
                                            'MarkerSize',3)
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