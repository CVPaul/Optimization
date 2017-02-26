% created on 2016-04-23, to compute the cost and gradient of example 01
% which is showed in my master thesis (second chapter)
function [cost,grad]=example01_CostGrad(Z,C1,C2,option)
    % function definition
    symm=@(X) 0.5*(X+X');
    g1=@(Z) (C1+Z)*(C1+Z)';
    g2=@(Z) (C2+Z)*(C2+Z)';
    fun=@(x) x.^(option.alpha);
    dfun=@(x) option.alpha.*x.^(option.alpha-1);
    
    % compute Direction Gradient Struct
    Z_g1=g1(Z); 
    C1_S=DirectionGradient_Construct(fun,dfun,Z_g1);
    Z_g2=g2(Z); 
    C2_S=DirectionGradient_Construct(fun,dfun,Z_g2);
    
    % compute cost grad
    Zf_g1=C1_S.U*diag(fun(C1_S.s))*C1_S.invU;
    Zf_g2=C2_S.U*diag(fun(C2_S.s))*C2_S.invU;
   
    cost=Zf_g1(:)'*Zf_g2(:);
    grad=2*symm(DirectionGradient(C1_S.F,C1_S.U,Zf_g2,C1_S.invU))*(C1+Z)+...
        2*symm(DirectionGradient(C2_S.F,C2_S.U,Zf_g1,C2_S.invU))*(C2+Z);
    if ~option.gd_check
        grad=Z*grad*Z; % from euclidean gradient to riemannian gradient
    end
%                       since gradient check is designed for
%                       checking on Euclidean space. so please uncomment
%                       this after gradient check
end