% on 2016-01-18,for gradient check
function grad_check_main
    theta = randn(2,1)*0.1;
    x=-1:0.02:1;
    p=[0.5;0.1];
    yn=expfunc(x,p);
    av_error=grad_check(@the_costgrad,theta(:),100,yn,x);
    fprintf('avarage error is %f\n',av_error);
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
%     cost=fx(yn,x,x0);
%     grad=dfx(yn,x,x0);
    ind=1;
    cost_all=dfx(yn,x,x0);
    cost=cost_all(ind);
    H=get_H(yn,x,x0);
    grad=H(:,ind);
end