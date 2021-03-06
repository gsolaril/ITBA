%% ========== Import GUI variables

rct_icon1 = evalin('base','rct_icon1');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');

axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

axis_main = evalin('base','axis_main');
txt_scan = evalin('base','txt_scan');
txt_prog = evalin('base','txt_prog');

%% ========== Modify state message

num_unit = evalin('base','num_unit');

mes_prog = strcat('\color{green}Locker "',num2str(num_unit),'"!');

set(txt_prog,'String',mes_prog,'FontName','Comic Sans MS','FontSize',24)

%% ========== Modify fingerprint icon

icon1 = flipdim(imread('fpicon1Y.jpg'),1);
set(rct_icon1,'CData',icon1);

pause(1)

assignin('base','num_unit',num_unit)

delete(rct_icon1)
delete(txt_scan)
delete(txt_prog)