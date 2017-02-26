% create on 2015-01-17: show polynomial on the on canva
% input: method- indicate witch method to use,default is newton method
%                   -bfgs- the bfgs algorithm
%                   -newton- Newton Method
%                   -levmar- Levenberg¨CMarquardt method
function show_poly(ofx,odfx,method)
%     close all;
    if nargin <2
        ofx=@fx;
        odfx=@dfx;
    end
    
    if nargin<3
        method='grad';
    end
    if strcmp(method,'newton')
        problem.get_H=@get_H;
    end
    
    problem.fx=ofx;
    problem.dfx=odfx;
    problem.mu=1.0;
    problem.maxiter=500;
    problem.tol=1e-6;
    problem.method=method;
    
    axis_array=[-10,10,-10,10];
    interv=0.2;
    tic
    im=Solve_and_Show(problem,interv,axis_array);
    toc
    filename=['Mixical_hat_',problem.method,'.jpg'];
    imwrite(im,filename);
    % figure1==============================================================
    figure;
    axis(axis_array);
    imp=im;
    scale=problem.maxiter;
%     scale=20;
%     if strcmp(problem.method,'newton')
%         scale=20;
%     end
    max_=max(max(im));
    mean_=mean(mean(im));
    fprintf('max iter is:%d,mean iter=%d\n',max_,mean_);
    imshow(imp/scale);
    axis off;
%     % figure2============================================================
%     figure;
%     axis(axis_array);
%     imp=uint8(im);
%     image(imp);
%     axis off;
end