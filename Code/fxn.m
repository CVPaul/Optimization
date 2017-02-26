% create on 2016-01-19, optimal on the straw hat function 
function [z,zn,x,y]=fxn(a,b)
close all;
if nargin <2
    b=1.5;
end
if nargin <1
    a=1.3;
end
X=-8:0.5:8;
Y=-8:0.5:8;
[x,y]=meshgrid(X,Y);
x=a.*x;y=b.*y;
z=fx(x,y);
[m,n]=size(z);
n=randn(m,n)*0.05;
zn=z+n;
figure
hold on
mesh(x,y,z);
scatter3(x(:),y(:),zn(:),'.r');
hold off