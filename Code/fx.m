% create on 2016-01-18, optimal on the straw hat function 
function z=fx(x,y)
% X=-8:0.1:8;
% Y=-8:0.1:8;
% [x,y]=meshgrid(X,Y);
r=sqrt(x.^2+y.^2)+eps; 
z=sin(r)./r;
% mesh(x,y,z);