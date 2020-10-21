%% ========== Import GUI variables

background = evalin('base','background');
txt_main = evalin('base','txt_main');
txt_br = evalin('base','txt_br');
rct_br = evalin('base','rct_br');
txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');

num_unit = evalin('base','num_unit');
num_regz = evalin('base','num_regz');

delete(txt_br)
delete(rct_br)
delete(txt_by)
delete(rct_by)

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Main sentence

mes_main = strcat('Locker "',num2str(num_unit),...
                  '" has now been freed');
set(txt_main,'String',mes_main,'FontName','Tahoma','FontSize',16)

%% ========== Instruction

mes_inst1 = strcat('We´ve opened the door for a last time');
mes_inst2 = strcat('for you to remove all your belongings');
mes_inst3 = strcat('Try not to forget any stuff...');
mes_inst4 = strcat('\color{green}SEE YOU SOON!!');

txt_inst1 = text(0,DispY/9,mes_inst1,'Position',[0 +DispY/9],...
                'HorizontalAlignment','Center',...
                'FontName','Tahoma','FontSize',14);
txt_inst2 = text(0,DispY/9,mes_inst2,'Position',[0 0],...
                'HorizontalAlignment','Center',...
                'FontName','Tahoma','FontSize',14);
txt_inst3 = text(0,DispY/9,mes_inst3,'Position',[0 -DispY/9],...
                'HorizontalAlignment','Center',...
                'FontName','Tahoma','FontSize',14);
txt_inst4 = text(0,DispY/9,mes_inst4,'Position',[0 -3*DispY/9],...
                'HorizontalAlignment','Center',...
                'FontName','Comic Sans MS','FontSize',20);

%% ========== Elimination process

DATABASE = evalin('base','DATABASE');

DATABASE(num_regz,:) = [ ];

%% ========== Export System variables

% xlswrite('DATABASE.xls',DATABASE);
assignin('base','DATABASE',DATABASE)

%% ========== Reset display

pause(5)

delete(background)
delete(txt_main)
delete(txt_inst1)
delete(txt_inst2)
delete(txt_inst3)
delete(txt_inst4)