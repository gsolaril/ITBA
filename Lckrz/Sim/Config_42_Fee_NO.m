%% ========== Import variables

background = evalin('base','background');
rct_icon = evalin('base','rct_icon');
txt_main = evalin('base','txt_main');
txt_inst = evalin('base','txt_inst');
txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');

num_type = evalin('base','num_type');

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

mes_inst = strcat('\color{red}ERROR! Try again');

set(txt_inst,'String',mes_inst,...
             'FontName','Comic Sans MS','FontSize',18)

%% ========== Image
     
icon = flipdim(imread('feeiconN.jpg'),1);

set(rct_icon,'CData',icon)
assignin('base','rct_icon',rct_icon)

pause(2)