% create on 2016-01-19, for levmar test whith example function f(x0) =
% p[1]*exp(p[2]*x)
function levmar_test(method)
    if nargin<1
        method='grad';
    end
%     close all;
    maxiter=500;
    mu=0.0;tol=1e-6;
    x=-1:0.02:1;
    p=[0.5,0.1];
    len=length(x);
    yn=expfunc(x,p);
    h=0.02;
    axis_array =[-1,1,-1,1];
    x1=axis_array(1):h:axis_array(2);
    y1=axis_array(3):h:axis_array(4);
    m=length(x1);
    imp=zeros(m);
    switch method
    %% levmar method test=========================================
        case char('levmar')
            tic
            for ik=1:m
                for jk=1:m
                    iter=1;
                    x0=[x1(ik);y1(jk)];%change into complex number
                    while iter<maxiter
                        y=expfunc(x,x0);
                        eps_er=yn-y;
%                         cost=fx(yn,x,x0);
%                         fprintf('iter=%d,cost=%f\n',iter,cost);
%                         pause(0.1);
                        J=jacob(x,x0);
                        tmp=(mu+sum(J.*J));
                        ml=size(J,1);
                        temp2=repmat(tmp,ml,1);
                        xk=x0+(J./temp2)*eps_er'/len;
                        iter=iter+1;
                        if norm(eps_er)<tol
                            break;
                        end
                        x0=xk;
                    end
        %             fprintf('iter=%d,param p=(%f,%f)\n',iter,x0(1),x0(2));
                    imp(ik,jk)=iter;
                end
            end
            toc;
    %% end of levmar method test and start of gradient method test
        case char('grad') %use gradient method as reference
            tic
            for ik=1:m
                for jk=1:m
                    iter=1;
                    x0=[x1(ik);y1(jk)];%change into complex number
                    while iter<maxiter
                        y=expfunc(x,x0);
                        eps_er=yn-y;
%                         cost=fx(yn,x,x0);
%                         fprintf('iter=%d,cost=%f\n',iter,cost);
%                         pause(0.1);
                        grad=dfx(yn,x,x0);
                        xk=x0-grad;
                        iter=iter+1;
                        if norm(eps_er)<tol
                            break;
                        end
                        x0=xk;
                    end
        %             fprintf('iter=%d,param p=(%f,%f)\n',iter,x0(1),x0(2));
                    imp(ik,jk)=iter;
                end
            end
            toc;
        otherwise
            warning('this kind of method is not implemented!\n');
    end
    %% ==========================================================
    max_=max(max(imp));
    mean_=mean(mean(imp));
    fprintf('max iter is:%d,mean iter=%d\n',max_,mean_);
    % ==========================================================
    figure;%%¡¡figure 1================================================
    axis(axis_array);
    scale=maxiter;
    imp=imp/scale;
    imshow(imp);
    axis off;

    % figure;%%¡¡figure 2==================================================
    % axis([-10,10,-10,10]);
    % imp=uint8(imp*40);
    % image(imp);
    % axis off;
end
function y=expfunc(x,p)
    y=p(1).*exp(-p(2).*x);
end
function J=jacob(x,p)
    J=exp(-p(2).*x);
    J=[J;-p(1).*x.*exp(-p(2).*x)];
end
function cost=fx(yn,x,x0)
    y=expfunc(x,x0);
    eps_er=yn-y;
    len=length(x);
    cost=0.5*(eps_er*eps_er')/len;
end
function grad=dfx(yn,x,x0)
    y=expfunc(x,x0);
    eps_er=y-yn;
    J=jacob(x,x0);
    len=length(x);
    grad=(J*eps_er')/len;
end
function H=get_H(yn,x,x0)
    len=length(x);
    y=expfunc(x,x0);
    eps_er=y-yn;
    J=jacob(x,x0);
    fp1=J(1,:);
    fp2=J(2,:);
    fp1p1=0;
    fp1p2=-x.*exp(-x0(2).*x);
    fp2p2=x0(1).*(x.^2).*exp(-x0(2).*x);
    a11=fp1.^2+eps_er.*fp1p1;
    a12=fp1.*fp2+eps_er.*fp1p2;
    a22=fp2.^2+eps_er.*fp2p2;
    a11=sum(a11)/len;
    a12=sum(a12)/len;
    a22=sum(a22)/len;
    a21=a12;
    H=[a11,a12;a21,a22];
end
function [cost,grad]=the_costgrad(x0,yn,x)
    ind=2;
    cost_all=dfx(yn,x,x0);
    cost=cost_all(ind);
    H=get_H(yn,x,x0);
    grad=H(:,ind);
end