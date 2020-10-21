%% ========== Import GUI variables

txt_inst = evalin('base','txt_inst');
rct_type = evalin('base','rct_type');
txt_type = evalin('base','txt_type');
RCT = evalin('base','RCT');
TXT = evalin('base','TXT');
CRC = evalin('base','CRC');

%% ========== Import system variables

N = evalin('base','N');
DATABASE = evalin('base','DATABASE');
num_type = evalin('base','num_type');
Units = DATABASE(:,1);

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Compare

Free = 1; % Locker "num_type" initially free

for comp = 1:length(Units)
    unit = Units(comp);
    if (num_type == unit)
        Free = 0;
        break
    end
end

if (num_type > 4*N)
    mes_num1 = strcat('\color{red}ERROR!');
    mes_num2 = strcat('(Must be smaller than "',num2str(4*N),'")');

    txt_num1 = text(DispX/4,-0.2*DispY,mes_num1,'HorizontalAlignment',...
                       'Center','FontName','Comic Sans MS','FontSize',24);
    txt_num2 = text(DispX/4,-1*DispY/3,mes_num2,...
                       'HorizontalAlignment','Center','FontSize',12);
    pause(2)
    delete(txt_num1)
    delete(txt_num2)
    num_type = [ ];
    mes_type = strcat('-');
    set(txt_type,'String',mes_type)
    
elseif (Free == 0)
    mes_num1 = strcat('\color{red}ERROR!');
    mes_num2 = strcat('(Locker "',num2str(num_type),'" already occupied)');

    txt_num1 = text(DispX/4,-0.2*DispY,mes_num1,'HorizontalAlignment',...
                       'Center','FontName','Comic Sans MS','FontSize',24);
    txt_num2 = text(DispX/4,-1*DispY/3,mes_num2,...
                       'HorizontalAlignment','Center','FontSize',12);
    pause(2)
    delete(txt_num1)
    delete(txt_num2)
    num_type = [ ];
    mes_type = strcat('-');
    set(txt_type,'String',mes_type)
    
else
    mes_num1 = strcat('\color{green}OK!');
    
    txt_num1 = text(DispX/4,-0.2*DispY,mes_num1,'HorizontalAlignment',...
                       'Center','FontName','Comic Sans MS','FontSize',24);
    pause(2)
    delete(txt_num1)
    delete(RCT)
    delete(TXT)
    delete(CRC)
    delete(rct_type)
    delete(txt_type)
end

%% ========== Export System variables

assignin('base','Free',Free)
assignin('base','num_type',num_type)