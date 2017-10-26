function [res xdim ydim] = HalfNumericIntegration(func,xmin,xmax,ymin,ymax,stepsize)
%  Calculate result for a function in a 2d spaces (probably a floor or
%  wall) with some step size. Returns a matrix with each point calculated
    
    x = xmin:stepsize:xmax;
    y = ymin:stepsize:ymax;
    [dontcare xdim] = size(x);
    [dontcare ydim] = size(y);

    res = zeros(ydim,xdim);
    
    parfor i = 1:xdim
       for j = 1:ydim
           res(j,i) = func(x(i),y(j));
       end
    end   
end

