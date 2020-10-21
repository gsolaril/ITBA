function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 08-Jul-2015 00:55:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)
% Choose default command line output for GUI
handles.output = hObject;
% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Update handles structure
guidata(hObject, handles);
initialize_gui(hObject, handles, false);

function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function initialize_gui(fig_handle, handles, isreset)

    set(handles.LHwrite,'String',300)
    set(handles.LVwrite,'String',300)
    set(handles.LRwrite,'String',50)
    set(handles.LDwrite,'String',100)
    set(handles.Q4,'Value',1)
    set(handles.PTnwrite,'String',1)
    set(handles.Ewrite,'String',200000)
    set(handles.mwrite,'String',1/3)
    set(handles.twrite,'String',10)
    set(handles.Wwrite,'String',-1000)
    set(handles.Zwrite,'Value',0)
    format short g

% ========================================================== %
% ========== Parametros de entrada para geometría ========== %
% ========================================================== %

function LHwrite_Callback(hObject, eventdata, handles)
% hObject    handle to LHwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function LHwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LHwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LVwrite_Callback(hObject, eventdata, handles)
% hObject    handle to LVwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function LVwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LVwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRwrite_Callback(hObject, eventdata, handles)
% hObject    handle to LRwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function LRwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LDwrite_Callback(hObject, eventdata, handles)
% hObject    handle to LDwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes during object creation, after setting all properties.
function LDwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LDwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function REwrite_Callback(hObject, eventdata, handles)
% hObject    handle to REwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function REwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to REwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Ewrite_Callback(hObject, eventdata, handles)
% hObject    handle to Ewrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function Ewrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ewrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mwrite_Callback(hObject, eventdata, handles)
% hObject    handle to mwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function mwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function twrite_Callback(hObject, eventdata, handles)
% hObject    handle to twrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function twrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to twrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ========================================================== %
% =========== Parametros de entrada para mallado =========== %
% ========================================================== %

function NEMwrite_Callback(hObject, eventdata, handles)
% hObject    handle to NEMwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns NEMwrite contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NEMwrite
function NEMwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NEMwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function NELwrite_Callback(hObject, eventdata, handles)
% hObject    handle to NELwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function NELwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NELwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function NEHwrite_Callback(hObject, eventdata, handles)
% hObject    handle to NEHwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function NEHwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NEHwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function NERwrite_Callback(hObject, eventdata, handles)
% hObject    handle to NERwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function NERwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NERwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Q4_Callback(hObject, eventdata, handles)
% hObject    handle to Q4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Q4
Q4 = get(hObject,'Value');
if Q4==1
   set(handles.Q8,'Value',0)
   set(handles.Q9,'Value',0)
end
function Q8_Callback(hObject, eventdata, handles)
% hObject    handle to Q8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Q8
Q8 = get(hObject,'Value');
if Q8==1
   set(handles.Q4,'Value',0)
   set(handles.Q9,'Value',0)
end
function Q9_Callback(hObject, eventdata, handles)
% hObject    handle to Q9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Q9
Q9 = get(hObject,'Value');
if Q9==1
   set(handles.Q4,'Value',0)
   set(handles.Q8,'Value',0)
end
function Sub_Callback(hObject, eventdata, handles)
% hObject    handle to Sub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sub = get(hObject,'Value');

function OK_Mod_Callback(hObject, eventdata, handles)
% hObject    handle to OK_Mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    LH  = str2double(get(handles.LHwrite,'String'));
    LV  = str2double(get(handles.LVwrite,'String'));
    LR  = str2double(get(handles.LRwrite,'String'));
    LD  = str2double(get(handles.LDwrite,'String'));
    inc =        10^(get(handles.REwrite,'Value' ));
    
    er = 1+get(handles.NERwrite,'Value');
    eh = 1+get(handles.NEHwrite,'Value');
    el = 1+get(handles.NELwrite,'Value');
    em = 2*get(handles.NEMwrite,'Value');
    
    Q4 = get(handles.Q4,'Value');
    Q8 = get(handles.Q8,'Value');
    Q9 = get(handles.Q9,'Value');
    
    sub = get(handles.Sub,'Value');
    
    E = str2double(get(handles.Ewrite,'String'));
    m = str2double(get(handles.mwrite,'String'));
    t = str2double(get(handles.twrite,'String'));
    
    if     (Q4==1)&&(Q8==0)&&(Q9==0)
            Q = 4;
    elseif (Q4==0)&&(Q8==1)&&(Q9==0)
            Q = 8;
    elseif (Q4==0)&&(Q8==0)&&(Q9==1)
            Q = 9;
    end
    
    run Qdata.m
    
    tic
    run EXE.m
    set(handles.NEread,'String',strcat(num2str(nele)))

    axes(handles.Plot_Mod)
    cla
    run EXT1_Mesh.m
    
    time = ceil(10*toc)/10;
    set(handles.Hmaxread,'String',strcat(num2str(hmax)))
    set(handles.Hminread,'String',strcat(num2str(hmin)))
    set(handles.Dmaxread,'String',strcat(num2str(dmax)))
    set(handles.Dminread,'String',strcat(num2str(dmin)))
    set(handles.Jread,'String',strcat(num2str(jbase)))
    set(handles.Jexp,'String',strcat(num2str(jexp)))
    set(handles.timer,'String',strcat(num2str(time)))
    
% ========================================================= %
% ========= Parametros de entrada para Patch Test ========= %
% ========================================================= %

function PTnwrite_Callback(hObject, eventdata, handles)
% hObject    handle to PTnwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function PTnwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PTnwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PTtwrite_Callback(hObject, eventdata, handles)
% hObject    handle to PTtwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function PTtwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PTtwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OK_PT_Callback(hObject, eventdata, handles)
% hObject    handle to OK_PT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    ne = str2double(get(handles.PTnwrite,'String'));
    pt = get(handles.PTtwrite,'Value');

    axes(handles.Plot_PT)
    cla
    run EXE_Patch.m

% ========================================================== %
% ========= Parametros de entrada para Disp/Stress ========= %
% ========================================================== %

function Wwrite_Callback(hObject, eventdata, handles)
% hObject    handle to Wwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function Wwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Wwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Zwrite_Callback(hObject, eventdata, handles)
% hObject    handle to Wwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function Zwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Wwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function BPwrite_Callback(hObject, eventdata, handles)
% hObject    handle to BPwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function BPwrite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BPwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function OK_Solve_Callback(hObject, eventdata, handles)
% hObject    handle to OK_Solve (see GCBO)

    W = str2double(get(handles.Wwrite,'String'));
    Z = get(handles.Zwrite,'Value');
    bp = get(handles.BPwrite,'Value');
    
    axes(handles.Plot_Disp)
    cla
    run EXT2_Disp.m
        
    axes(handles.Plot_Stress)
    cla
    run EXT3_Stress.m
    
% ========================================================= %
% ========= Parametros de entrada para Resultados ========= %
% ========================================================= %

function Export_Callback(hObject, eventdata, handles)
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    Q     = evalin('base','Q');
    nele  = evalin('base','nele');
    hmax  = evalin('base','hmax');
    hmin  = evalin('base','hmin');
    j     = evalin('base','j');
    data  = importdata('data.mat');
    data(end+1,:) = [Q nele hmax hmin j (j/(nele*hmax/hmin))];
    save('data.mat','data')

run EXT4_Export.m

% ========================================================= %
% ===================== Al cerrar GUI ===================== %
% ========================================================= %

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
delete(hObject);
evalin('base','clear')
