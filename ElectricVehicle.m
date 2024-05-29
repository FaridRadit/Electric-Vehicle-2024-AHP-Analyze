function varargout = ElectricVehicle(varargin)
% ELECTRICVEHICLE MATLAB code for ElectricVehicle.fig
%      ELECTRICVEHICLE, by itself, creates a new ELECTRICVEHICLE or raises the existing
%      singleton*.
%
%      H = ELECTRICVEHICLE returns the handle to a new ELECTRICVEHICLE or the handle to
%      the existing singleton*.
%
%      ELECTRICVEHICLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELECTRICVEHICLE.M with the given input arguments.
%
%      ELECTRICVEHICLE('Property','Value',...) creates a new ELECTRICVEHICLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ElectricVehicle_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ElectricVehicle_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ElectricVehicle

% Last Modified by GUIDE v2.5 27-May-2024 22:22:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ElectricVehicle_OpeningFcn, ...
                   'gui_OutputFcn',  @ElectricVehicle_OutputFcn, ...
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


% --- Executes just before ElectricVehicle is made visible.
function ElectricVehicle_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ElectricVehicle (see VARARGIN)
opts=detectImportOptions("cars.csv");
opts.SelectedVariableNames=(1:18);
alldata=table2cell(readtable("cars.csv"));
set(handles.table,'data',alldata);

% Choose default command line output for ElectricVehicle
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ElectricVehicle wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ElectricVehicle_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Show.
function Show_Callback(hObject, eventdata, handles)
    % Load the data
    data = readtable('cars.csv');
    
    % Extract relevant columns for normalization
    battery = data.Battery;
    top_speed = data.Top_Speed;
    efficiency = data.Efficiency;
    fastcharge = data.Fastcharge;
    uk_price = data.UK_price_after_incentives;
    
    % Normalize the data
    battery_norm = battery / sum(battery);
    top_speed_norm = top_speed / sum(top_speed);
    efficiency_norm = efficiency / sum(efficiency);
    fastcharge_norm = fastcharge / sum(fastcharge);
    uk_price_norm = uk_price / sum(uk_price);
    
    % Define weights (example weights, these should be adjusted based on your criteria)
    weights = [0.23399, 0.09261, 0.1749, 0.11689, 0.38232];
    
    % Combine normalized data into a matrix
    normalized_data = [battery_norm, top_speed_norm, efficiency_norm, fastcharge_norm, uk_price_norm];
    
    % Calculate the scores
    scores = normalized_data * weights';
    
    
    % Add scores to the table
    data.Score = scores;
    
    % Sort the table based on scores in descending order
    sorted_data = sortrows(data, 'Score', 'descend');
    
    % Add rank to the sorted data
    sorted_data.Rank = (1:height(sorted_data))';
    
    % Convert the table to cell array for compatibility with uitable
    sorted_data_cell = table2cell(sorted_data(:, {'Brand', 'Model', 'Battery', 'Top_Speed', 'Efficiency', 'Fastcharge', 'UK_price_after_incentives', 'Score', 'Rank'}));
    
    % Update the table in the GUI
    set(handles.table2, 'Data', sorted_data_cell);
