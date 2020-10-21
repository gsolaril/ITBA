%% ========== Import GUI variables

background = evalin('base','background');
txt_main   = evalin('base','txt_main');

%% ========== Display

DispX = evalin('base','DispX');
DispY = evalin('base','DispY');
pos = evalin('base','pos');
axis_main = evalin('base','axis_main');
axis([-DispX/2 +DispX/2 -DispY/2 +DispY/2])
axis off

%% ========== Assembly program

DATABASE = evalin('base','DATABASE');   % Import Database matrix
num_regs = size(DATABASE,1);            % Quantity of users registered
Units = DATABASE(:,1);

N = evalin('base','N');                 % Number of columns of 4 lockers

Matrix = zeros(4,N);

for unit = 1:(num_regs)
    num = Units(unit);
    nj  = ceil(num/4);
    ni  = rem(num-1,4) + 1;
    Matrix(ni,nj) = 1;
end

%% ========== Main sentence

mes_main = sprintf(strcat('Please, choose your locker',...
                          '\n(red ones are occupied)'));

set(txt_main,'String',mes_main)

%% ========== Instruction

mes_inst = strcat('Number...');

txt_inst = text(DispX/4,DispY/9,mes_inst,...
           'HorizontalAlignment','Center',...
           'FontName','Calibri','FontSize',24);
hold on

[I J] = size(Matrix);
Lx = DispX/2.5;
Ly = DispY/2;

for j = 0:J-1
for i = 0:I-1
    lx = Lx/J;
    ly = Ly/I;
    x = + j*lx - Lx/1 ;
    y = - i*ly + Ly/3 - ly;
    if Matrix(i+1,j+1) == 0
       color = 'g';
    else
       color = 'r';
    end
    RCT(i+1,j+1) = rectangle('Position',[x y lx ly],...
                             'FaceColor',strcat(color));
    TXT(i+1,j+1) = text(x+0.5*lx,y+0.5*ly,...
                   strcat('\bf',num2str(4*j+i+1)),...
                   'HorizontalAlignment','Center',...
                   'FontSize',lx,'FontName','Calibri');
    CRC(i+1,j+1) = plot(x+0.9*lx,y+0.5*ly,'wO','MarkerFaceColor','w',...
                                               'MarkerEdgeColor','k',...
                                               'MarkerSize',0.3*lx);
end
end

%% ========== Number type

rct_type = rectangle('Position',[DispX/8,-DispY/8,DispX/4,DispY/8],...
                     'FaceColor','b');

mes_type = strcat('-');

txt_type = text(DispX/4,-DispY/16,mes_type,...
           'HorizontalAlignment','Center','FontSize',24);

%% ========== Export GUI variables

assignin('base','txt_inst',txt_inst)
assignin('base','rct_type',rct_type)
assignin('base','txt_type',txt_type)
assignin('base','RCT',RCT)
assignin('base','TXT',TXT)
assignin('base','CRC',CRC)

%% ========== Export System variables

assignin('base','Matrix',Matrix)
assignin('base','num_type',[ ])