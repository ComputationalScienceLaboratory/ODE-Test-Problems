function Javp = javp(~, y, u)

N = numel(y);

is = 1:N;

im2 = mod(is - 2 - 1, N) + 1;
im1 = mod(is - 1 - 1, N) + 1;
ip1 = mod(is + 1 - 1, N) + 1;
ip2 = mod(is + 2 - 1, N) + 1;

m = size(u, 2);
yf = repmat(y, m);

Javp = -conj(yf(ip1, :)).*u(ip2, :) + conj((yf(ip2, :) - yf(im1, :))).*u(ip1, :) - u(is, :) + conj(yf(im2, :)).*u(im1, :);

end
