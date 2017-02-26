% created on 2016-04-10 for minFunc axample: the rosebrock function,this
% script will draw the 2D rosebrock
close all;
clear;
clc;
%f = sum(100*(x(2:D)-x(1:D-1).^2).^2 + (1-x(1:D-1)).^2);
step=0.05;
y=-0.5:step:3.0;
x=-2.0:step:2.0;
[X,Y]=meshgrid(x,y);
Z=100*(Y-X.^2).^2+(1-X).^2;
mesh(X,Y,Z);