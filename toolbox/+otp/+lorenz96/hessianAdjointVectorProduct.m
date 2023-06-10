function Havp = hessianAdjointVectorProduct(~, y, u, v)

n = numel(y);

is = 1:n;

im2s = mod(is - 2 - 1, n) + 1;
im1s = mod(is - 1 - 1, n) + 1;
ip1s = mod(is + 1 - 1, n) + 1;
ip2s = mod(is + 2 - 1, n) + 1;

Havp = u(im1s, :).*v(im2s, :) - u(ip1s, :).*v(im1s, :) - u(ip2s, :).*v(ip1s, :) + u(ip1s, :).*v(ip2s, :);

end
