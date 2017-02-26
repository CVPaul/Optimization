% compute the Hessian matrix for loss function
function H=get_H(x,y)
r2=x.^2+y.^2;
r=sqrt(r2)+eps; 
cos_r=cos(r);
sin_r=sin(r);

a11=-sin_r*(x.^2*r2+y.^2-2*x.^2)/(r^5)...
    +cos_r*(y.^2-2*x.^2)/(r2*r2);
a12=-sin_r*(x.*y*r2-3*x*y)/(r^5)...
    -cos_r*3*x*y/(r2*r2);
a21=a12;
a22=-sin_r*(y.^2*r2+x.^2-2*y.^2)/(r^5)...
    +cos_r*(x.^2-2*y.^2)/(r2*r2);

H=[a11,a12;a21,a22];