%solution of the equltion x^n-1=0
function levmar_method(n,mu)
    if nargin<2
        mu=0.00;
    end
    if nargin<1
        n=3;
    end
    close all;
    tol=1e-3;%set the precision
    h=0.2;
    axis_array =[-10,10,-10,10];
    x1=axis_array(1):h:axis_array(2);
    y1=axis_array(3):h:axis_array(4);

    m=length(x1);
    imp=zeros(m);
    tic
    for ik=1:m
        for jk=1:m
            x0=x1(ik)+1i*y1(jk);%change into complex number
            iter=1;
            while iter<255
                cost=x0^n-0.01;
                eps_er=0-cost;
%                 fprintf('iter=%d,cost=%f\n',iter,cost);
%                 pause(0.01);
                grad=n*x0^(n-1);
                J=grad';mn=size(J,2);
                xk=x0-(mu*eye(mn)+J'*J)\J'*eps_er;
                iter=iter+1;
                if norm(eps_er)<tol
                    break;
                end
                x0=xk;
            end
            imp(ik,jk)=iter;
        end
    end
    
    figure;%%¡¡figure1=====================================================
    axis(axis_array);
    scale=max(max(imp))/(n/1.5);
    imp=imp/scale;
    imshow(imp);
    axis off;

    % figure;%%¡¡figure2===================================================
    % axis([-10,10,-10,10]);
    % imp=uint8(imp*40);
    % image(imp);
    % axis off;
    toc
end