clc

%% ========== Display

DispX = 160;
DispY = 90;

%% ========== Background

axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off
background = rectangle('Position',[-DispX/2,-DispY/2,DispX,DispY],...
                       'FaceColor',[0.65 0.65 1.00],'Curvature',0.02);

set(gca,'Units','normalized')
pos = get(gca,'Position');

%% ========== Main sentence

mes_main = sprintf(strcat('Welcome!!\nPlease, select your option'));

txt_main = text(0,(0.35)*DispY,strcat('\color{white}',mes_main),...
           'HorizontalAlignment','Center',...
           'FontName','Calibri','FontSize',24);

%% ========== Commands

mes_bb = sprintf(strcat('Hire Locker'));
mes_br = sprintf(strcat('Open Locker'));
mes_bg = sprintf(strcat('Free Locker'));
mes_by = sprintf(strcat(' Pay & Info'));

xc = (0.40)*DispX;
yb = (0.35)*DispY;
yr = (0.45)*DispY;

rx = DispX/12;
ry = DispY/12;

xd = DispX/2;
yd = ry/2;

txt_bb = text(-xc,-yb,mes_bb,'HorizontalAlignment','Left',...
                             'FontName','Calibri','FontSize',16);
rct_bb = rectangle('Position',[-xd,-yd-yb,rx,ry],...
                   'FaceColor','b','Curvature',0.2);
txt_br = text(-xc,-yr,mes_br,'HorizontalAlignment','Left',...
                             'FontName','Calibri','FontSize',16);
rct_br = rectangle('Position',[-xd,-yd-yr,rx,ry],...
                   'FaceColor','r','Curvature',0.2);
txt_bg = text(+xc,-yb,mes_bg,'HorizontalAlignment','Right',...
                             'FontName','Calibri','FontSize',16);
rct_bg = rectangle('Position',[xd-rx,-yd-yb,rx,ry],...
                   'FaceColor','g','Curvature',0.2);
txt_by = text(+xc,-yr,mes_by,'HorizontalAlignment','Right',...
                             'FontName','Calibri','FontSize',16);
rct_by = rectangle('Position',[xd-rx,-yd-yr,rx,ry],...
                   'FaceColor','y','Curvature',0.2);

%% ========== Export GUI variables

assignin('base','background',background)
assignin('base','txt_main',txt_main)
assignin('base','txt_bb',txt_bb)
assignin('base','rct_bb',rct_bb)
assignin('base','txt_br',txt_br)
assignin('base','rct_br',rct_br)
assignin('base','txt_bg',txt_bg)
assignin('base','rct_bg',rct_bg)
assignin('base','txt_by',txt_by)
assignin('base','rct_by',rct_by)

axis_main = gca;
assignin('base','axis_main',axis_main)

%% ========== Export System variables

assignin('base','DispX',DispX)
assignin('base','DispY',DispY)
assignin('base','pos',pos)