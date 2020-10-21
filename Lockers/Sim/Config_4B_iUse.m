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

rct_imag = evalin('base','rct_imag');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Main sentence

mes_main = sprintf(strcat('Payment Info'));

set(txt_main,'String',mes_main)

%% ========== Commands

delete(txt_bb)
delete(rct_bb)
delete(txt_br)
delete(rct_br)
delete(txt_bg)
delete(rct_bg)
mes_by = sprintf(strcat('Back to Menu'));
set(txt_by,'String',mes_by)

%% ========== Credits

imag = flipdim(imread('infouse.jpg'),1);
set(rct_imag,'CData',imag);

%% ========== Export GUI variables

assignin('base','rct_imag',rct_imag)