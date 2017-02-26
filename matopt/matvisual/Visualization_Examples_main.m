% created on 2016-04-20, some examples of SVD decompostion visualization
clc;
clear;
close all;
% examples 01-03
m=20;n=30; scale=10;
A=500*rand(m,n);
B=500*rand(n,m);
C=500*rand(m,n,3);
option.mode=1; % 0 - normal mode; 1- economy mode
% eample of matrix A
[imA,imA_U,imA_S,imA_VT]=Visualize_SVD_Decomposition(A,option);
% mosiac operation
imA=mosaic(imA,scale); imA_U=mosaic(imA_U,scale);
imA_S=mosaic(imA_S,scale); imA_VT=mosaic(imA_VT,scale);
% drawing A
figure
imshow(imA);
title('A (econ)');
figure
imshow(imA_U);
title('U of A (econ)');
figure
imshow(imA_S)
title('S of A (econ)');
figure
imshow(imA_VT);
title('V^{T} of A (econ)');
% eample of matrix B
[imB,imB_U,imB_S,imB_VT]=Visualize_SVD_Decomposition(B,option);
% mosiac operation
imB=mosaic(imB,scale); imB_U=mosaic(imB_U,scale);
imB_S=mosaic(imB_S,scale); imB_VT=mosaic(imB_VT,scale);
% drawing A
figure
imshow(imB);
title('B (econ)');
figure
imshow(imB_U);
title('U of B (econ)');
figure
imshow(imB_S)
title('S of B (econ)');
figure
imshow(imB_VT);
title('V^{T} of B (econ)');
% eample of matrix C
[imC,imC_U,imC_S,imC_VT]=Visualize_SVD_Decomposition(C,option);
% mosiac operation
imC=mosaic(imC,scale); imC_U=mosaic(imC_U,scale);
imC_S=mosaic(imC_S,scale); imC_VT=mosaic(imC_VT,scale);
% drawing A
figure
imshow(imC);
title('C (econ)');
figure
imshow(imC_U);
title('U of C (econ)');
figure
imshow(imC_S)
title('S of C (econ)');
figure
imshow(imC_VT);
title('V^{T} of C (econ)');
% example 04
% example of Low/Fixed Rank symmetric Positive Semi-Definite matrix
PSD_Visualization_examples;