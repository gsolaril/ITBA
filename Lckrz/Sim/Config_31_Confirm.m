%% ========== Import GUI variables

background = evalin('base','background');
txt_main = evalin('base','txt_main');
txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');

num_unit = evalin('base','num_unit');
num_regz = evalin('base','num_regz');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Main sentence

mes_main = sprintf(strcat('Are you sure you want to',...
                          '\nstop using locker "',num2str(num_unit),'"?'));

set(txt_main,'String',mes_main)

%% ========== Commands

delete(txt_by)
delete(rct_by)

mes_br = sprintf(strcat('Yes'));
mes_by = sprintf(strcat(' No'));

xc = (0.40)*DispX;
yr = (0.45)*DispY;

rx = DispX/12;
ry = DispY/12;

xd = DispX/2;
yd = ry/2;

txt_br = text(-xc,-yr,mes_br,'HorizontalAlignment','Left',...
                             'FontName','Calibri','FontSize',16);
rct_br = rectangle('Position',[-xd,-yd-yr,rx,ry],...
                   'FaceColor','r','Curvature',0.2);
txt_by = text(+xc,-yr,mes_by,'HorizontalAlignment','Right',...
                             'FontName','Calibri','FontSize',16);
rct_by = rectangle('Position',[xd-rx,-yd-yr,rx,ry],...
                   'FaceColor','y','Curvature',0.2);

%% ========== Export GUI variables

assignin('base','txt_br',txt_main)
assignin('base','txt_br',txt_br)
assignin('base','rct_br',rct_br)
assignin('base','txt_by',txt_by)
assignin('base','rct_by',rct_by)