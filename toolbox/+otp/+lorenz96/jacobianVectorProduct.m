function Jvp = jacobianVectorProduct(~, y, u)

n = size(y, 1);

is = 1:n;

im2 = mod(is - 2 - 1, n) + 1;
im1 = mod(is - 1 - 1, n) + 1;
ip1 = mod(is + 1 - 1, n) + 1;

m = size(u, 2);
yf = repmat(y, m);

Jvp = (u(ip1, :) - u(im2, :)).*yf(im1, :) + (yf(ip1, :) - yf(im2, :)).*u(im1, :) - u(is, :);

end
