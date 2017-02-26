% created on 2016-04-20, to compute the Direction Gradient D_{X}f(X)[H]
function DG=DirectionGradient(F,U,H,invU)
% input: F- difference matrix of eigvalues
%        U- diagonalize matrix of A:A=U
%           diag(\lambda_1,\lambda_2,...,\lambda_d) invU
%        invU- diagonalize matrix of A:A=U
%           diag(\lambda_1,\lambda_2,...,\lambda_d) invU
%        H- the direction
    if nargin<4
        invU=U';
        warning('treat the matrix as symmetric matrix,please check the input\n otherwise you may get the wrong anwser.\n');
    end
    Hj=invU*H*U;
    DG=U*(Hj.*F)*invU;
end