%clear;clc;
img = imread('jetMap.png');
outline = edgeDetect(img,0.99,'display');
outline(outline > 0)= 255;
outline = outline(:,:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
goal_coords = [114, 3];
start_coords = [116,3];
outline(115,3) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start_coords = [50, 1];
% goal_coords = [48,1];
% outline(49,1) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%imshow(~outline)
outline = logical(outline);
drawMapEveryTime = true;
outliuniformGrid = true;
uniformGrid = true;

tic
[ROUTE, STEP, OUTMAP] = AerosolAStar_Function(outline, ...
                                        start_coords, ...
                                        goal_coords, ...
                                        drawMapEveryTime, ...
                                        uniformGrid);
toc




% file_path = sprintf('C:\\Users\\Hevander\\Documents\\MATLAB\\PIV_data\\HS5Soprano_565_567_PIVDATA0001\\HS5Soprano_565_567_PIVDATA0002.vc7'); % HS6 Soprano
% % file_path = sprintf('D:\\MyProjects\\HS7Baritone\\sing no mask\\Boundary\\5x5 gaussian smoothing\\B%05d.vc7',i); % HS7 Baritone
% file = readimx(file_path);
% % create vector data
% data = create2DVec(file.Frames{1});
% 
% % find the indices of velocity < 0.1
% indices = find(data.U<0.001);
% % set indices = 0
% data.U(indices)=0;
% data.V(:, :) = 0;
% quiver( data.X, data.Y, data.U, data.V)