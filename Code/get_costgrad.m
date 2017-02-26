% compute the cost and gradient for lost function
function [cost,grad]=get_costgrad(z)
x=z(1);y=z(2);
cost_tol=dfx(x,y);
cost=cost_tol(2);
grad_tol=get_H(x,y);
grad=grad_tol(:,2);