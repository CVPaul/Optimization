% create on 2016-01-18, optimal on the straw hat function 
function dz=dfx(x,y)
% X=-8:0.5:8;
% Y=-8:0.5:8;
% [x,y]=meshgrid(X,Y);
r2=x.^2+y.^2;
r=sqrt(r2)+eps; 
cos_r=cos(r);
sin_r=sin(r);
dz=[cos_r.*x-sin_r.*x/r;cos_r.*y-sin_r.*y/r]/r2;
% mesh(x,y,z);