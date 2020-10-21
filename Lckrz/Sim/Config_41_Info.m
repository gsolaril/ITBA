%% ========== Import variables

background = evalin('base','background');
txt_main = evalin('base','txt_main');
txt_bb = evalin('base','txt_bb');
rct_bb = evalin('base','rct_bb');
txt_br = evalin('base','txt_br');
rct_br = evalin('base','rct_br');
txt_bg = evalin('base','txt_bg');
rct_bg = evalin('base','rct_bg');
txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Main sentence

mes_main = sprintf(strcat(' '));

set(txt_main,'String',mes_main)

%% ========== Commands

delete(txt_bb); delete(txt_br); delete(txt_bg); delete(txt_by);
delete(rct_bb); delete(rct_br); delete(rct_bg); delete(rct_by);

mes_bb = sprintf(strcat('Payment Info'));
mes_br = sprintf(strcat('User´s Guide'));
mes_bg = sprintf(strcat('Pay Service '));
mes_by = sprintf(strcat('Back to Menu'));

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

%% ========== Credits

imag = flipdim(imread('credits.jpg'),1);
    rxo = 0.05*DispX - DispX/2;
    ryo = 0.25*DispY - DispY/2;
    rxw = 0.90*DispX;
    ryw = 0.70*DispY;
hold on
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off
rct_imag = image([rxo rxo+rxw],[ryo ryo+ryw],imag,'Parent',axis_main);

%% ========== Export GUI variables

assignin('base','txt_bb',txt_bb)
assignin('base','rct_bb',rct_bb)
assignin('base','txt_br',txt_br)
assignin('base','rct_br',rct_br)
assignin('base','txt_bg',txt_bg)
assignin('base','rct_bg',rct_bg)
assignin('base','txt_by',txt_by)
assignin('base','rct_by',rct_by)

assignin('base','rxo',rxo)
assignin('base','ryo',ryo)
assignin('base','rxw',rxw)
assignin('base','ryw',ryw)
assignin('base','rct_imag',rct_imag)