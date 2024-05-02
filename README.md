# Research Project - *Aerosol Analysis*

Created by: **Hevander Da Costa**

## Table of Contents

1. [Overview](#Overview)
2. [Features](#Features)
3. [Updates](#Updates)
4. [DFS Implementation](#DFS-Implementation)
5. [BFS Implementation](#BFS-Implementation)
6. [AStar Implementation](#AStar-Implementation)
7. [Edge and Area Detection](#Edge-And-Area-Detection)
8. [Image Preprocessing](#Image-Preprocessing)






## Overview
**Aerosol Analysis** is a package designed in MATLAB for the quantitative analysis of aerosol plums and jets. The file `Jet_isolation.mlx` can be used to readily process raw images for background separtation, image smoothing, and image clustering. The package uses custome search-based and machine learning based algorithms for topographical analysis of plums, jets, or blobs. The various algorithms can be used to idenifity boundary velocities and sub cluster velocity characteristics; such as in a particle image velocity regime. This package was used for a study on risk analysis of various aerosol emission  [Link to PDF](https://onlinelibrary.wiley.com/doi/epdf/10.1111/ina.13064).



## Features

The following **required** functionality is completed:

- [X] Edge detection algorithm with variable threshhold of detection
- [X] Kmeans based image clustering with fluster percentage,
- [X] Plum/Jet metrics: width, length, areas
- [X] Boundary analysis of Aerosol for circumference 
- [X] Dijkstra's, Breath-first, Depth-first, AStar
- [X] Image segmentation and smoothing 

 
## Updates
The following **future** features may be implemented:

- [X] Graphing funcitonality for the percentage of various velocity ranges
- [X] Dynamic tracing of morphing contigous blobs
  - [X] bounding box method
  - [X] Edge detection and continous search algormithm verification for close fit
  

## DFS-Implementation
**Depth First Search - Video Walkthrough** 


<img src='https://i.imgur.com/vhr4qox.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

**Blob Test Depth First Search - Video Walkthrough**


![DFSAlgo_SearchBlob-ezgif com-video-to-gif-converter](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/b400babe-8c20-4368-8ff4-c3d08ec81bca)

## BFS Implementation
**Breath First Search - Video Walkthrough**


![BFS_SearchAlgo-ezgif com-video-to-gif-converter](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/116b050b-2545-4420-a7ab-f1fdf934eb9a)

## Blob Test Breath First Search - Video Walkthrough 
![Screen%20Recording%20-%20Apr%2029%2C%202024](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/1ea0e652-2dd2-43e2-bfe7-ca1f8df85bd4)

## AStar Implementation
**Blob Test AStar - Video Walkthrough**


![AStarAlgo_SearchBlob-ezgif com-video-to-gif-converter-2](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/0461e6c7-8125-43e0-bffc-280eb0dd4239)

## Edge and Area Detection
**Blob Area and Edge - Video Walkthrough**


![Screen%20Recording%20-%20Apr%2029%2C%202024-2](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/9ed50096-a316-4f16-89f8-2f3ec4c8c962)

## Image Preprocessing
**Blob image isolation, smoothing and clustering**
https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/951887b8-ef4e-474a-9296-b1597edc0939

![Screen%20Recording%20-%20May%201%2C%202024](https://github.com/Hevander27/BoundaryAnalysis/assets/45948489/be9dcb4c-05c4-4d31-8289-1a912bde9dd6)






