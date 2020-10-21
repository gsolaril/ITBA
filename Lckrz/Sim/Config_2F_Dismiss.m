%% ========== Import GUI variables

background = evalin('base','background');
txt_main = evalin('base','txt_main');

txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');

num_unit = evalin('base','num_unit');
num_regz = evalin('base','num_regz');

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
                  '" could not be opened');
set(txt_main,'String',mes_main,'FontName','Tahoma','FontSize',16)

%% ========== Instruction

mes_inst1 = strcat('\color{red}Our database implies that your locker ');
mes_inst2 = strcat('\color{red}service has expired. Please, pay your');
mes_inst3 = strcat('\color{red}debt as soon as possible so that your');
mes_inst4 = strcat('\color{red}situation becomes regularized');

txt_inst1 = text(0,DispY/9,mes_inst1,'Position',[0 +DispY/9],...
                'HorizontalAlignment','Center',...
                'FontName','Tahoma','FontSize',14);
txt_inst2 = text(0,DispY/9,mes_inst2,'Position',[0 0],...
                'HorizontalAlignment','Center',...
                'FontName','Tahoma','FontSize',14);
txt_inst3 = text(0,DispY/9,mes_inst3,'Position',[0 -DispY/9],...
                'HorizontalAlignment','Center',...
                'FontName','Tahoma','FontSize',14);
txt_inst4 = text(0,DispY/9,mes_inst4,'Position',[0 -2*DispY/9],...
                'HorizontalAlignment','Center',...
                'FontName','Comic Sans MS','FontSize',14);

%% ========== Reset display

pause(5)

delete(background)
delete(txt_main)
delete(txt_inst1)
delete(txt_inst2)
delete(txt_inst3)
delete(txt_inst4)