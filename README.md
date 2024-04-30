# Research Project - *Aerosol Analysis*

Created by: **Hevander Da Costa**

**Aerosol Analysis** is a package designed in MATLAB for the quantitative analysis of aerosol plums and jets. The file `Jet_isolation.mlx` can be used to readily process raw images for background separtation, image smoothing, and image clustering. The package uses custome search-based and machine learning based algorithms for topographical analysis of plums, jets, or blobs. The various algorithms can be used to idenifity boundary velocities and sub cluster velocity characteristics; such as in a particle image velocity regime. This package was used for a study on risk analysis of various aerosol emission  [Link to PDF](https://onlinelibrary.wiley.com/doi/epdf/10.1111/ina.13064).



## Included Features

The following **required** functionality is completed:

- [X] Edge detection algorithm with variable threshhold of detection
- [X] Kmeans based image clustering with fluster percentage,
- [X] Plum/Jet metrics: width, length, areas
- [X] Boundary analysis of Aerosol for circumference 
- [X] Dijkstra's, Breath-first, Depth-first, AStar
- [X] Image segmentation and smoothing 

 
The following **future** features may implemented:

- [X] Graphing funcitonality for the percentage of various velocity ranges
- [X] Dynamic tracing of morphing contigous blobs
  - [X] bounding box method
  - [X] Edge detection and continous search algormithm verification for close fit
  

## Depth First Search - Video Walkthrough 
<img src='https://i.imgur.com/vhr4qox.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## Blob Test Depth First Search - Video Walkthrough
![DFSAlgo_SearchBlob-ezgif com-video-to-gif-converter](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/b400babe-8c20-4368-8ff4-c3d08ec81bca)

## Breath First Search - Video Walkthrough 
![BFS_SearchAlgo-ezgif com-video-to-gif-converter](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/116b050b-2545-4420-a7ab-f1fdf934eb9a)

## Blob Test Breath First Search - Video Walkthrough 
![Screen%20Recording%20-%20Apr%2029%2C%202024](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/1ea0e652-2dd2-43e2-bfe7-ca1f8df85bd4)

## Blob Test AStar - Video Walkthrough
![AStarAlgo_SearchBlob-ezgif com-video-to-gif-converter-2](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/0461e6c7-8125-43e0-bffc-280eb0dd4239)

## Blob Area and Edge - Video Walkthrough
![Screen%20Recording%20-%20Apr%2029%2C%202024-2](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/9ed50096-a316-4f16-89f8-2f3ec4c8c962)



% This LaTeX was auto-generated from MATLAB code.
% To make changes, update the MATLAB code and export to LaTeX again.

\documentclass{article}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{graphicx}
\usepackage{color}
\usepackage{hyperref}
\usepackage{amsmath}
\usepackage{amsfonts}
\usepackage{epstopdf}
\usepackage[table]{xcolor}
\usepackage{matlab}
\usepackage[paperheight=795pt,paperwidth=614pt,top=72pt,bottom=72pt,right=72pt,left=72pt,heightrounded]{geometry}

\sloppy
\epstopdfsetup{outdir=./}
\graphicspath{ {./Jet_Isolation_media/} }

\matlabmultipletitles

\begin{document}

\matlabtitle{Aerosol Jet Extraction}


\begin{matlabcode}
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
\end{matlabcode}

\matlabheadingtwo{Raw image procurement and display}


\begin{matlabcode}
folder = 'C:\Users\Lavision\Desktop\full_length\5x5 gaussian smoothing';
baseFileName = 'testing10001.png';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
% Check if file exists.
if ~exist(fullFileName, 'file')
  % File doesn't exist -- didn't find it there.  Check the search path for it.
  fullFileName = baseFileName; % No path this time.
  if ~exist(fullFileName, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end
\end{matlabcode}


\begin{matlabcode}
rgbImage = imread(fullFileName);
imshow(rgbImage)
\end{matlabcode}
\begin{center}
\includegraphics[width=\maxwidth{103.96387355745108em}]{figure_0.png}
\end{center}

\matlabheadingtwo{Crop extraneous and un-needed elements }


\begin{matlabcode}
% Crop image
targetSize = [193 218 368 312];
crop_rgbImage = imcrop(rgbImage,targetSize);
imshow(crop_rgbImage)
\end{matlabcode}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_1.png}
\end{center}

\matlabheadingtwo{Create mask to separate the distinct foreground from the  background}


\begin{matlabcode}
[mask, maskedRGBImage] = createMask(crop_rgbImage); 
mask = imfill(mask,8,'holes');
mask = bwareafilt(mask, 8); 
maskedRgbImage = bsxfun(@times, crop_rgbImage, cast(mask,class(crop_rgbImage)));
imshow(maskedRgbImage);
\end{matlabcode}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_2.png}
\end{center}


\begin{matlabcode}
imshow(maskedRGBImage);
\end{matlabcode}


\begin{matlabcode}
imshow(mask);
\end{matlabcode}

\matlabheadingtwo{Perform smoothing to reduce PIV LaVision mesh visibility }


\begin{matlabcode}
redChannel = maskedRgbImage(:, :, 1);
greenChannel = maskedRgbImage(:, :, 2);
blueChannel = maskedRgbImage(:, :, 3);
windowSize = 3;
kernel = ones(windowSize) / windowSize ^ 2;
% Blur the individual color channels.
smoothedPictureR = conv2(double(redChannel), kernel, 'same');
smoothedPictureG = conv2(double(greenChannel), kernel, 'same');
smoothedPictureB = conv2(double(blueChannel), kernel, 'same');
% Recombine separate color channels into a single, true color RGB image.
smoothrgbImage = uint8(cat(3, smoothedPictureR , smoothedPictureG, smoothedPictureB));
imshow(smoothrgbImage);
\end{matlabcode}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_3.png}
\end{center}


\matlabheadingtwo{Apply secondary mask to remove non contigous elements}

\begin{matlabcode}
im = im2double(smoothrgbImage);
im_mask = rgb2gray(im) > .14;
rgs = bwconncomp(im_mask);
[max_area, idx] = max(cellfun(@(x) numel(x), rgs.PixelIdxList));
mask = zeros(size(im_mask));
mask(rgs.PixelIdxList{idx}) = 1;
im(~mask(:,:,[1 1 1])==1) = 0;
imshow(im)
\end{matlabcode}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_4.png}
\end{center}


\matlabtitle{Image Segmentation}

\begin{itemize}
\setlength{\itemsep}{-1ex}
   \item{\begin{flushleft} Ensure intensity value does not erase the contigous plum \end{flushleft}}
   \item{\begin{flushleft} Convert black background to white \end{flushleft}}
   \item{\begin{flushleft} Perform K-Means clustering to seperate the velocity regions  \end{flushleft}}
\end{itemize}

\begin{matlabcode}
intensity_filter = .39;
I2 = im;
A = I2;
[row, col, xx] = size(A);
for i = 1:row;
    for j = 1:col;
        if(A(i,j,:) < intensity_filter);
            A(i,j,:) = 1;% 0 or 255
        end
    end
end
figure,imshow(A);
\end{matlabcode}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_5.png}
\end{center}
\begin{matlabcode}
A =im2double(A);
%disp(A);
k = 4;
imgCluster(A, k);
\end{matlabcode}
\begin{matlaboutput}
Iteration count = 1, obj. fcn = 5194.046270
Iteration count = 2, obj. fcn = 4985.634848
Iteration count = 3, obj. fcn = 3841.405363
Iteration count = 4, obj. fcn = 593.341804
Iteration count = 5, obj. fcn = 464.093095
Iteration count = 6, obj. fcn = 381.068093
Iteration count = 7, obj. fcn = 252.693105
Iteration count = 8, obj. fcn = 193.379913
Iteration count = 9, obj. fcn = 178.759906
Iteration count = 10, obj. fcn = 175.187501
Iteration count = 11, obj. fcn = 174.275472
Iteration count = 12, obj. fcn = 174.028405
Iteration count = 13, obj. fcn = 173.958375
Iteration count = 14, obj. fcn = 173.938019
Iteration count = 15, obj. fcn = 173.932022
Iteration count = 16, obj. fcn = 173.930243
Iteration count = 17, obj. fcn = 173.929713
Iteration count = 18, obj. fcn = 173.929554
Iteration count = 19, obj. fcn = 173.929507
Iteration count = 20, obj. fcn = 173.929493
Iteration count = 21, obj. fcn = 173.929489
\end{matlaboutput}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_6.png}
\end{center}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_7.png}
\end{center}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_8.png}
\end{center}
\begin{center}
\includegraphics[width=\maxwidth{55.09282488710487em}]{figure_9.png}
\end{center}
\begin{matlaboutput}
(:,:,1) =
  Columns 1 through 19
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 20 through 38
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 39 through 57
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 58 through 76
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 77 through 95
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 96 through 114
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 115 through 133
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 134 through 152
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 153 through 171
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 172 through 190
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 191 through 209
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 210 through 228
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 229 through 247
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 248 through 266
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 267 through 285
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 286 through 304
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 305 through 323
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 324 through 342
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 343 through 361
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 362 through 380
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 381 through 399
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 400 through 418
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 419 through 437
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 438 through 456
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 457 through 475
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 476 through 494
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 495 through 513
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 514 through 532
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 533 through 551
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 552 through 570
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 571 through 589
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 590 through 608
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 609 through 627
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 628 through 646
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 647 through 665
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 666 through 684
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 685 through 703
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 704 through 722
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 723 through 741
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 742 through 760
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 761 through 779
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 780 through 798
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 799 through 817
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 818 through 836
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 837 through 855
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 856 through 874
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 875 through 893
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 894 through 912
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 913 through 931
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 932 through 950
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 951 through 969
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 970 through 988
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 989 through 1,007
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,008 through 1,026
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,027 through 1,045
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,046 through 1,064
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,065 through 1,083
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,084 through 1,102
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,103 through 1,121
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,122 through 1,140
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,141 through 1,159
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,160 through 1,178
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,179 through 1,197
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,198 through 1,216
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,217 through 1,235
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,236 through 1,254
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,255 through 1,273
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,274 through 1,292
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,293 through 1,311
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,312 through 1,330
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,331 through 1,349
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,350 through 1,368
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,369 through 1,387
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,388 through 1,406
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,407 through 1,425
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,426 through 1,444
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,445 through 1,463
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,464 through 1,482
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,483 through 1,501
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,502 through 1,520
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,521 through 1,539
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,540 through 1,558
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,559 through 1,577
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,578 through 1,596
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,597 through 1,615
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,616 through 1,634
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,635 through 1,653
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,654 through 1,672
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,673 through 1,691
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,692 through 1,710
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,711 through 1,729
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,730 through 1,748
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,749 through 1,767
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,768 through 1,786
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,787 through 1,805
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,806 through 1,824
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,825 through 1,843
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,844 through 1,862
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,863 through 1,881
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,882 through 1,900
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,901 through 1,919
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,920 through 1,938
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,939 through 1,957
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,958 through 1,976
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,977 through 1,995
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 1,996 through 2,014
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,015 through 2,033
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,034 through 2,052
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,053 through 2,071
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,072 through 2,090
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,091 through 2,109
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,110 through 2,128
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,129 through 2,147
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,148 through 2,166
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,167 through 2,185
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,186 through 2,204
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,205 through 2,223
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,224 through 2,242
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,243 through 2,261
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,262 through 2,280
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,281 through 2,299
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,300 through 2,318
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,319 through 2,337
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,338 through 2,356
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,357 through 2,375
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,376 through 2,394
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,395 through 2,413
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,414 through 2,432
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,433 through 2,451
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,452 through 2,470
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,471 through 2,489
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,490 through 2,508
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,509 through 2,527
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,528 through 2,546
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,547 through 2,565
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,566 through 2,584
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,585 through 2,603
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,604 through 2,622
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,623 through 2,641
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,642 through 2,660
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,661 through 2,679
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,680 through 2,698
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,699 through 2,717
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,718 through 2,736
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,737 through 2,755
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,756 through 2,774
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,775 through 2,793
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,794 through 2,812
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,813 through 2,831
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,832 through 2,850
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,851 through 2,869
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,870 through 2,888
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,889 through 2,907
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,908 through 2,926
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,927 through 2,945
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,946 through 2,964
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,965 through 2,983
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 2,984 through 3,002
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,003 through 3,021
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,022 through 3,040
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,041 through 3,059
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,060 through 3,078
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,079 through 3,097
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,098 through 3,116
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,117 through 3,135
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,136 through 3,154
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,155 through 3,173
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,174 through 3,192
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,193 through 3,211
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,212 through 3,230
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,231 through 3,249
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,250 through 3,268
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,269 through 3,287
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,288 through 3,306
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,307 through 3,325
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,326 through 3,344
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,345 through 3,363
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,364 through 3,382
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,383 through 3,401
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,402 through 3,420
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,421 through 3,439
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,440 through 3,458
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,459 through 3,477
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,478 through 3,496
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,497 through 3,515
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,516 through 3,534
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,535 through 3,553
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,554 through 3,572
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,573 through 3,591
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,592 through 3,610
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,611 through 3,629
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,630 through 3,648
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,649 through 3,667
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,668 through 3,686
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,687 through 3,705
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,706 through 3,724
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,725 through 3,743
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,744 through 3,762
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,763 through 3,781
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,782 through 3,800
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,801 through 3,819
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,820 through 3,838
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,839 through 3,857
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,858 through 3,876
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,877 through 3,895
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,896 through 3,914
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,915 through 3,933
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,934 through 3,952
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,953 through 3,971
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,972 through 3,990
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 3,991 through 4,009
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,010 through 4,028
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,029 through 4,047
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,048 through 4,066
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,067 through 4,085
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,086 through 4,104
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,105 through 4,123
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,124 through 4,142
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,143 through 4,161
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,162 through 4,180
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,181 through 4,199
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,200 through 4,218
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,219 through 4,237
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,238 through 4,256
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,257 through 4,275
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,276 through 4,294
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,295 through 4,313
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,314 through 4,332
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,333 through 4,351
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,352 through 4,370
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,371 through 4,389
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,390 through 4,408
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,409 through 4,427
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,428 through 4,446
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,447 through 4,465
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,466 through 4,484
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,485 through 4,503
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,504 through 4,522
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,523 through 4,541
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,542 through 4,560
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,561 through 4,579
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,580 through 4,598
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,599 through 4,617
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,618 through 4,636
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,637 through 4,655
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,656 through 4,674
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,675 through 4,693
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,694 through 4,712
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,713 through 4,731
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,732 through 4,750
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,751 through 4,769
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,770 through 4,788
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,789 through 4,807
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,808 through 4,826
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,827 through 4,845
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,846 through 4,864
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,865 through 4,883
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,884 through 4,902
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,903 through 4,921
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,922 through 4,940
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,941 through 4,959
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,960 through 4,978
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,979 through 4,997
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 4,998 through 5,016
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,017 through 5,035
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,036 through 5,054
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,055 through 5,073
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,074 through 5,092
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,093 through 5,111
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,112 through 5,130
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,131 through 5,149
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,150 through 5,168
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,169 through 5,187
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,188 through 5,206
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,207 through 5,225
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,226 through 5,244
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,245 through 5,263
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,264 through 5,282
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,283 through 5,301
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,302 through 5,320
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,321 through 5,339
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,340 through 5,358
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,359 through 5,377
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,378 through 5,396
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,397 through 5,415
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,416 through 5,434
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,435 through 5,453
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,454 through 5,472
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,473 through 5,491
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,492 through 5,510
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,511 through 5,529
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,530 through 5,548
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,549 through 5,567
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,568 through 5,586
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,587 through 5,605
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,606 through 5,624
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,625 through 5,643
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,644 through 5,662
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,663 through 5,681
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,682 through 5,700
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,701 through 5,719
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,720 through 5,738
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,739 through 5,757
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,758 through 5,776
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,777 through 5,795
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,796 through 5,814
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,815 through 5,833
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,834 through 5,852
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,853 through 5,871
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,872 through 5,890
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,891 through 5,909
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,910 through 5,928
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,929 through 5,947
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,948 through 5,966
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,967 through 5,985
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 5,986 through 6,004
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,005 through 6,023
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,024 through 6,042
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,043 through 6,061
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,062 through 6,080
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,081 through 6,099
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,100 through 6,118
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,119 through 6,137
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,138 through 6,156
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,157 through 6,175
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,176 through 6,194
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,195 through 6,213
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,214 through 6,232
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,233 through 6,251
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,252 through 6,270
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,271 through 6,289
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,290 through 6,308
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,309 through 6,327
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,328 through 6,346
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,347 through 6,365
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,366 through 6,384
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,385 through 6,403
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,404 through 6,422
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,423 through 6,441
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,442 through 6,460
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,461 through 6,479
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,480 through 6,498
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,499 through 6,517
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,518 through 6,536
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,537 through 6,555
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,556 through 6,574
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,575 through 6,593
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,594 through 6,612
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,613 through 6,631
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,632 through 6,650
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,651 through 6,669
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,670 through 6,688
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,689 through 6,707
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,708 through 6,726
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,727 through 6,745
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,746 through 6,764
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,765 through 6,783
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,784 through 6,802
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,803 through 6,821
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,822 through 6,840
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,841 through 6,859
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,860 through 6,878
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,879 through 6,897
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,898 through 6,916
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,917 through 6,935
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,936 through 6,954
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,955 through 6,973
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,974 through 6,992
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 6,993 through 7,011
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,012 through 7,030
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,031 through 7,049
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,050 through 7,068
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,069 through 7,087
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,088 through 7,106
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,107 through 7,125
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,126 through 7,144
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,145 through 7,163
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,164 through 7,182
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,183 through 7,201
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,202 through 7,220
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,221 through 7,239
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,240 through 7,258
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,259 through 7,277
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,278 through 7,296
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,297 through 7,315
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,316 through 7,334
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,335 through 7,353
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,354 through 7,372
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,373 through 7,391
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,392 through 7,410
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,411 through 7,429
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,430 through 7,448
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,449 through 7,467
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,468 through 7,486
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,487 through 7,505
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,506 through 7,524
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,525 through 7,543
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,544 through 7,562
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,563 through 7,581
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,582 through 7,600
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,601 through 7,619
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,620 through 7,638
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,639 through 7,657
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,658 through 7,676
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,677 through 7,695
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,696 through 7,714
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,715 through 7,733
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,734 through 7,752
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,753 through 7,771
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,772 through 7,790
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,791 through 7,809
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,810 through 7,828
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,829 through 7,847
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,848 through 7,866
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,867 through 7,885
     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
  Columns 7,886 through 7,904
     1 ...
\end{matlaboutput}



\vspace{1em}
\begin{matlabcode}
function [BW,maskedRGBImage] = createMask(RGB)

I = rgb2hsv(RGB);

channel1Min = 0.972;
channel1Max = 0.711;

channel2Min = 0.087;
channel2Max = 1.000;

channel3Min = 0.179;
channel3Max = 1.000;

sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
	(I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
	(I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
maskedRGBImage = RGB;

maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end
\end{matlabcode}

\end{document}








