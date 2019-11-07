function j = jacnonlinear(~, u, epsilon, ~)

n = size(u, 1)/3;

y = u(1:n);
a = u((n + 1):(2*n));
b = u((2*n + 1):(3*n));

j = [spdiags(-(1/epsilon)*(3*y.^2 + a), 0, n, n), ...
    spdiags(-(1/epsilon)*y, 0, n, n), ...
    spdiags(-(1/epsilon)*ones(n, 1), 0, n, n); ...
    spdiags(0.014*(y - 1)./((y.^2 - 2*y + 1.01).^2), 0, n, n), ...
    sparse(n, n), ...
    speye(n); ...
    spdiags(-0.4 + 0.007*(y - 1)./((y.^2 - 2*y + 1.01).^2), 0, n, n), ...
    spdiags(-1 - 2*b.*a, 0, n, n), ...
    spdiags(1 - a.^2, 0, n, n)];
    
end
