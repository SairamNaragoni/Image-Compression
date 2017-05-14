function varargout = ImageCompression(varargin)
% IMAGECOMPRESSION MATLAB code for ImageCompression.fig
%      IMAGECOMPRESSION, by itself, creates a new IMAGECOMPRESSION or raises the existing
%      singleton*.
%
%      H = IMAGECOMPRESSION returns the handle to a new IMAGECOMPRESSION or the handle to
%      the existing singleton*.
%
%      IMAGECOMPRESSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGECOMPRESSION.M with the given input arguments.
%
%      IMAGECOMPRESSION('Property','Value',...) creates a new IMAGECOMPRESSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageCompression_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageCompression_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageCompression

% Last Modified by GUIDE v2.5 14-May-2017 15:41:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageCompression_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageCompression_OutputFcn, ...
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


% --- Executes just before ImageCompression is made visible.
function ImageCompression_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageCompression (see VARARGIN)

% Choose default command line output for ImageCompression
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageCompression wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageCompression_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img Osize img_path i2
[img_path user_cancel] = imgetfile();
if user_cancel
    errordlg('Select An Image','No Image Selected');
    return;
end
fileinfo = dir(img_path);
SIZE = fileinfo.bytes;
Osize = SIZE/1024;
siz = round(Osize,1);
siz = strcat(num2str(siz),' kb');
set(handles.OSizeCal,'String',siz);
i = imread(img_path);
i = im2double(i);
axes(handles.scrn1);
imshow(i);
img = i;
i2 =img;


% --- Executes on button press in compress.
function compress_Callback(hObject, eventdata, handles)
% hObject    handle to compress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img Osize img_path i2
if isempty(img_path)
    errordlg('Select An Image','No Image Selected');
    return;
end

[rows cols z] = size(i2);
if rows<=cols
    r = rows-mod(rows,8);
    img = imresize(i2,[r r]);
else 
    c = cols-mod(cols,8);
    img = imresize(i2,[c c]);
end
t = dctmtx(8);
x = get(handles.dropdown,'Value');
switch x
    case 2
        mask = [1 1 1 1 0 0 0 0
                1 1 1 0 0 0 0 0
                1 1 0 0 0 0 0 0
                1 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0];
    case 3
        mask = [1 1 1 0 0 0 0 0
                1 1 0 0 0 0 0 0
                1 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0];
    case 4
        mask = [1 1 0 0 0 0 0 0
                1 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0];
     case 5
        mask = [1 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0];
    otherwise
        errordlg('Select Quality','No Quality Selected');
        return;
        
end
    
%Applying discrete cosine transform on red part 
i = img(:,:,1);
dct = @(block_struct) t * block_struct.data * t';
i = blockproc(i,[8 8],dct);
i = blockproc(i,[8 8],@(block_struct) mask .* block_struct.data);
invdct = @(block_struct) t' * block_struct.data *t;
r = blockproc(i,[8 8],invdct);

%Applying discrete cosine transform on green part
i = img(:,:,2);
dct = @(block_struct) t * block_struct.data * t';
i = blockproc(i,[8 8],dct);
i = blockproc(i,[8 8],@(block_struct) mask .* block_struct.data);
invdct = @(block_struct) t' * block_struct.data *t;
g = blockproc(i,[8 8],invdct);

%Applying discrete cosine transform on blue part
i = img(:,:,3);
dct = @(block_struct) t * block_struct.data * t';
i = blockproc(i,[8 8],dct);
i = blockproc(i,[8 8],@(block_struct) mask .* block_struct.data);
invdct = @(block_struct) t' * block_struct.data *t;
b = blockproc(i,[8 8],invdct);

%final Compressed Image
FinalImg(:,:,:)=cat(3,r, g, b);
FinalImg = imresize(FinalImg,[rows cols]);
axes(handles.scrn2);
imshow(FinalImg);
fname = get(handles.editSave2,'String');
fname = strcat(fname,'.jpg');
imwrite(FinalImg,fname);

%Compressed size calculation
fileinfo = dir(fname);
SIZE = fileinfo.bytes;
Csize = SIZE/1024;
siz = round(Csize,1);
siz = strcat(num2str(siz),' kb');
set(handles.CSizeCal,'String',siz);

%calculation of compression ratio
cratio = ((Osize-Csize)/Osize)*100;   
cratio = round(cratio,2);
set(handles.CRatioCal,'String',strcat((num2str(cratio)),' %'));


% --- Executes on button press in sav.
function sav_Callback(hObject, eventdata, handles)
% hObject    handle to sav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dname = uigetdir('C:\');
x = get(handles.editSave2,'String');
dname = strcat(dname,'\');
dname = strcat(dname,x);
set(handles.editSave2,'String',dname);
