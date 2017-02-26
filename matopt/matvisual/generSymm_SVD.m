% created on 2016-04-14
function [imA,imU,imS,imUT]=generSymm_SVD(sz,channels)
% input: sz- the size of the Symmetric matrix that wan to show
%        channel- the defualt is 3, represent RGB channels
% output:imA- the random generate symmetric matrix
%        imU- matrix U of A's svd decomposition
%        imS- eigvalue matric of A's svd decomposition
%        imUT- the transpose of imU
    if nargin<2
        channels=3;
    end
    imA=ones(sz,sz,channels);
    imU=ones(sz,sz,channels);
    imUT=ones(sz,sz,channels);
    imS=ones(sz,sz,channels);
    for ch=1:channels
        W=rand(sz);
        A=0.5*(W+W');
        [AU,AS]=svd(A);
        imA(:,:,ch)=A;
        imU(:,:,ch)=AU;
        imS(:,:,ch)=AS;
        imUT(:,:,ch)=AU.';
    end
end