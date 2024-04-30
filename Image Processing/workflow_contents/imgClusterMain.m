clear;clc;
A = imread('image_name.png');
A = imgaussfilt(A,1);
thresh = 1;
idx = abs(A(:,:,1)-A(:,:,2))<=thresh& abs(A(:,:,2)-A(:,:,3))<=thresh;
figure(2);imshow(idx)
[x1, y1, z1] = size(A);
I2 = A;
%mean_array = []
for x = 1:x1
    for y = 1:y1
        for z = 1:z1
            if I2(x,y) == 1 %==idx
                % mean
                I2(x,y,z) = 255; % 0 or 255
            else
                I2(x,y,z) = I2(x,y,z);
            end
        end
    end
end
A = I2;
[row, col, xx] = size(A);
for i = 1:row
    for j = 1:col
        if(A(i,j,:) < 25)
            A(i,j,:) = 255;% 0 or 255
        end
    end
end
figure,imshow(A);
A =im2double(A);
%disp(A);
k = 4;
imgCluster(A, k);
