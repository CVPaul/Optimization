% split gif images
i=1;
while 1
    image = imread('NewtonIteration_Ani.gif', i);
    ind=find(image>100);
    image(ind)=255;
    if isempty(image)||i==18
        break;
    else
        filename = ['NewtonIteration_Ani\\' int2str(i-1) '.jpg'];
        imwrite(image, filename);
        i=i+1;
    end
end