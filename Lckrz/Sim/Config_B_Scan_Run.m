%% ========== Import variables

rx1 = evalin('base','rx1');
rx2 = evalin('base','rx2');
rxw = evalin('base','rxw');
ryo = evalin('base','ryo');
ryw = evalin('base','ryw');
DispX = evalin('base','DispX');
DispY = evalin('base','DispY');

fill = evalin('base','fill');

%% ========== Display

axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

axis_main = evalin('base','axis_main');
txt_main = evalin('base','txt_main');
rct_icon1 = evalin('base','rct_icon1');
rct_icon2 = evalin('base','rct_icon2');

fill = evalin('base','fill');

%% ========== Main sentence

mes_main = sprintf(strcat('Wait!',...
                          '\n The guy is now reading...'));

set(txt_main,'String',mes_main)

%% ========== Image

delete(rct_icon2);
delete(fill);

mes_prog = strcat(num2str(0),' %');

txt_prog = text(DispX/4,-DispY/9,mes_prog,...
           'HorizontalAlignment','Center','FontSize',36);

mes_scan = strcat('SCANNING...');

txt_scan = text(DispX/4,DispY/18,mes_scan,...
           'HorizontalAlignment','Center',...
           'FontName','Calibri','FontSize',24);
hold on

%% ========== Scanning data

FP = evalin('base','FP');               % Scanned fingerprint

num_unit = [];                          % No coincident unit detected yet

DATABASE = evalin('base','DATABASE');   % Import Database matrix
num_regs = size(DATABASE,1);            % Quantity of users registered
     
Units = DATABASE(:,1);
Users = DATABASE(:,2);

%% ========== Scanning process

axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

xo = rx1+rxw/2;
yo = ryo+ryw/2;
r = norm([(rx1+rxw/2) (ryo+ryw/2)]/4);
s = 16;
t = (0:1/s:1)*360;

for temp = 1:(num_regs)
    rn = ceil(16*rand);
    xc = xo + r * cos(t(rn)*pi/180);
    yc = yo + r * sin(t(rn)*pi/180);
    x1 = xc+r/8 ; x2 = x1+r/3 ; y1 = yc-r/8 ; y2 = y1-r/3 ;
    
    Loop1 = plot(xc,yc,'ko','MarkerEdgeColor','k',...
                       'MarkerSize',18,'LineWidth',4);
    Loop2 = plot([x1 x2],[y1 y2],'k-','LineWidth',4);
    axis off
    
    num = Users(temp);
    if (num <= 9)
        directory = strcat('FPreg0',num2str(num),'.jpg');
    else
        directory = strcat('FPreg',num2str(num),'.jpg');
    end
    
    RegXX = 255*round(imread(directory)/255);
    if (isequal(FP,RegXX) == 1)
        num_unit = Units(temp);
        num_regz = temp;
    else
        mes_prog = strcat(num2str(round(100*temp/num_regs)),'%');
    end
    pause(0.2)
    set(txt_prog,'String',mes_prog)
    delete(Loop1)
    delete(Loop2)
end

%% ========== Export GUI variables

assignin('base','txt_scan',txt_scan)
assignin('base','txt_prog',txt_prog)

%% ========== Export System variables

assignin('base','num_unit',num_unit)

if (isempty(num_unit) == 0)
    assignin('base','num_regz',num_regz)
end