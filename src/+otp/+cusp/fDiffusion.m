function du = fDiffusion(~, u, ~, L)

n = size(u, 1)/3;

y = u(1:n, :);
a = u((n + 1):(2*n), :);
b = u((2*n + 1):end, :);

dy = L*y;
da = L*a;
db = L*b;

du = [dy; da; db];

end
