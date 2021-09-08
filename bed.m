%BED
%The program 'bed' accepts a radiation therapy prescription (dose per fraction
%and suggested number of fractions). It allows the user to select relevant
%organs at risk (OAR) for the present treatment.
%__________________________________________________________________________
%For each OAR, the following INPUTS can be provided by the user:
%> Dose limit (as EQD2) in Gy
%> alpha/beta value in Gy
%> Previous irradiation (number of fractions,
%dose per fraction [Gy] and percentage of dose received by OAR)
%> percentage of the currently prescribed dose that the OAR will receive
%__________________________________________________________________________
%The OUTPUTS of the program are as follows:
%> Highest possible total dose to the target
%> Number of fractions in which this dose can be delivered.
%> A comment highlighting whether the suggested treatment is:
%1. > possible but not optimal (OAR dose limits not exceeded, but total
%dose to target less than maximum possible).
%2  > possible and optimal (OAR dose limits not exceeded, and total dose to
%target is equal to maximum possible).
%3  > not possible (dose limit exceeded in at least one OAR)
%__________________________________________________________________________
%Author: Arthur Chakwizira

%% INITIALISATION OF GUI WINDOW
function varargout = bed(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bed_OpeningFcn, ...
                   'gui_OutputFcn',  @bed_OutputFcn, ...
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

%% INITIALISATION OF VARIABLES
% --- Executes just before GUI is made visible.
function bed_OpeningFcn(hObject, eventdata, handles, varargin)
%the handles stucture contains all of the GUI's data
handles.output = hObject;
movegui('center')
%-------------------------------------------------------------------------
 %organs at risk to include; none selected by default
handles.spinal_cord = false;
handles.lung = false;
handles.kidney = false;
handles.heart = false;
handles.rectum = false;
handles.bladder = false;
handles.other = false;
%-------------------------------------------------------------------------
%default dose limits for OAR; specified as EQD2 in Gy
handles.dlim_spinal_cord = 50; 
set(handles.edit3, 'String', num2str(handles.dlim_spinal_cord))
handles.dlim_lung = 35;
set(handles.edit4, 'String', num2str(handles.dlim_lung))
handles.dlim_kidney = 18;
set(handles.edit5, 'String', num2str(handles.dlim_kidney))
handles.dlim_heart = 78;
set(handles.edit6, 'String', num2str(handles.dlim_heart))
handles.dlim_rectum = 60;
set(handles.edit7, 'String', num2str(handles.dlim_rectum))
handles.dlim_bladder = 55;
set(handles.edit8, 'String', num2str(handles.dlim_bladder))
handles.dlim_other = 50;
set(handles.edit9, 'String', num2str(handles.dlim_other))
%-------------------------------------------------------------------------
%default alpha/beta values for OAF, in Gy
handles.ab_spinal_cord = 2; 
set(handles.edit10, 'String', num2str(handles.ab_spinal_cord))
handles.ab_lung = 3;
set(handles.edit11, 'String', num2str(handles.ab_lung))
handles.ab_kidney = 2.2;
set(handles.edit12, 'String', num2str(handles.ab_kidney))
handles.ab_heart = 2;
set(handles.edit13, 'String', num2str(handles.ab_heart))
handles.ab_rectum = 4;
set(handles.edit14, 'String', num2str(handles.ab_rectum))
handles.ab_bladder = 5;
set(handles.edit15, 'String', num2str(handles.ab_bladder))
handles.ab_other = 2;
set(handles.edit16, 'String', num2str(handles.ab_other))
%-------------------------------------------------------------------------
%previous irradiation: no. of fractions; default zero
handles.nprev_spinal_cord = 0; 
set(handles.edit17, 'String', num2str(handles.nprev_spinal_cord))
handles.nprev_lung = 0;
set(handles.edit18, 'String', num2str(handles.nprev_lung))
handles.nprev_kidney = 0;
set(handles.edit19, 'String', num2str(handles.nprev_kidney))
handles.nprev_heart = 0;
set(handles.edit20, 'String', num2str(handles.nprev_heart))
handles.nprev_rectum = 0;
set(handles.edit21, 'String', num2str(handles.nprev_rectum))
handles.nprev_bladder = 0;
set(handles.edit22, 'String', num2str(handles.nprev_bladder))
handles.nprev_other = 0;
set(handles.edit23, 'String', num2str(handles.nprev_other))
%-------------------------------------------------------------------------
%previous irradiation: dose per fraction; default zero
handles.dprev_spinal_cord = 0; 
set(handles.edit24, 'String', num2str(handles.dprev_spinal_cord))
handles.dprev_lung = 0;
set(handles.edit25, 'String', num2str(handles.dprev_lung))
handles.dprev_kidney = 0;
set(handles.edit26, 'String', num2str(handles.dprev_kidney))
handles.dprev_heart = 0;
set(handles.edit27, 'String', num2str(handles.dprev_heart))
handles.dprev_rectum = 0;
set(handles.edit28, 'String', num2str(handles.dprev_rectum))
handles.dprev_bladder = 0;
set(handles.edit29, 'String', num2str(handles.dprev_bladder))
handles.dprev_other = 0;
set(handles.edit30, 'String', num2str(handles.dprev_other))
%-------------------------------------------------------------------------
 %previous irradiation: percentage dose to OAR per fraction; default zero
handles.dpercprev_spinal_cord = 0;
set(handles.edit41, 'String', num2str(handles.dpercprev_spinal_cord))
handles.dpercprev_lung = 0;
set(handles.edit42, 'String', num2str(handles.dpercprev_lung))
handles.dpercprev_kidney = 0;
set(handles.edit43, 'String', num2str(handles.dpercprev_kidney))
handles.dpercprev_heart = 0;
set(handles.edit44, 'String', num2str(handles.dpercprev_heart))
handles.dpercprev_rectum = 0;
set(handles.edit45, 'String', num2str(handles.dpercprev_rectum))
handles.dpercprev_bladder = 0;
set(handles.edit46, 'String', num2str(handles.dpercprev_bladder))
handles.dpercprev_other = 0;
set(handles.edit47, 'String', num2str(handles.dpercprev_other))
%-------------------------------------------------------------------------
%present irradiation: percentage dose to OAR; default zero
handles.dpercent_spinal_cord = 0; 
set(handles.edit31, 'String', num2str(handles.dpercent_spinal_cord))
handles.dpercent_lung = 0;
set(handles.edit32, 'String', num2str(handles.dpercent_lung))
handles.dpercent_kidney= 0;
set(handles.edit33, 'String', num2str(handles.dpercent_kidney))
handles.dpercent_heart = 0;
set(handles.edit34, 'String', num2str(handles.dpercent_heart))
handles.dpercent_rectum = 0;
set(handles.edit35, 'String', num2str(handles.dpercent_rectum))
handles.dpercent_bladder = 0;
set(handles.edit36, 'String', num2str(handles.dpercent_bladder))
handles.dpercent_other = 0;
set(handles.edit37, 'String', num2str(handles.dpercent_other))
%-------------------------------------------------------------------------
handles.presc_target_d = 0; %default prescribed dose; zero
handles.presc_n = 0; %default prescribed number of fractions; zero
guidata(hObject, handles); % Update handles structure

% --- Outputs from this function are returned to the command line.
function varargout = bed_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
%--------------------------------------------------------------------------



%% SERIES OF EDIT FIELDS TO COLLECT USER INPUT

%--------------------------------------------------------------------------

%DOSE PER FRACTION TO TARGET
function edit1_Callback(hObject, eventdata, handles)
try
    handles.presc_target_d = str2double(get(hObject,'String')); %try to grab user input
    if isnan(handles.presc_target_d) || (handles.presc_target_d == 0) %str2double returns NaN if input can not be converted to double
        set(hObject, 'BackGroundColor', [1 0.5 0]) %if this happens, highlight edit field in orange
    else
        set(hObject, 'BackGroundColor', 'white') %otherwise leave it white
    end
catch   %if user input raises an error
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0]) %highlight edit field in orange
end
guidata(hObject, handles)   %update handles structure

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% SUGGESTED NUMBER OF FRACTIONS
function edit2_Callback(hObject, eventdata, handles)
try
    handles.presc_n = str2double(get(hObject,'String'));
    if isnan(handles.presc_n)
        if isempty(get(hObject,'String'))
            handles.presc_n = 0;
        else
            set(hObject, 'BackGroundColor', [1 0.5 0])
        end
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------

%INCLUDE SPINAL CORD
% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
handles.spinal_cord = get(hObject,'Value');
guidata(hObject, handles)

%INCLUDE LUNG
% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
handles.lung = get(hObject,'Value');
guidata(hObject, handles)

%INCLUDE KIDNEY
% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
handles.kidney = get(hObject,'Value');
guidata(hObject, handles)

%INCLUDE HEART
% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
handles.heart = get(hObject,'Value');
guidata(hObject, handles)

%INCLUDE RECTUM
% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
handles.rectum = get(hObject,'Value');
guidata(hObject, handles)

%INCLUDE BLADDER
% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
handles.bladder = get(hObject,'Value');
guidata(hObject, handles)

%INCLUDE OTHER
% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
handles.other = get(hObject,'Value');
guidata(hObject, handles)

%--------------------------------------------------------------------------


%Dose limit spinal cord
function edit3_Callback(hObject, eventdata, handles)
try
    handles.dlim_spinal_cord = str2double(get(hObject,'String'));
    if isnan(handles.dlim_spinal_cord)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Dose limit Lung
function edit4_Callback(hObject, eventdata, handles)
try
    handles.dlim_lung = str2double(get(hObject,'String'));
    if isnan(handles.dlim_lung)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Dose limit kidney
function edit5_Callback(hObject, eventdata, handles)
try
    handles.dlim_kidney = str2double(get(hObject,'String'));
    if isnan(handles.dlim_kidney)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Dose limit heart
function edit6_Callback(hObject, eventdata, handles)
try
    handles.dlim_heart = str2double(get(hObject,'String'));
    if isnan(handles.dlim_heart)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Dose limit rectum
function edit7_Callback(hObject, eventdata, handles)
try
    handles.dlim_rectum = str2double(get(hObject,'String'));
    if isnan(handles.dlim_rectum)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Dose limit bladder
function edit8_Callback(hObject, eventdata, handles)
try
    handles.dlim_bladder = str2double(get(hObject,'String'));
    if isnan(handles.dlim_bladder)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Dose limit other
function edit9_Callback(hObject, eventdata, handles)
try
    handles.dlim_other = str2double(get(hObject,'String'));
    if isnan(handles.dlim_other)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------


%alpha beta spinal cord
function edit10_Callback(hObject, eventdata, handles)
try
    handles.ab_spinal_cord = str2double(get(hObject,'String'));
    if isnan(handles.ab_spinal_cord)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%alpha beta lung
function edit11_Callback(hObject, eventdata, handles)
try
    handles.ab_lung = str2double(get(hObject,'String'));
    if isnan(handles.ab_lung)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%alpha beta kidney
function edit12_Callback(hObject, eventdata, handles)
try
    handles.ab_kidney = str2double(get(hObject,'String'));
    if isnan(handles.ab_kidney)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%alpha beta heart
function edit13_Callback(hObject, eventdata, handles)
try
    handles.ab_heart = str2double(get(hObject,'String'));
    if isnan(handles.ab_heart)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%alpha beta rectum
function edit14_Callback(hObject, eventdata, handles)
try
    handles.ab_rectum = str2double(get(hObject,'String'));
    if isnan(handles.ab_rectum)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%alpha beta bladder
function edit15_Callback(hObject, eventdata, handles)
try
    handles.ab_bladder = str2double(get(hObject,'String'));
    if isnan(handles.ab_bladder)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%alpha beta other
function edit16_Callback(hObject, eventdata, handles)
try
    handles.ab_other = str2double(get(hObject,'String'));
    if isnan(handles.ab_other)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------


%Previous # fractions spinal cord
function edit17_Callback(hObject, eventdata, handles)
try
    handles.nprev_spinal_cord = str2double(get(hObject,'String'));
    if isnan(handles.nprev_spinal_cord)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Previous # fractions lung
function edit18_Callback(hObject, eventdata, handles)
try
    handles.nprev_lung = str2double(get(hObject,'String'));
    if isnan(handles.nprev_lung)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Previous # fractions kidney
function edit19_Callback(hObject, eventdata, handles)
try
    handles.nprev_kidney = str2double(get(hObject,'String'));
    if isnan(handles.nprev_kidney)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Previous # fractions heart
function edit20_Callback(hObject, eventdata, handles)
try
    handles.nprev_heart = str2double(get(hObject,'String'));
    if isnan(handles.nprev_heart)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Previous # fraction rectum
function edit21_Callback(hObject, eventdata, handles)
try
    handles.nprev_rectum = str2double(get(hObject,'String'));
    if isnan(handles.nprev_rectum)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Previous # fraction bladder
function edit22_Callback(hObject, eventdata, handles)
try
    handles.nprev_bladder = str2double(get(hObject,'String'));
    if isnan(handles.nprev_bladder)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Previous # fraction other
function edit23_Callback(hObject, eventdata, handles)
try
    handles.nprev_other = str2double(get(hObject,'String'));
    if isnan(handles.nprev_other)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------

%PREVIOUS DOSE PER FRACTION

%spinal cord
function edit24_Callback(hObject, eventdata, handles)
try
    handles.dprev_spinal_cord = str2double(get(hObject,'String'));
    if isnan(handles.dprev_spinal_cord)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%lung
function edit25_Callback(hObject, eventdata, handles)
try
    handles.dprev_lung = str2double(get(hObject,'String'));
    if isnan(handles.dprev_lung)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%kidney
function edit26_Callback(hObject, eventdata, handles)
try
    handles.dprev_kidney = str2double(get(hObject,'String'));
    if isnan(handles.dprev_kidney)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%heart
function edit27_Callback(hObject, eventdata, handles)
try
    handles.dprev_heart = str2double(get(hObject,'String'));
    if isnan(handles.dprev_heart)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%rectum
function edit28_Callback(hObject, eventdata, handles)
try
    handles.dprev_rectum = str2double(get(hObject,'String'));
    if isnan(handles.dprev_rectum)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%bladder
function edit29_Callback(hObject, eventdata, handles)
try
    handles.dprev_bladder = str2double(get(hObject,'String'));
    if isnan(handles.dprev_bladder)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%other
function edit30_Callback(hObject, eventdata, handles)
try
    handles.dprev_other = str2double(get(hObject,'String'));
    if isnan(handles.dprev_other)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%PERCENTAGE DOSE RECEIVED BY ORGAN DURING PREVIOUS TREATMENT
%--------------------------------------------------------------------------
%percentage previous dose for spinal_code
function edit41_Callback(hObject, eventdata, handles)
try
    handles.dpercprev_spinal_cord = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercprev_spinal_cord)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%percentage previous dose for lung
function edit42_Callback(hObject, eventdata, handles)
try
    handles.dpercprev_lung = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercprev_lung)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%percentage previous dose for kidney
function edit43_Callback(hObject, eventdata, handles)
try
    handles.dpercprev_kidney = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercprev_kidney)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%percentage previous dose for heart
function edit44_Callback(hObject, eventdata, handles)
try
    handles.dpercprev_heart = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercprev_heart)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%percentage previous dose for rectum
function edit45_Callback(hObject, eventdata, handles)
try
    handles.dpercprev_rectum = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercprev_rectum)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%percentage previous dose for bladder
function edit46_Callback(hObject, eventdata, handles)
try
    handles.dpercprev_bladder = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercprev_bladder)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%percentage previous dose for other
function edit47_Callback(hObject, eventdata, handles)
try
    handles.dpercprev_other = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercprev_other)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------------------------------------------------------------------

%PERCENTAGE DOSE TO ORGAN FROM CURRENT TREATMENT

%spinal code
function edit31_Callback(hObject, eventdata, handles)
try
    handles.dpercent_spinal_cord = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercent_spinal_cord)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%lung
function edit32_Callback(hObject, eventdata, handles)
try
    handles.dpercent_lung = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercent_lung)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%kidney
function edit33_Callback(hObject, eventdata, handles)
try
    handles.dpercent_kidney = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercent_kidney)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%heart
function edit34_Callback(hObject, eventdata, handles)
try
    handles.dpercent_heart = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercent_heart)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%rectum
function edit35_Callback(hObject, eventdata, handles)
try
    handles.dpercent_rectum = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercent_rectum)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%bladder
function edit36_Callback(hObject, eventdata, handles)
try
    handles.dpercent_bladder = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercent_bladder)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%other
function edit37_Callback(hObject, eventdata, handles)
try
    handles.dpercent_other = str2double(get(hObject,'String'))/100;
    if isnan(handles.dpercent_other)
        set(hObject, 'BackGroundColor', [1 0.5 0])
    else
        set(hObject, 'BackGroundColor', 'white')
    end
catch
    set(hObject, 'String', get(hObject,'String'), 'BackGroundColor', [1 0.5 0])
end
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
%DISPLAY OF RESULTS

function edit38_Callback(hObject, eventdata, handles)
%this edit field displays the highest possible total dose to the target

% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit39_Callback(hObject, eventdata, handles)
%this edit field displays the maximum possible number of fractions

% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit40_Callback(hObject, eventdata, handles)
%this edit field displays comments on the results of the calculation

% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------

%HELP
%Opens a file containing a description of the methods used.
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
try
    open('bed_metod.pdf') %try to open this file
catch
    set(handles.edit40, 'String', 'File ''bed_metod.pdf'' not found in current directory', 'ForeGroundColor', 'red') %report error if file is missing
end

%--------------------------------------------------------------------------
%
%
%
%
%
%% THIS IS THE MAIN FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton1_Callback(hObject, eventdata, handles)
%Executes when the Calculate button is pressed.
set(handles.edit40, 'String', '') %clear comments field
%--------------------------------------------------------------------------
if isnan(handles.presc_target_d) || isnan(handles.presc_n) || (handles.presc_target_d == 0) %if user provided invalid values in prescription
    error_msg = 'Invalid inputs in prescription'; %raise this error
    set(handles.edit40, 'String', error_msg, 'ForeGroundColor', 'red')
    return %and terminate execution
end
%--------------------------------------------------------------------------
risk_organs = {'spinal_cord', 'lung', 'kidney', 'heart', 'rectum', 'bladder', 'other'}; %organs at risk
handles.nmax_all = NaN(size(risk_organs)); %initialise array of maximum number of fractions for each organ given the prescribed dose per fraction
organs_selected = 0; %this is used to check if the user has selected at least one OAR; variable remains null if no OAR is selected
    for oar = 1:length(risk_organs) %for each oar
        if handles.(risk_organs{oar}) %if user has selected it
        organs_selected = organs_selected + 1; %update tracker variable
        organ = risk_organs{oar};
        %calculate bed tolerance for this organ
        handles.(['bed_tol_' organ]) = handles.(['dlim_' organ])*(1 + (2/handles.(['ab_' organ])));
        %calculate bed from previous treatment
        handles.(['bed_prev_' organ]) = handles.(['dpercprev_' organ])*handles.(['dprev_' organ])*handles.(['nprev_' organ])*(1 + (handles.(['dpercprev_' organ])*handles.(['dprev_' organ])/handles.(['ab_' organ]))); 
        %calculate bed left to give
        handles.(['bed_max_' organ]) = handles.(['bed_tol_' organ]) - handles.(['bed_prev_' organ]); 
        %calculate the corresponding number of fractions given the prescribed dose per fraction
        handles.(['nmax_' organ]) = floor(handles.(['bed_max_' organ])/( handles.(['dpercent_' organ])*handles.presc_target_d*(1 + (handles.(['dpercent_' organ])*handles.presc_target_d/handles.(['ab_' organ])) ) ));
        %save result to the array of maximum number of fractions for each oar
        handles.nmax_all(oar) = handles.(['nmax_' organ]);
        end
    end
 handles.nmax_all_copy = handles.nmax_all; %copy the array of maximum number of fractions for each OAR because it will be modified below
if organs_selected > 0 %if user has selected at least one OAR
    try %try to execute the following statements
        handles.nmax_all(~isfinite(handles.nmax_all)) = NaN; %set infinite numbers of fractions to NaN (inf occurs when percentage dose to a selected OAR is zero)
        handles.nmax_all(isnan(handles.nmax_all)) = []; %then delete all NaN values from the array
            if isempty(handles.nmax_all) || (length(handles.nmax_all) < organs_selected) %if array is empty or calculations for some organ returned NaN
               wrap_text = textwrap(handles.edit40, {'Problem encountered. Possible causes are:', '- Zero dose contribution to selected OAR(s)', ...
                   '- Invalid inputs'}); %inf values were encountered in the calculation; report error
               set(handles.edit40, 'String', wrap_text, 'ForeGroundColor', 'red')
               set(handles.edit38, 'String', num2str(handles.presc_target_d*handles.presc_n), 'ForeGroundColor', 'b')
               set(handles.edit39, 'String', num2str(handles.presc_n), 'ForeGroundColor', 'b') %set results to the same values as in prescription
            else %if array of maximum number of fractions for each OAR is not empty
                handles.target_n = min(handles.nmax_all(:)); %take its minimum; this is the optimal number of fractions
                handles.target_total_dose = handles.target_n*handles.presc_target_d; %the corresponding total dose is the product of the prescribed dose per fraction and the optimal number of fractions
                set(handles.edit38, 'String', num2str(handles.target_total_dose), 'ForeGroundColor', 'b') %display the total dose to target
                set(handles.edit39, 'String', num2str(handles.target_n), 'ForeGroundColor', 'b') %display optimal number of fractions
                if handles.presc_n == handles.target_n %if the prescribed number of fractions equals the optimal number of fractions
                    wrap_text = 'Suggested treatment is possible and optimal'; %notify the user
                    set(handles.edit40, 'String', wrap_text , 'ForeGroundColor', [0 0.5 0]) 
                end
                if handles.presc_n < handles.target_n  %if the prescribed number of fractions is less than the optimal number of fractions
                    if handles.presc_n ~= 0 %and if a prescribed number of fractions was provided (that is, user entered a non-zero value in the edit field)
                        wrap_text = 'Suggested treatment is possible but not optimal';  %notify the user
                        set(handles.edit40, 'String', wrap_text , 'ForeGroundColor', 'b')
                    end
                end
                if handles.presc_n > handles.target_n %if the prescribed number of fractions is greater than the optimal number of fractions
                    error_org =  string(risk_organs(handles.nmax_all_copy < handles.presc_n)); %find the organ whose dose limit is exceeded if treatment is done with the prescribed number of fractions
                    wrap_text = textwrap(handles.edit40, {'Suggested treatment is not possible.', 'Dose limits are exceeded in:  ', ...
                    error_org' }); %notify the user and specify the organ(s) in which dose limits are exceeded
                    set(handles.edit40, 'String', wrap_text, 'ForeGroundColor', 'r')
                end
            end
    catch       %if any of the above statements throws an error
        error_msg = 'Provide valid inputs'; %raise this error
        set(handles.edit40, 'String', error_msg, 'ForeGroundColor', 'r')
    end
else  %if the user has not selected any organ at risk
    error_msg = 'Select at least one organ at risk.'; %warn the user
    set(handles.edit40, 'String', error_msg, 'ForeGroundColor','red')
    set(handles.edit38, 'String', num2str(handles.presc_target_d*handles.presc_n), 'ForeGroundColor', 'b') %set results equal to prescription
    set(handles.edit39, 'String', num2str(handles.presc_n), 'ForeGroundColor', 'b')
end
guidata(hObject, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
