%% ========== Import variables

background = evalin('base','background');
rct_icon = evalin('base','rct_icon');
txt_main = evalin('base','txt_main');
txt_inst = evalin('base','txt_inst');
txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Instruction

mes_inst = strcat('SCANNING...');

set(txt_inst,'String',mes_inst,'FontSize',24)

pause(2)

mes_inst = strcat('\color{green}Payment OK!');

set(txt_inst,'String',mes_inst,...
             'FontName','Comic Sans MS','FontSize',24)

%% ========== Image
     
icon = flipdim(imread('feeiconY.jpg'),1);

set(rct_icon,'CData',icon)

pause(2)

delete(rct_icon)