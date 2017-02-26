% created on 2016-04-22. The first example for matopt which introduced in
% my master thesis
clc;
clear;
close all;
addpath(genpath('manopt'));% import the manifold optimization tool manopt
addpath(genpath('matvisual'));% import the matrix visualization tool matvisual
% option
option.n=4.0; %define the parameter of Power operator
option.alpha=1.0/option.n;

% generate the symmetric Semi-Definite Positive Matrices:C1,C2
sz=[30,20];% define the dimention of W1 W2
W1=randn(sz);C1=W1*W1'; 
W2=randn(sz);C2=W2*W2';

% gradient check
Check_Times=100;
Check_tolarence=1e-3;% please tune this according to the step set in grad_check()
W=randn(sz(1),sz(1));Z0=expm(0.05*(W+W')); % initialize point setting.0.2 can be tuned 

option.gd_check=true; % start gradient check;
av_error=grad_check(@example01_CostGrad,Z0,Check_Times,C1,C2,option);
if av_error>Check_tolarence
    error('gradient check average error is:%f,which is out of tolarence(%f).\n',av_error,Check_tolarence);
else
    fprintf('gradient check average error is:%f,gradient check passed!\n',av_error);
end
option.gd_check=false;

% optimization
fprintf('\n========================Optimization Part=====================\n');
problem.M=sympositivedefinitefactory(sz(1));
problem.costgrad=@(Z)example01_CostGrad(Z,C1,C2,option);
CJoption.maxiter=50;% this option set for conjugate gradient descend method in manopt
Z_opt=conjugategradient(problem,Z0,CJoption);

% visualization
scale=10;
imZ_bf=visualize_mat(Z0);
imZ_bf=mosaic(imZ_bf,scale);
imZ_af=visualize_mat(Z_opt);
imZ_af=mosaic(imZ_af,scale);
figure
imshow(imZ_bf);
title('Z_{init}');
figure
imshow(imZ_af);
title('Z_{opt}');