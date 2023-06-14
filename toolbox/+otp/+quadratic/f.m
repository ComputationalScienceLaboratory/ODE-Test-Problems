function dat = f(~, x, a, B, C)

r = length(a);

Cmat = reshape(C, r, []);
Cx = reshape(x.' * Cmat, r, r);
Cxx = x.' * Cx;

dat = Cxx(:) + B*x + a;

end
