%% ========== Import variables

background = evalin('base','background');
txt_main = evalin('base','txt_main');
txt_by = evalin('base','txt_by');
rct_by = evalin('base','rct_by');

tried = evalin('base','tried');

DATABASE = evalin('base','DATABASE');
num_unit = evalin('base','num_unit');
num_regz = evalin('base','num_regz');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Main sentence

mes_main = strcat('You´ve agreed to pay for unit "',num2str(num_unit),'"');
set(txt_main,'String',mes_main)

%% ========== Instruction

Fee = 20;                  % Price of one period

mes_inst = sprintf(strcat('Please, insert a "$',...
                           num2str(Fee),'" bill',...
                          '\nin the groove below as',...
                          '\nshown in the image on',...
                          '\nthe left...'));

if (exist('txt_inst','var') == 0)
    txt_inst = text(DispX/4,0,mes_inst,...
               'FontName','Verdana','FontSize',12,...
               'HorizontalAlignment','Center');
end
    set(txt_inst,'String',mes_inst,'Position',[DispX/4 0],...
               'FontName','Verdana','FontSize',12,...
               'HorizontalAlignment','Center');
hold on

%% ========== Image   

icon = flipdim(imread('feeicon.jpg'),1);
    rxo = 0.05*DispX - DispX/2;
    ryo = 0.20*DispY - DispY/2;
    rxw = 0.30*DispX;
    ryw = 0.50*DispY;
hold on
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

if (exist('rct_icon','var') == 0)
    rct_icon = image([rxo rxo+1.5*rxw],[ryo ryo+ryw],...
                                  icon,'Parent',axis_main);
end
    set(rct_icon,'CData',icon)

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

if (tried == 0)
    txt_lnow = text(DispX/32,-4*DispY/18,mes_lnow,'FontName','Verdana',...
               'HorizontalAlignment','Left','FontSize',10);
    txt_lexp = text(DispX/32,-6*DispY/18,mes_lexp,'FontName','Verdana',...
               'HorizontalAlignment','Left','FontSize',10);
    txt_dnow = text(DispX/3.5,-4*DispY/18,mes_dnow,'FontName','Verdana',...
               'HorizontalAlignment','Left','FontSize',12);
    txt_dexp = text(DispX/3.5,-6*DispY/18,mes_dexp,'FontName','Verdana',...
               'HorizontalAlignment','Left','FontSize',12);

    assignin('base','txt_lnow',txt_lnow)
    assignin('base','txt_lexp',txt_lexp)
    assignin('base','txt_dnow',txt_dnow)
    assignin('base','txt_dexp',txt_dexp)
end

%% ========== Export GUI variables
    
assignin('base','rct_icon',rct_icon)
assignin('base','txt_inst',txt_inst)

%% ========== Export System variables

assignin('base','date_now',date_now)
assignin('base','date_exp',date_exp)

assignin('base','tried',tried + 1)