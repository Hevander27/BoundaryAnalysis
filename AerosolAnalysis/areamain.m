
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

[AREA, LENGTH, WIDTH] = Aerosol_Metrics(outline, img);