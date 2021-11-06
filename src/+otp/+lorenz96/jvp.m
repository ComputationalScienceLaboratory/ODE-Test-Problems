function Jvp = jvp(~, y, u)

N = numel(y);

is = 1:N;

im2 = mod(is - 2 - 1, N) + 1;
im1 = mod(is - 1 - 1, N) + 1;
ip1 = mod(is + 1 - 1, N) + 1;

m = size(u, 2);
yf = repmat(y, m);

Jvp = (u(ip1, :) - u(im2, :)).*yf(im1, :) + (yf(ip1, :) - yf(im2, :)).*u(im1, :) - u(is, :);

end
