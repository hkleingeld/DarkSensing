function [result] = NumericIntegration_(func,xmin,xmax,ymin,ymax,stepsize)
%  Calculate riemannsom (trapezium method) of 2d function from xmin to xmax
%  and ymin to ymax with set stepsize.
    result = 0;
    

    
    x = xmin:stepsize:xmax;
    y = ymin:stepsize:ymax;
    [dontcare xdim] = size(x);
    [dontcare ydim] = size(y);
    
    xdim = xdim-1;
    ydim = ydim-1;
    res = zeros(ydim,xdim);
    
    parfor i = 1:xdim
       for j = 1:ydim
           res(j,i) = (func(x(i),y(j))+func(x(i+1),y(j+1)))/2 * stepsize^2;
       end
    end
    
    if (xmin == -7.5) && (xmax == 7.5) && (ymin == -6)
        %mesh(res)
        %result = 1;
    end
%    ma = max(max(res));
%    mi = min(min(res));
    result = sum(sum(res));
%    average = result / (ydim*xdim);
%    ratio = mi/ma;
end

