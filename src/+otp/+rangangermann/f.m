function duvdt = f(t, uv, L, Dx, Dy, x, y, forcingu, forcingv, FBCu, FBCv)

usmall = uv(1:(end/2));
vsmall = uv((end/2 + 1):end);

n = sqrt(numel(usmall));

u = FBCu(t, x, y);
v = FBCv(t, x, y);

u(2:(end - 1), 2:(end - 1)) = reshape(usmall, n, n);
v(2:(end - 1), 2:(end - 1)) = reshape(vsmall, n, n);

u = reshape(u, [], 1);
v = reshape(v, [], 1);

Lu = L*u;
Lv = L*v;
Dxu = Dx*u;
Dyu = Dy*u;


f1 = reshape(forcingu(t, x, y), [], 1);
f2 = reshape(forcingv(t, x, y), [], 1);

dudt = f1 + Lu + Lv - reshape(x, [], 1).*Dxu - reshape(y, [], 1).*Dyu + u - v;
valg = f2 + Lu + Lv - u.^2 - v.^2;

dudt = reshape(dudt, n + 2, n + 2);
dudt = reshape(dudt(2:(end - 1), 2:(end - 1)), [], 1);

valg = reshape(valg, n + 2, n + 2);
valg = reshape(valg(2:(end - 1), 2:(end - 1)), [], 1);

duvdt = [dudt; valg];

end
