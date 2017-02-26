% created on 2016-04-14
function mosaic_im=mosaic(im,scale)
% input: im- the orignal image
%        scale- the size of the mosaic,must be square
% outpur: mosiac_im- each mosaic represent one pixel in im
    [m,n,channels]=size(im);
    B=zeros(m,n*scale);
    mosaic_im=zeros(m*scale,n*scale,channels);
    for ch=1:channels
        A=im(:,:,ch);
        for i=1:n
            for j=1:scale
                B(:,(i-1)*scale+j)=A(:,i);
            end
        end
        for i=1:m
            for j=1:scale
                mosaic_im((i-1)*scale+j,:,ch)=B(i,:);
            end
        end
    end
end