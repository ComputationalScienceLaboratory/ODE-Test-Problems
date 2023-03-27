function [W, dWdx, dWdy, dWdz, d2Wdx2, d2Wdy2, d2Wdz2] = rbfinterp(x1, y1, z1, x2, y2, z2, r, rbf)

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

[Wv, dWdkv, d2Wdk2v] = rbf(k);
Wv(isnan(Wv)) = 0;
dWdkv(isnan(dWdkv)) = 0;
d2Wdk2v(isnan(d2Wdk2v)) = 0;
d2Wdk2v(isinf(d2Wdk2v)) = 0;

dkdx = dx./(r*d);
dkdy = dy./(r*d);
dkdz = dz./(r*d);
dkdx(isnan(dkdx)) = 0;
dkdy(isnan(dkdy)) = 0;
dkdz(isnan(dkdz)) = 0;

d2kdx2 = (dy.^2 + dz.^2)./(r*(d.^3));
d2kdy2 = (dx.^2 + dz.^2)./(r*(d.^3));
d2kdz2 = (dx.^2 + dy.^2)./(r*(d.^3));
d2kdx2(isnan(d2kdx2)) = 0;
d2kdy2(isnan(d2kdy2)) = 0;
d2kdz2(isnan(d2kdz2)) = 0;


W = sparse(Is, Js, Wv, n, m);
dWdx = sparse(Is, Js, dWdkv.*dkdx, n, m);
dWdy = sparse(Is, Js, dWdkv.*dkdy, n, m);
dWdz = sparse(Is, Js, dWdkv.*dkdz, n, m);

d2Wdx2 = sparse(Is, Js, d2Wdk2v.*(dkdx.^2) + dWdkv.*d2kdx2, n, m);
d2Wdy2 = sparse(Is, Js, d2Wdk2v.*(dkdy.^2) + dWdkv.*d2kdy2, n, m);
d2Wdz2 = sparse(Is, Js, d2Wdk2v.*(dkdz.^2) + dWdkv.*d2kdz2, n, m);

end
