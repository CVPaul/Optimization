% compute the gradient function for fx
% input: fx- the array that represent a polynomial
% output:dfx- fx's gradient function
function dfx=get_dfx(fx)
    len=length(fx)-1;
    dfx=zeros(1,len);
    for i =1:len
        dfx(i)=(len-i+1)*fx(i);
    end
end