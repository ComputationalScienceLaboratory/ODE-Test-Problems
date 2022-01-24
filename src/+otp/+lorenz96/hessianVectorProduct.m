function Hvp= hessianVectorProduct(~, y, u, v)

n = size(y, 1);

is = 1:n;

im2s = mod(is - 2 - 1, n) + 1;
im1s = mod(is - 1 - 1, n) + 1;
ip1s = mod(is + 1 - 1, n) + 1;

Hvp = -u(im1s, :).*v(im2s, :) + (u(ip1s, :) - u(im2s, :)).*v(im1s, :) + u(im1s, :).*v(ip1s, :);

end
