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

% Last Modified by GUIDE v2.5 06-Jun-2015 03:41:50

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
handles.output = hObject;
% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Update handles structure
guidata(hObject, handles);
initialize_gui(hObject, handles, false);

% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function initialize_gui(fig_handle, handles, isreset)
    % Program starts in main menu:
    N = 5; % Total quantity of locker columns
    assignin('base','N',N)
    % Initial state, no option selected:
    assignin('base','Phase',0)
    assignin('base','Option',0)
    assignin('base','num_type',[])
    % Disable all inputs except option keypad:
    assignin('base','Benable',1) % Enable option keypad
    assignin('base','Kenable',0) % Disable number keypad
    assignin('base','Senable',0) % Disable fingerprint scanner
    assignin('base','Penable',0) % Disable cash machine
    % GUI Database initialization
    DATABASE = xlsread('DATABASE.xls');
    assignin('base','DATABASE',DATABASE)
    set(handles.Database,'Data',DATABASE)
    % GUI FP Scanner initialization
    FPblank = imread('FPblank.jpg'); % Clear FP Scanner
    axes(handles.A_FP);
    FPicon = image(FPblank);         % Display blank Scanner
    assignin('base','FP',FPblank)
    assignin('base','FPblank',FPblank)
    assignin('base','FPicon',FPicon)
    axis off  % Remove axis lines from FP Scanner
    axes(handles.A_Display);
    axis off  % Remove axis lines from LCD Screen
    clc
    run Config_A_Menu.m

% =============================================================== COMMANDS

function B_1_Callback(hObject, eventdata, handles)  % -- Callback BLUE
% hObject    handle to B_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Benable = evalin('base','Benable');
if (Benable == 1)    % COMMAND KEYBOARD ENABLED
    switch Phase
        case 0
            N = evalin('base','N');
            DATABASE = evalin('base','DATABASE');
            if (size(DATABASE,1) < 4*N)
                assignin('base','Option',1);
                assignin('base','Phase',1);
                run Config_B_Scan_Ini.m
            else
                run Config_NOVACANCY.m
                assignin('base','Option',0);
                assignin('base','Phase',0);
                run Config_A_Menu.m
            end
        case 41
            assignin('base','Option',0);
            assignin('base','Phase',0);
            run Config_4A_iPay.m
    end
end

function B_2_Callback(hObject, eventdata, handles)  % -- Callback RED
% hObject    handle to B_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Benable = evalin('base','Benable');
if (Benable == 1)    % COMMAND KEYBOARD ENABLED
    switch Phase
        case 0
            assignin('base','Option',2);
            assignin('base','Phase',1);
            run Config_B_Scan_Ini.m
        case 31
            run Config_3F_Erased.m
            DATABASE = evalin('base','DATABASE');
            set(handles.Database,'Data',DATABASE)
            xlswrite('DATABASE.xls',DATABASE);
            assignin('base','Option',0);
            assignin('base','Phase',0);
            run Config_A_Menu.m
        case 41
            assignin('base','Option',0);
            assignin('base','Phase',0);
            run Config_4B_iUse.m
    end
end

function B_3_Callback(hObject, eventdata, handles)  % -- Callback GREEN
% hObject    handle to B_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Benable = evalin('base','Benable');
if (Benable == 1)    % COMMAND KEYBOARD ENABLED
    switch Phase
        case 0
            assignin('base','Option',3);
            assignin('base','Phase',1);
            run Config_B_Scan_Ini.m
        case 41
            rct_imag = evalin('base','rct_imag');
            delete(rct_imag)
            assignin('base','Option',4);
            assignin('base','Phase',41);
            run Config_B_Scan_Ini.m
    end
end

function B_4_Callback(hObject, eventdata, handles)  % -- Callback PURPLE
% hObject    handle to B_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Benable = evalin('base','Benable');
if (Benable == 1)    % COMMAND KEYBOARD ENABLED
    switch Phase
        case 0
            assignin('base','Phase',41);
            run Config_41_Info.m
        otherwise
            cla
            assignin('base','Option',0);
            assignin('base','Phase',0);
            run Config_A_Menu.m
    end
end

% ================================================================= KEYPAD

function B_K1_Callback(hObject, eventdata, handles) % Callback KEY 1
% hObject    handle to B_K1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 1;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 1;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end
    
function B_K2_Callback(hObject, eventdata, handles) % Callback KEY 2
% hObject    handle to B_K2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 2;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 2;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_K3_Callback(hObject, eventdata, handles) % Callback KEY 3
% hObject    handle to B_K3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 3;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 3;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_K4_Callback(hObject, eventdata, handles) % Callback KEY 4
% hObject    handle to B_K4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 4;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 4;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_K5_Callback(hObject, eventdata, handles) % Callback KEY 5
% hObject    handle to B_K5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 5;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 5;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_K6_Callback(hObject, eventdata, handles) % Callback KEY 6
% hObject    handle to B_K6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 6;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 6;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_K7_Callback(hObject, eventdata, handles) % Callback KEY 7
% hObject    handle to B_K7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in B_K8.
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 7;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 7;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_K8_Callback(hObject, eventdata, handles) % Callback KEY 8
% hObject    handle to B_K8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 8;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 8;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_K9_Callback(hObject, eventdata, handles) % Callback KEY 9
% hObject    handle to B_K9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if isempty(num_type) == 1
        num_type = 9;
        assignin('base','num_type',num_type)
    elseif log10(num_type) <= 1
        num_type = 10*(num_type) + 9;
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_K0_Callback(hObject, eventdata, handles) % Callback KEY 0
% hObject    handle to B_K0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Benable = evalin('base','Benable');
Kenable = evalin('base','Kenable');
Senable = evalin('base','Senable');
Penable = evalin('base','Penable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    if log10(num_type) <= 1
        num_type = 10*(num_type);
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_KD_Callback(hObject, eventdata, handles) % Callback DELETE
% hObject    handle to B_KD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if Kenable == 1
    if (floor(log10(num_type)) > 0)
        num_type = floor((num_type)/10);
        assignin('base','num_type',num_type)
    else
        num_type = [ ];
        assignin('base','num_type',num_type)
    end
    set(txt_type,'String',strcat(num2str(num_type)))
end

function B_KO_Callback(hObject, eventdata, handles) % Callback KEY OK
% hObject    handle to B_KO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Kenable = evalin('base','Kenable');
num_type = evalin('base','num_type');
txt_type = evalin('base','txt_type');
if (Kenable == 1)
    run Config_11_Hire_OK.m
    Free = evalin('base','Free');
    if (Free == 1)&&(num_type <= 4*N)
        assignin('base','Phase',12)
        assignin('base','Kenable',0)
        assignin('base','Penable',1)
        assignin('base','tried',0)
        run Config_12_Fee_Ini.m
    end
end

% ================================================================= SENSOR

function B_FP_Callback(hObject, eventdata, handles)   % Callback BROWSE
% hObject    handle to B_FP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FPicon = evalin('base','FPicon');
[FPname Folder] = uigetfile('*.jpg','Select "Fingerprint" image...');
directory = strcat(Folder,FPname);
assignin('base','FPname',FPname)
FP = 255*round(imread(directory)/255);
axes(handles.A_FP);
axis off
set(FPicon,'CData',FP)
axis off
assignin('base','FP',FP)
assignin('base','Senable',1)
axes(handles.A_Display)

function B_SM_Callback(hObject, eventdata, handles)   % Callback COMPARE
% hObject    handle to B_SM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N       = evalin('base','N');
FP      = evalin('base','FP');
FPblank = evalin('base','FPblank');
Phase   = evalin('base','Phase');
Option  = evalin('base','Option');
Senable = evalin('base','Senable');
axes(handles.A_Display);
axis off
if (Senable == 1)
    switch Phase
        case {1,41}
            if (isequal(FP,FPblank) == 0)
                assignin('base','Benable',0)
                run Config_B_Scan_Run.m
                assignin('base','Benable',1)
                switch Option
                    case 1
                        if (isempty(num_unit) == 1) % Need to be new
                            run Config_B_Scan_Hire.m
                            assignin('base','Phase',11)
                            assignin('base','Senable',0)
                            assignin('base','Kenable',1)
                            run Config_11_Hire.m
                        else
                            run Config_B_Scan_HireE.m
                            assignin('base','Phase',0)
                            assignin('base','Senable',0)
                            assignin('base','Option',0)
                            run Config_A_Menu.m
                        end
                    case 2
                        if (isempty(num_unit) == 0) % Need to be registered
                            run Config_B_Scan_User.m
                            assignin('base','Phase',21)
                            assignin('base','Senable',0)
                            run Config_Trial.m
                            let = evalin('base','let');
                            if (let == 1)
                                run Config_2F_Opened.m
                                assignin('base','Phase',0)
                                assignin('base','Option',0)
                                run Config_A_Menu.m
                            else
                                assignin('base','Benable',0)
                                run Config_2F_Dismiss.m
                                assignin('base','Phase',0)
                                assignin('base','Senable',0)
                                assignin('base','Option',0)
                                assignin('base','Benable',1)
                                run Config_A_Menu.m
                            end
                        else
                            run Config_B_Scan_UserE.m
                            assignin('base','Phase',0)
                            assignin('base','Senable',0)
                            assignin('base','Option',0)
                            run Config_A_Menu.m
                        end
                    case 3
                        if (isempty(num_unit) == 0) % Need to be registered
                            run Config_B_Scan_User.m
                            assignin('base','Phase',31)
                            assignin('base','Senable',0)
                            run Config_Trial.m
                            let = evalin('base','let');
                            if (let == 1)
                                run Config_31_Confirm.m
                            else
                                assignin('base','Benable',0)
                                run Config_31_Dismiss.m
                                assignin('base','Phase',0)
                                assignin('base','Senable',0)
                                assignin('base','Option',0)
                                assignin('base','Benable',1)
                                run Config_A_Menu.m
                            end
                        else
                            run Config_B_Scan_UserE.m
                            assignin('base','Phase',0)
                            assignin('base','Senable',0)
                            assignin('base','Option',0)
                            run Config_A_Menu.m
                        end
                    case 4
                        if (isempty(num_unit) == 0) % Need to be registered
                            run Config_B_Scan_User.m
                            assignin('base','Phase',42)
                            assignin('base','Senable',0)
                            assignin('base','Penable',1)
                            assignin('base','tried',0)
                            run Config_42_Fee_Ini.m
                        else
                            run Config_B_Scan_UserE.m
                            assignin('base','Phase',0)
                            assignin('base','Senable',0)
                            assignin('base','Option',0)
                            run Config_A_Menu.m
                        end
                end
            end
    end
end

function B_CashOK_Callback(hObject, eventdata, handles) % Callback Cash
% hObject    handle to B_CashOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Penable = evalin('base','Penable');
FP      = evalin('base','FP');
num_type = evalin('base','num_type');
if (Penable == 1)
    switch Phase
        case 12
            assignin('base','Benable',0)
            assignin('base','Penable',0)
            run Config_12_Fee_OK.m
            run Config_1F_Opened.m
            DATABASE = evalin('base','DATABASE');
            set(handles.Database,'Data',DATABASE)
            xlswrite('DATABASE.xls',DATABASE);
            assignin('base','Phase',0)
            assignin('base','Option',0)
            assignin('base','Benable',1)
            run Config_A_Menu.m
        case 42
            assignin('base','Benable',0)
            assignin('base','Penable',0)
            run Config_42_Fee_OK.m
            run Config_4F_Opened.m
            DATABASE = evalin('base','DATABASE');
            set(handles.Database,'Data',DATABASE)
            xlswrite('DATABASE.xls',DATABASE);
            assignin('base','Phase',0)
            assignin('base','Option',0)
            assignin('base','Benable',1)
            run Config_A_Menu.m
    end
end

function B_CashNO_Callback(hObject, eventdata, handles)
% hObject    handle to B_CashNO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Phase   = evalin('base','Phase');
Penable = evalin('base','Penable');
FP      = evalin('base','FP');
num_type = evalin('base','num_type');
if (Penable == 1)
    switch Phase
        case 12
            assignin('base','Benable',0)
            run Config_12_Fee_NO.m
            assignin('base','Benable',1)
            run Config_12_Fee_Ini.m
        case 42
            assignin('base','Benable',0)
            run Config_42_Fee_NO.m
            assignin('base','Benable',1)
            run Config_42_Fee_Ini.m
    end
end

% =============================================================== DATABASE

function Database_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Database (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
DATABASE = get(hObject,'Data');
xlswrite('DATABASE.xls',DATABASE);
