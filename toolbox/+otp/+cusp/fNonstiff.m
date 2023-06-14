function du = fNonstiff(~, u, ~, ~)

n = size(u, 1)/3;

y = u(1:n, :);
a = u((n + 1):(2*n), :);
b = u((2*n + 1):end, :);

uu = (y - 0.7).*(y - 1.3);

v = uu./(uu + 0.1);

dy = zeros(n, 1);
da = b + 0.07*v;
db = (1 - a.^2).*b - a - 0.4*y + 0.035 * v;

du = [dy; da; db];

end
