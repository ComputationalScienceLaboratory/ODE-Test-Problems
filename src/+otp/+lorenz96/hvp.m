function Hvp= hvp(~, y, u, v)

N = numel(y);

is = 1:N;

im2s = mod(is - 2 - 1, N) + 1;
im1s = mod(is - 1 - 1, N) + 1;
ip1s = mod(is + 1 - 1, N) + 1;

Hvp = -u(im1s).*v(im2s) + (u(ip1s) - u(im2s)).*v(im1s) + u(im1s).*v(ip1s);

end
