% modified on 2016-04
clc;
clear;

load('toy_data');
%initializing training structure
n_trn=200;
bound=1:n_trn;
trn_X = covD_Struct.trn_X(:,:,bound);
trn_y = covD_Struct.trn_y(bound);
m=size(trn_X,1);
U = randn(m);
A0=expm(0.2*(U+U'));
% A0=U*U';
R=zeros(m,m,n_trn);
invR=zeros(m,m,n_trn);
for k=1:n_trn
    R(:,:,k)=sqrtm(trn_X(:,:,k));
    invR(:,:,k)=eye(m)/R(:,:,k);
end
av_error=grad_check(@example01_CostGrad,A0,10,R,invR);
% av_error=grad_check(@MinVar_CostGrad,A0,10,R,invR);
fprintf('avarage error is %f\n',av_error);