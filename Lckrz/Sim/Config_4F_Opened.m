%% ========== Import variables

background = evalin('base','background');
txt_main = evalin('base','txt_main');
txt_inst = evalin('base','txt_inst');
txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');
txt_lnow = evalin('base','txt_lnow');
txt_lexp = evalin('base','txt_lexp');
txt_dnow = evalin('base','txt_dnow');
txt_dexp = evalin('base','txt_dexp');

num_unit = evalin('base','num_unit');
num_regz = evalin('base','num_regz');

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
                  '" has now been regularized');
set(txt_main,'String',mes_main,'FontName','Tahoma','FontSize',16)

%% ========== Instruction

mes_inst = sprintf('Remember to pay next fee\nbefore your locker expires!');

set(txt_inst,'String',mes_inst,'Position',[0 DispY/9],...
             'HorizontalAlignment','Center','FontName','Tahoma');

%% ========== Expiration date

set(txt_lnow,'Position',[-0.45*DispX -0.25*DispY],...
             'HorizontalAlignment','Left','FontSize',20);
set(txt_lexp,'Position',[-0.45*DispX -0.40*DispY],...
             'HorizontalAlignment','Left','FontSize',20);
set(txt_dnow,'Position',[+0.45*DispX -0.25*DispY],...
             'HorizontalAlignment','Right','FontSize',20);
set(txt_dexp,'Position',[+0.45*DispX -0.40*DispY],...
             'HorizontalAlignment','Right','FontSize',20);

%% ========== Submission process

DATABASE = evalin('base','DATABASE');

date_exp = datenum(DATABASE(num_regz,3:5)) + 31;
date_exp = datevec(date_exp);

DATABASE(num_regz,3) = date_exp(1); % Expiration year
DATABASE(num_regz,4) = date_exp(2); % Expiration month
DATABASE(num_regz,5) = date_exp(3); % Expiration day
DATABASE(num_regz,6) = 0;           % User up to date

%% ========== Export System variables

% xlswrite('DATABASE.xls',DATABASE);
assignin('base','DATABASE',DATABASE)

%% ========== Reset display

pause(5)

delete(background)
delete(txt_main)
delete(txt_inst)
delete(txt_lnow)
delete(txt_lexp)
delete(txt_dnow)
delete(txt_dexp)