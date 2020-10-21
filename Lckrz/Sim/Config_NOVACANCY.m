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

axis_main = evalin('base','axis_main');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Main sentence

delete(txt_main)

%% ========== Commands

delete(txt_bb); delete(txt_br); delete(txt_bg);
delete(rct_bb); delete(rct_br); delete(rct_bg);

mes_by = sprintf(strcat('Back to Menu'));

set(txt_by,'String',mes_by)

%% ========== "No Vacancy" warning

mes_warn = sprintf(strcat('It seems that all of our lockers',...
                          '\nlockers are now occupied!!',...
                          '\nWhy don´t you try again later?'));

txt_warn = text(0,(0.2)*DispY,strcat('\color{white}',mes_warn),...
           'HorizontalAlignment','Center',...
           'FontName','Tahoma','FontSize',24);
       
pause(1.5)

delete(txt_warn)