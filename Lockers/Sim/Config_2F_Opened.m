%% ========== Import variables

background = evalin('base','background');
txt_main = evalin('base','txt_main');
txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');

DATABASE = evalin('base','DATABASE');
num_unit = evalin('base','num_unit');
num_regz = evalin('base','num_regz');
FPname   = evalin('base','FPname');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

delete(txt_by)
delete(rct_by)

%% ========== Main sentence

mes_main = strcat('Locker "',num2str(num_unit),...
                  '" has now been opened for you');
set(txt_main,'String',mes_main,'FontName','Tahoma','FontSize',16)

%% ========== Instruction

mes_inst = sprintf('Remember to always shut the\n door after using it!');

txt_inst = text(0,DispY/9,mes_inst,...
           'HorizontalAlignment','Center',...
           'FontName','Calibri','FontSize',24);

%% ========== Expiration date

date_now = datevec(now);
date_now = date_now(1:3);
date_exp = DATABASE(num_regz,3:5);

mes_lnow = strcat('\color{green}Present date:');
mes_dnow = strcat('\color{green}\bf',num2str(date_now(3)),'/',...
                                     num2str(date_now(2)),'/',...
                                     num2str(date_now(1)));
                            
mes_lexp = strcat('\color{red}Expiration date:');
mes_dexp = strcat('\color{red}\bf',num2str(date_exp(3)),'/',...
                                   num2str(date_exp(2)),'/',...
                                   num2str(date_exp(1)));

txt_lnow = text(-0.45*DispX,-0.25*DispY,mes_lnow,'FontName','Verdana',...
               'HorizontalAlignment','Left','FontSize',20);
txt_lexp = text(-0.45*DispX,-0.40*DispY,mes_lexp,'FontName','Verdana',...
               'HorizontalAlignment','Left','FontSize',20);
txt_dnow = text(+0.45*DispX,-0.25*DispY,mes_dnow,'FontName','Verdana',...
               'HorizontalAlignment','Right','FontSize',20);
txt_dexp = text(+0.45*DispX,-0.40*DispY,mes_dexp,'FontName','Verdana',...
               'HorizontalAlignment','Right','FontSize',20);

%% ========== Reset display

pause(5)

delete(background)
delete(txt_main)
delete(txt_inst)
delete(txt_lnow)
delete(txt_lexp)
delete(txt_dnow)
delete(txt_dexp)