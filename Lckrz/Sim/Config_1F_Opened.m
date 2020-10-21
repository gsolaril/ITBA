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

FPname = evalin('base','FPname');
num_unit = evalin('base','num_type');

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

mes_main = strcat('Locker "',num2str(num_type),...
                  '" has now been opened for you');
set(txt_main,'String',mes_main,'FontName','Tahoma','FontSize',16)

%% ========== Instruction

mes_inst = sprintf('Remember to always shut the\n door after using it!');

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
address = str2double(FPname(6:7));

date_exp = datevec(now+31);

DATABASE(end+1,1) = num_type;    % Locker now occupied
DATABASE(end+0,2) = address;     % User fingerprint address
DATABASE(end+0,3) = date_exp(1); % Expiration year
DATABASE(end+0,4) = date_exp(2); % Expiration month
DATABASE(end+0,5) = date_exp(3); % Expiration day
DATABASE(end+0,6) = 0;           % User up to date

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