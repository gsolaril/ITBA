clear all
clc

 %% ======================== DATOS RELEVANTES ======================== %%

Lx = 420   ;   Ly = 400   ;   ex = 10    ;   ey = 10   ;   t = 1   ;

E = 200000 ;   m = 0.3    ;   W = 1      ;   Z = 0     ;

s_f = 0    ;   s_b = 0    ;   s_l = 1    ;   s_r = 2   ;

assignin('base','E',E);      % Módulo de elasticidad
assignin('base','m',m);      % Módulo de Poisson
assignin('base','t',t);      % Espesor de placa

assignin('base','Lx',Lx);    % Profundidad de locker
assignin('base','Ly',Ly);    % Ancho de locker

assignin('base','ex',ex);    % Número de elementos en "x": a lo profundo
assignin('base','ey',ey);    % Número de elementos en "y": a lo ancho

assignin('base','s_f',s_f);  % Condiciones del borde frontal    ...x = Lx
assignin('base','s_b',s_b);  % Condiciones del borde trasero    ...x = 0
assignin('base','s_l',s_l);  % Condiciones del borde derecho    ...y = 0
assignin('base','s_r',s_r);  % Condiciones del borde izquierdo  ...y = Ly

 %% ========================== MODELIZACIÓN ========================== %%



