%solution of the equltion x^n-1=0
function newton_method(n)
    if nargin<1
        n=3;
    end
    close all;
    pre=1e-10;%set the precision
    h=0.002;
    axis_array =[-1,1,-1,1];
    x1=axis_array(1):h:axis_array(2);
    y1=axis_array(3):h:axis_array(4);

    m=length(x1);
    imp=zeros(m);
    tic
    for ik=1:m
        for jk=1:m
            x0=x1(ik)+1i*y1(jk);%change into complex number
            iter=1;
            while iter<500 && x0~=0
                xk=x0-(x0^n-0.01)/(n*x0^(n-1));%newton function;
                iter=iter+1;
                if abs(xk-x0)<pre
                    break;
                end
                x0=xk;
            end
            imp(ik,jk)=iter;
        end
    end

    figure;%%¡¡figure1=========================================================
    axis(axis_array);
    scale=max(max(imp))/(n/2.6);
    imp=imp/scale;
    imshow(imp);
    axis off;

    % figure;%%¡¡figure2=========================================================
    % axis([-10,10,-10,10]);
    % imp=uint8(imp*40);
    % image(imp);
    % axis off;
    toc
end