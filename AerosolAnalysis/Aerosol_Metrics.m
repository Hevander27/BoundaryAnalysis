function [AREA, LENGTH, WIDTH] = Aerosol_Metrics(input_map, img)
%IMGCLUSTER Image data clustering using fuzzy c-means cluster.
%
% Author: Hevander Da Costa
% Date: 03/24/2022
% 
% Function: 
%   [AREA, LENGTH, WIDTH, ANGLE] = AEROSOL_METRIC(input, K)
%
% Purpose: 
% Variables:
%   {Parameters}
%   {Return}
%   AREA: 4-D array holding k cluster images
%   LENGTH: maximum length of the aerosol x-axis
%   WIDTH:  maximum width of the aerosol y-axis
%   ANGLE: angle calculated using the 
%--------------------------------------------------------------

[nrows, ncols] = size(input_map);


min_row = min(nrows);
max_row = max(ncols);
min_col = min(ncols); 
max_col = max(ncols);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
outline = ~logical(input_map);
[row1, col1] = find(outline,1,'first');
[row2, col2] = find(outline,1,'last');
LENGTH = col2 - col1 ;
WIDTH  = max_row - min_row;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = imgaussfilt(img,1.6);
A2 = rgb2hsv(A);
s = mat2gray(A2(:,:,2));
bw = ~im2bw(s, 0.05);
%%%%%%%%%%%%%%%%%%%%%%%%%%
AREA = sum(bw(:));
figure, imshow(bw)
%%%%%%%%%%%%%%%%%%%%%%%%%%



