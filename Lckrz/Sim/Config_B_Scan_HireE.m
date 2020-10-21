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

mes_prog = strcat('\color{red}ERROR!');

set(txt_prog,'String',mes_prog,'FontName','Comic Sans MS')

mes_user = sprintf(strcat('User already in system!!',...
                          '\n(you are not allowed to hire more',...
                          '\nthan one locker at the same time)'));
              
txt_user = text(DispX/4,-DispY/3,mes_user,...
           'HorizontalAlignment','Center','FontSize',10);


%% ========== Modify fingerprint icon

icon1 = flipdim(imread('fpicon1N.jpg'),1);
set(rct_icon1,'CData',icon1);

pause(3)

delete(rct_icon1)
delete(txt_scan)
delete(txt_prog)
delete(txt_user)