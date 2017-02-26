% created on 2016-04-14,for Low-Rank PSD matrix show time
function PSD_Visualization_examples
% global commands:
%     clear;    close all;    clc;
% global paprameters:
    sz=20;    scale=10;    channels=3;   dim=10;
% core part of the function body
    [imA,imU,imS,imUT]=generSymm_SVD(sz,channels);
    %=======================Extract Operation==============================
    imA_sub=zeros(sz,sz,channels);
    imU_sub=zeros(sz,dim,channels);
    imS_sub=zeros(dim,dim,channels);
    imUT_sub=zeros(dim,sz,channels);
    
    imA_Rt=zeros(sz,sz,channels);
    imZ=rand(sz,sz,channels);
    imZT=rand(sz,sz,channels);
    imW=zeros(sz,dim,channels);
    imWT=zeros(dim,sz,channels);
    for ch=1:channels
        imU_sub(:,:,ch)=imU(:,1:dim,ch);
        imS_sub(:,:,ch)=imS(1:dim,1:dim,ch);
        imUT_sub(:,:,ch)=imU_sub(:,:,ch).';
        imA_sub(:,:,ch)=imU_sub(:,:,ch)*imS_sub(:,:,ch)*imUT_sub(:,:,ch);
        % add on 2016-04-16 for power_metric and PSD encoding
        Rt=diag(diag(imS(:,:,ch)).^(0.5));
        imA_Rt(:,:,ch)=imU(:,:,ch)*Rt*imUT(:,:,ch);
        imW(:,:,ch)=(imA_Rt(:,:,ch)+imZ(:,:,ch))*imU_sub(:,:,ch);
        imWT(:,:,ch)=imW(:,:,ch).';
        imZT(:,:,ch)=imZ(:,:,ch).';
    end
    imA=mosaic(imA,scale);  imA_sub=mosaic(imA_sub,scale);
    imU=mosaic(imU,scale);  imU_sub=mosaic(imU_sub,scale);
    imS=mosaic(imS,scale);  imS_sub=mosaic(imS_sub,scale);
    imUT=mosaic(imUT,scale);  imUT_sub=mosaic(imUT_sub,scale);
     % add on 2016-04-16 for power_metric and PSD encoding
    imA_Rt=mosaic(imA_Rt,scale);imZ=mosaic(imZ,scale);
    imW=mosaic(imW,scale);imWT=mosaic(imWT,scale);
    %======================================================================
% show the result
% Original
    figure
    imshow(imA);
    title('C_i');
    figure
    imshow(imU);
    title('U_i');
    figure
    imshow(imS)
    title('\Lambda_i');
    figure
    imshow(imUT);
    title('U^T_i');    
% Sub
    figure
    imshow(imA_sub);
    title('Z_i');
    figure
    imshow(imU_sub);
    title('Y_i');
    figure
    imshow(imS_sub)
    title('R_i^2');
    figure
    imshow(imUT_sub);
    title('Y_i^T');    
% add on 2016-04-16 for power_metric and PSD encoding
    figure
    imshow(imA_Rt);
    title('C_{i}^{(1/2)}');
    figure
    imshow(imZ);
    title('Z');
    figure
    imshow(imZ);
    title('Z^{T}');
    figure
    imshow(imW);
    title('W_i');
    figure
    imshow(imWT);
    title('W^{T}_{i}');
end
