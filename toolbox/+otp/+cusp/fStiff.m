function du = fStiff(~, u, epsilon, L)

n = size(u, 1)/3;

y = u(1:n, :);
a = u((n + 1):(2*n), :);
b = u((2*n + 1):end, :);

dy = -(1/epsilon)*(y.^3 + a.*y + b) + L*y;
da = L*a;
db = L*b;

du = [dy; da; db];

end
