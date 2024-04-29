function [imgArray, pcntImg] = imgCluster(img, k, display)
%IMGCLUSTER Image data clustering using fuzzy c-means cluster.
%
% Author: Hevander Da Costa
% Date: 03/24/2022
% 
% Function: 
%   [IMGARRAY, PCTIMG] = IMGCLUSTER(IMG, K)
%
% Purpose:
%   Converts image matrix to double matrix 
%   Outputs the k integer number of clusters from the image data matrix 
%   IMG and respective cluster fractions. IMG is of row-column size M-by-N. 
%   Nested loops to iterate through all of U to populate the reference array
%   Nested loops to iterate through the reference array k times and
%   populate a temporary array to be displayed. 
%
% Variables:
%   {Parameters}
%   IMG: image matrix data
%   K: number of clusters to partition original image
%   VARARGIN: optional varaiable to display cluster images
%   {Return}
%   IMGARRAY: 4-D array holding k cluster images
%   PCTIMG: array containing percent of each cluster
%--------------------------------------------------------------
%   U: Element U(p,i) indicates the degree of membership of the
%      ith data point in the pth cluster. 
%   
% See also FCM
img =im2double(img);                   % Convert unit8 image to double
[row, col, xx] = size(img);            % Gets the size of the image
big = row*col;                         % Shapes image data for fcm use
data = reshape(img,big,[]);            % reshapes image layers to M*N-by-3
[~, U] = fcm(data, k, 1.2);            % returns fuzzy partition matrix [2.8 100]
[ref] = big;                           % Initialize cluster group reference array

for i = 1:(big)
    for p = 1:k
        if(U(p,i) == max(U(:,i)))
            ref(i) = p;
        end
    end
end
ref = reshape(ref,row,[]);            % reshape array to match image size  
pcntImg = zeros(1,k);                 % initialize cluster percent array
imgArray = zeros(row,col,xx,k);       % initialize 4D array to hold images

    for m = 1:k
        temp = zeros(row,col,3);%    
        for n = 1:row
            for o = 1:col
                if(ref(n,o) == m)
                    temp(n,o,:) = img(n,o,:);
                    imgArray(:,:,:,m) = temp;
                    pcntImg(m) = nnz(temp)/nnz(img);
                end
            end
        end
        % Opens k windows with the image data from the temp array
        if nargin == 3  
            if strcmp('display',display)
                figure,imshow(temp, []);
                txt = sprintf('%.3f', pcntImg(m));
                title(['Cluster Percent: ',txt]);
            elseif ~strcmp('display',display)
                error('Error: Incorrect argument, please type "display".');
            end
        end
    end
end
    