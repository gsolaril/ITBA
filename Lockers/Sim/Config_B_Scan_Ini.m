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

mes_main = sprintf(strcat('Now, place your thumb in',...
                          '\n the fingerprint sensor...'));

set(txt_main,'String',mes_main)

%% ========== Commands

delete(txt_bb); delete(txt_br); delete(txt_bg);
delete(rct_bb); delete(rct_br); delete(rct_bg);

mes_by = sprintf(strcat('Back to Menu'));

set(txt_by,'String',mes_by)

%% ========== Image
     
icon1 = flipdim(imread('fpicon1.jpg'),1);
icon2 = flipdim(imread('fpicon2.jpg'),1);
    rx1 = 0.05*DispX - DispX/2;
    rx2 = 0.75*DispX - DispX/2;
    ryo = 0.20*DispY - DispY/2;
    rxw = 0.30*DispX;
    ryw = 0.50*DispY;

hold on
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off
rct_icon1 = image([rx1 rx1+rxw/1],[ryo ryo+ryw],icon1,'Parent',axis_main);
rct_icon2 = image([rx2 rx2+rxw/2],[ryo ryo+ryw],icon2,'Parent',axis_main);

%% ========== Export GUI variables

assignin('base','background',background)
assignin('base','txt_main',txt_main)
assignin('base','rct_icon1',rct_icon1)
assignin('base','rct_icon2',rct_icon2)

%% ========== Export System variables

assignin('base','icon1',icon1)
assignin('base','icon2',icon2)
assignin('base','rx1',rx1)
assignin('base','rx2',rx2)
assignin('base','ryo',ryo)
assignin('base','rxw',rxw)
assignin('base','ryw',ryw)

%% ========== Arrows

coef   = [ 4  5  6  7  8  9  10 11 12]/4;
ArrowN = [ 0  0 -2 -2 -3 -2 -2  0  0
           0  1  1  2  0 -2 -1 -1  0 ]';
ArrowX = ArrowN(:,1)*DispX/16 + DispX/4;
ArrowY = ArrowN(:,2)*DispY/20;
fill = fill(ArrowX,ArrowY,'r');
assignin('base','fill',fill)
anim = 1;
while anim < 10
    ArrowX = coef(anim)*ArrowN(:,1)*DispX/16 + DispX/4;
    set(fill,'Vertices',[ArrowX ArrowY])
    assignin('base','fill',fill)
    pause(0.06)
    anim = anim + 1;
    if anim == 10
        anim = 1;
    end
end