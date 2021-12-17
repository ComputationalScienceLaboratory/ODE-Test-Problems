function [W, dWdx, dWdy, dWdz] = rbfinterp(x1, y1, z1, x2, y2, z2, r, rbf)

dx = x2 - x1.';
dy = y2 - y1.';
dz = z2 - z1.';

d = sqrt(dx.^2 + dy.^2 + dz.^2);

n = size(d, 1);
m = size(d, 2);

k = d/r;

% we only support compactly supported RBFs
I = find(k <= 1);

[Is, Js] = ind2sub(size(k), I);

k = k(I);
d = d(I);
dx = dx(I);
dy = dy(I);
dz = dz(I);

[Wv, dWdkv] = rbf(k);
Wv(isnan(Wv)) = 0;
dWdkv(isnan(dWdkv)) = 0;

dkdx = dx./(r*d);
dkdy = dy./(r*d);
dkdz = dz./(r*d);
dkdx(isnan(dkdx)) = 0;
dkdy(isnan(dkdy)) = 0;
dkdz(isnan(dkdz)) = 0;


W = sparse(Is, Js, Wv, n, m);
dWdx = sparse(Is, Js, dWdkv.*dkdx, n, m);
dWdy = sparse(Is, Js, dWdkv.*dkdy, n, m);
dWdz = sparse(Is, Js, dWdkv.*dkdz, n, m);

end
