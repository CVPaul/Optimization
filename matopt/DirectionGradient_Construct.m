% created on 2016-04-20, in order to computing the direction gradient of 
% f(A) and speed up the computing process.
% note: the function only designed for real diagonalizable matrix input
function DG_Struct=DirectionGradient_Construct(fun,dfun,Mats,option) %#ok<INUSD>
% input: fun- the mapping:R -> R, which will operate on matrix A later
%        dfun- the gradient of fun(x),dfun: R -> R
%        Mats- a 3d tensor, each matrix in the tensor will be treat as A in
%           f(A)
%        option-[conserve] this field will keep some parameter for the algorithm
    [m,n,count]=size(Mats);
    if(m~=n)
        error('function only take squear matrix as input');
    end
    DG_Struct.fMats=zeros(m,m,count);
    DG_Struct.U=zeros(m,m,count);
    DG_Struct.invU=zeros(m,m,count);
    DG_Struct.F=zeros(m,m,count);
    DG_Struct.s=zeros(m,count);
    symm_flag=false;
    for k=1:count
        A=Mats(:,:,k);
        if issymmetric(A)
            [U,S]=eig(A);
            symm_flag=true;
        else
            [U,S]=eig(A);
            warning('matrix are not symmetric matrix');
            if ~real(U)||~real(S)||~isdiag(S)
                error('matrix Mats(:,:,%d) can not be diagonalized in real field',k);
            end
        end
        s=diag(S);        fs=fun(s);        ds=dfun(s);
        DG_Struct.s(:,k)=s;
        DG_Struct.fMats(:,:,k)=U*diag(fs)*U';
        DG_Struct.U(:,:,k)=U;
        if symm_flag
            DG_Struct.invU(:,:,k)=U';
        else
            DG_Struct.invU(:,:,k)=eye(m)/U;
        end
        F=diag(ds);        f0=fun(0);
        for i=1:m
            for j=1:m
                if abs(s(i))<eps &&abs(s(j))>eps
                    F(i,j)=(fs(j)-f0)/s(j);
                elseif abs(s(i))>eps &&abs(s(j))<eps
                    F(i,j)=(fs(i)-f0)/s(i);
                elseif abs(s(i))<eps && abs(s(j))<eps
                    F(i,j)=ds(i);
                else
                    if abs(s(i)-s(j))<eps
                        F(i,j)=ds(i);
                    else
                        F(i,j)=(fs(i)-fs(j))/(s(i)-s(j));
                    end
                end
            end
        end
        DG_Struct.F(:,:,k)=F;
    end
end
function re=isdiag(X)
    D=diag(diag(X));
    re=(norm(X-D)==0);
end