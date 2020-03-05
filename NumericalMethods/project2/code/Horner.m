function y = Horner(a,x)
    n = max(size(a));
    m = max(size(x));
    x=x(:); a=a(:);
    y = zeros(m,1);
    for k = 1 : n
            y = a(k) + x .* y;
    end
    
end
