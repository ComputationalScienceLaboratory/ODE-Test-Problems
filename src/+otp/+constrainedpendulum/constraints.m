function c = constraints(~, state, g, m, l, E0)

x = state(1, :);
y = state(2, :);
u = state(3, :);
v = state(4, :);

c1 = x.^2 + y.^2 - l^2;
c2 = 2*(x.*u + y.*v);
c3 = m*(g*(y + l) + 0.5*(u.^2 + v.^2)) - E0;

c = [c1; c2; c3];

end