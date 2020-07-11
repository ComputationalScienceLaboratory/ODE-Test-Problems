function dat = fclosureB(~, x, a, B, C, Btilde)

r = length(a);

Cmat = reshape(C, r, []);
Cx = reshape(x.' * Cmat, r, r);
Cxx = x.' * Cx;

dat = Cxx(:) + B*x + Btilde*x + a;

end
