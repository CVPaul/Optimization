% created on 2016-04-23, for matrix visualization
function imMat=visualize_mat(Mat)
% input; Mat- the user input data
% output:imMat- convert from Mat for visualization convenience
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
        imMat=zeros(m,n,channels);
        for c=1:channels
            imMat(:,:,c)=Mat;
        end
    else
        imMat=Mat;
    end
end