% created on 2016-04-23. The second example for matopt which introduced in
% my master thesis
clc;
clear;
close all;
addpath(genpath('manopt'));% import the manifold optimization tool manopt
addpath(genpath('matvisual'));% import the matrix visualization tool matvisual
load('toy_data');
%initializing training structure
n_trn=200;
bound=1:n_trn;
SPDs = covD_Struct.trn_X(:,:,bound);
% trn_y = covD_Struct.trn_y(bound);
m=size(SPDs,1);
W = randn(m);
A0=expm(0.2*(W+W')); % 0.2 can be tuned
% compute the square root of spd samples
R=zeros(m,m,n_trn);
invR=zeros(m,m,n_trn);
for k=1:n_trn
    R(:,:,k)=sqrtm(SPDs(:,:,k));
    invR(:,:,k)=eye(m)/R(:,:,k);
end

% gradient check
option.gd_check=true;
option.mode=0;
% start
Check_Times=10;
Check_tolarence=1e-3;% please tune this according to the step set in grad_check()
av_error=grad_check(@SPDKarcherMean_CostGrad,A0,Check_Times,SPDs,R,invR,option);
if av_error>Check_tolarence
    error('gradient check average error is:%f,which is out of tolarence(%f).\n',av_error,Check_tolarence);
else
    fprintf('gradient check average error is:%f,gradient check passed!\n',av_error);
end
option.gd_check=false;

% optimization
fprintf('\n========================Optimization Part=====================\n');
problem.M=sympositivedefinitefactory(m);
problem.costgrad=@(A0) SPDKarcherMean_CostGrad(A0,SPDs,R,invR,option);
CJoption.maxiter=50;% this option set for conjugate gradient descend method in manopt
A_opt=conjugategradient(problem,A0,CJoption);
% A_stand = positive_definite_karcher_mean(SPDs);
% save('toydata_KarcherMean_standard','A_stand');
% visualization
scale=10;
load('toydata_KarcherMean_standard');
imA_stand=visualize_mat(A_stand);
imA_stand=mosaic(imA_stand,scale);
imA_bf=visualize_mat(A0);
imA_bf=mosaic(imA_bf,scale);
imA_af=visualize_mat(A_opt);
imA_af=mosaic(imA_af,scale);
% show
figure
imshow(imA_stand);
title('A_{stand}');
figure
imshow(imA_bf);
title('A_{init}');
figure
imshow(imA_af);
title('A_{opt}');