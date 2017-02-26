% create on 2016-01-17: find the root of polynomial with different method
% draw a map for the
% input: problem- problem description struct
%           problem.fx- the array that represent a polynomial
%           problem.dfx- fx's gradient function
%           problem.method- appoint the optimization method to use
%                   -grad- gradient descend method
%                   -newton- Newton Method
%                   -levmar- Levenberg¨CMarquardt method
%           problem.maxiter- the maxiter the allowed to execute,default
%           value is set as 255
%        axis_array- appoint a range to search the roots of fx, the default
%        range is [-10,10,-10,10]
%        interv- appoint the interv in the range
% output: im- the optimal map of the me
function [im]=Solve_and_Show(problem,interv,axis_array)
    if nargin<3
        axis_array=[-10,10,-10,10];
    end
    if nargin<2
        interv=(axis_array(2)-axis_array(1))/500;
    end
    if ~isfield(problem,'maxiter')||problem.maxiter<255
        problem.maxiter=255;
    end
    if ~isfield(problem,'tol')||problem.maxiter<255
        problem.tol=1e-6;
    end
    x=axis_array(1):interv:axis_array(2);
    y=axis_array(3):interv:axis_array(4);
    xlen=length(x);
    ylen=length(y);
    im=zeros(xlen,ylen);
    for xi=1:xlen
        for yj=1:ylen
            iter=0;
            x0=[x(xi);y(yj)];
            switch problem.method
                case char('grad')
                    while iter<problem.maxiter
%                         cost=problem.fx(x0(1),x0(2));
%                         fprintf('iter=%d,cost=%f\n',iter,cost);
%                         pause(1);
                        grad=dfx(x0(1),x0(2));
                        xk=x0-grad;
                        iter=iter+1;
                        if norm(xk-x0)<problem.tol
                            break;
                        end
                        x0=xk;
                    end
                case char('newton')
                    while iter<problem.maxiter
%                         cost=problem.fx(x0(1),x0(2));
%                         fprintf('iter=%d,cost=%f\n',iter,cost);
%                         pause(1);
                        if ~isfield(problem,'get_H')
                            warning('Newton method reqire problem.get_H() to compute the Hessian Matrix!');
                            return;
                        end
                        grad=dfx(x0(1),x0(2));
                        H=problem.get_H(x0(1),x0(2));
                        xk=x0-H\grad;
                        iter=iter+1;
                        if norm(xk-x0)<problem.tol
                            break;
                        end
                        x0=xk;
                    end
                case char('bfgs')
                    m=size(x0,2);
                    B0=eye(m);I=eye(m);
                    g=dfx(x0(1),x0(2));
                    while iter<problem.maxiter
%                         cost=problem.fx(x0(1),x0(2));
%                         fprintf('iter=%d,cost=%f\n',iter,cost);
%                         pause(0.1);
                        % computation
                        sk=-B0*g;
                        xk=x0+sk;
                        gk=dfx(xk(1),xk(2));
                        yk=gk-g;
                        % update
                        iter=iter+1;
                        if norm(yk)<problem.tol
                            break;
                        end
                        x0=xk;
                        const=yk'*sk;
                        Bk=(I-sk*yk'/const)*B0*(I-yk*sk'/const)+sk*sk'/const;
                        g=gk;
                        B0=Bk;
                    end
                otherwise
                    warning('Error! this method: %s is not implemented!\n',problem.method);
                    return;
            end
            im(xi,yj)=iter;
%             fprintf('x=%d,y=%d\n',xi,yj);
        end
    end
end