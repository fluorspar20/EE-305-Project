function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 01-Nov-2021 12:10:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function polarizationFunc(Ein,e10,e20,k,phi)
Ein = Ein/norm(Ein);
fs = 50;
t = 0:1/fs:1;
omega = 2*pi/0.5;  % 2 rotation per second
dx = 0.01;
x = 0:dx:2;

npts = numel(x);
s_z = real(exp(1i*(omega*t(1)-k*x))*Ein(2));
s_y = real(exp(1i*(omega*t(1)-k*x))*Ein(1));

clf;
%%
subplot(2,3,[1 2 4 5]);
haxis_y = line([0 0],[-1.2 2.3],[0 0],'Color','k');
hasbehavior(haxis_y,'Legend',false);
text(0,2.4,0,'X','Color','k','FontWeight','bold');
haxis_z = line([0 0],[0 0],[-1.2 1.2],'Color','r');
hasbehavior(haxis_z,'Legend',false);
text(0,0,1.3,'Y','Color','r','FontWeight','bold');
haxis_x = line([-0.2 3.2],[0 0],[0 0],'Color','b');
hasbehavior(haxis_x,'Legend',false);
text(3.3,0,0,'Z','Color','b','FontWeight','bold');
axis([-0.5 3.5 -1.5 2.5 -1.5 1.5]);
hline_y = line(x,s_y,zeros(1,npts),'LineWidth',2,'LineStyle','none','Marker','.','Color','k');
hline_z = line(x,zeros(1,npts),s_z,'LineWidth',2,'LineStyle','none','Marker','.','Color','r');
hline_p = line(x,s_y,s_z,'LineWidth',2,'LineStyle','-','Color','b');
legend('X component of the Electric Field','Y component of the Electric Field',' Actual wave propagating along Z','Location', 'southwest');

hvec = line([0 0],[0 s_y(1)],[0 s_y(2)],'LineStyle','-','Color','b','LineWidth',3);
hdot = line(0,s_y(1),s_y(2),'Marker','.','Color','b','MarkerSize',30);
text(0,0,1.8,'H, V and Combined Fields','FontWeight','bold') 

view(45,30);
axis off;
set(gca,'CameraPosition',[17.1879 -15.6238 13.0003],'CameraTarget',[1.27803 0.286092 0.00987012], 'CameraViewAngle', [6.94742])% CameraPosition = [17.1879 -15.6238 13.0003]

subplot(2,3,3);
polellip(Ein);
hellip_ax = gca;
set(get(hellip_ax,'Title'),'FontWeight','bold','FontSize',get(0,'DefaultTextFontSize')) 
set(hellip_ax,'XLimMode','manual','YLimMode','manual','Xlim',[-1 1],'YLim',[-1 1])
htrace = line(s_y(1),s_z(1),'Parent',hellip_ax,'Marker','.','Color','b','MarkerSize',30);

subplot(2,3,3);
product = e10*e20*phi;
if product == 0
    text(-1,-2,'Linearly Polarized','Color','k','FontSize',12,'FontWeight','bold');
else if (abs(e10) == abs(e20) & (phi == pi/2 | phi == -pi/2))
    if product < 0
        text(-1,-2,'Right handed circularly polarized','Color','k','FontSize',12,'FontWeight','bold');
    else 
        text(-1,-2,'Left handed circularly polarized','Color','k','FontSize',12,'FontWeight','bold');
    end
    
else
    if product < 0
        text(-1,-2,'Right handed elliptically polarized','Color','k','FontSize',12,'FontWeight','bold');
    else 
        text(-1,-2,'Left handed elliptically polarized','Color','k','FontSize',12,'FontWeight','bold');
    end
    end
end


%%

for m = 2:numel(t)
    s_z = real(exp(1i*(omega*t(m)-k*x))*Ein(2));
    s_y = real(exp(1i*(omega*t(m)-k*x))*Ein(1));
    set(hline_z,'ZData',s_z);
    set(hline_y,'YData',s_y);
    set(hline_p,'YData',s_y,'ZData',s_z);
    set(hvec,'YData',[0 s_y(1)],'ZData',[0 s_z(1)]);
    set(hdot,'YData',s_y(1),'ZData',s_z(1));
    set(htrace,'XData',s_y(1),'YData',s_z(1));
    drawnow;
    pause(0.1);
end


% --- Executes on button press in submitbtn.
function submitbtn_Callback(hObject, eventdata, handles)
% hObject    handle to submitbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
e10 = str2num(get(handles.e10, 'String'));
e20 = str2num(get(handles.e20, 'String'));
beta = str2num(get(handles.beta, 'String'));
phi = str2num(get(handles.phi, 'String'));
% disp(e10);
% disp(e20);
% disp(beta);
% disp(phi);

phi = phi*pi/180;   % convert phi to radians
e20real = e20*cos(phi);
e20img = e20*sin(phi);
e20phasor = e20real + e20img*(1i);
fv = [e10;e20phasor];
% disp(fv);
polarizationFunc(fv,e10,e20,beta,phi);


function e10_Callback(hObject, eventdata, handles)
% hObject    handle to e10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e10 as text
%        str2double(get(hObject,'String')) returns contents of e10 as a double


% --- Executes during object creation, after setting all properties.
function e10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e20_Callback(hObject, eventdata, handles)
% hObject    handle to e20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e20 as text
%        str2double(get(hObject,'String')) returns contents of e20 as a double


% --- Executes during object creation, after setting all properties.
function e20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beta_Callback(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beta as text
%        str2double(get(hObject,'String')) returns contents of beta as a double


% --- Executes during object creation, after setting all properties.
function beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phi_Callback(hObject, eventdata, handles)
% hObject    handle to phi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phi as text
%        str2double(get(hObject,'String')) returns contents of phi as a double


% --- Executes during object creation, after setting all properties.
function phi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
