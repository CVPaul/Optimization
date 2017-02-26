% created on 2016-04-20, this function implement the same functionality of 
% generSymm_SVD.m, the difference is that this function take user data (matrix)
% as input while generSymm_SVD.m generate matrix with rand function
function [imMat,imU,imS,imVT]=visualize_SVD_Decomposition(Mat,option)
% input; Mat- the user input data
%        option- set some parameter for svd decompostion
% output: imMat- convert from Mat for visualization convenience 
%         imU- convert from Mat's svd decompostion:[Mat=USV'] for 
%               visualization convenience 
%         imS- convert from Mat's svd decompostion:[Mat=USV'] for 
%               visualization convenience 
%         imV- convert from Mat's svd decompostion:[Mat=USV'] for 
%               visualization convenience 
    [m,n,ch]=size(Mat);
    % preprocessing
    channels=3; % all the output will be represented  with a 3 channale image
    if ch~=1&&ch~=3
        error('the function only take 1 and 3 channels mat as input!\n');
    end
    % scale
    maxv=max(Mat(:));minv=min(Mat(:));
    if maxv==minv
        Mat(:,:,:)=0;
    end
    Mat=(Mat-minv)./(maxv-minv);
    % channel
    if ch==1
        if option.mode==0
            [U,S,V]=svd(Mat);
        elseif option.mode==1;
            [U,S,V]=svd(Mat,'econ');
        end
        imMat=zeros(m,n,channels);
        imU=zeros([size(U),channels]);
        imS=zeros([size(S),channels]);
        imVT=zeros([size(V'),channels]);
        for j=1:channels
            imMat(:,:,j)=Mat;imU(:,:,j)=U;
            imS(:,:,j)=S;imVT(:,:,j)=V';
        end
    else
        imMat=Mat;
        if option.mode==0
            [U,S,V]=svd(imMat(:,:,1));
        elseif option.mode==1;
            [U,S,V]=svd(imMat(:,:,1),'econ');
        end
        imU=zeros([size(U),channels]);
        imS=zeros([size(S),channels]);
        imVT=zeros([size(V'),channels]);
        imU(:,:,1)=U;imVT(:,:,1)=V';
        imS(:,:,1)=S;
        for j=2:channels
            if option.mode==0
                [U,S,V]=svd(imMat(:,:,j));
            elseif option.mode==1;
                [U,S,V]=svd(imMat(:,:,j),'econ');
            end
            imU(:,:,j)=U;imVT(:,:,j)=V';
            imS(:,:,j)=S;
        end
    end        
end