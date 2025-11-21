function j = jacobianDifferential(~, state, g, m, ~, ~)

x = state(1);
y = state(2);
u = state(3);
v = state(4);

lxy2 = x.^2 + y.^2;

lambda = (m./lxy2).*(u.^2 + v.^2) - (g./lxy2).*y;

dlambdadx = (-2*m*(u.^2 + v.^2).*x + 2*g*x.*y)./(lxy2.^2);
dlambdady = (-2*m*(u.^2 + v.^2).*y + g*(y.^2 - x.^2))./(lxy2.^2);
dlambdadu = (2*m./lxy2).*u;
dlambdadv = (2*m./lxy2).*v;

dx = [0, 0, 1, 0];
dy = [0, 0, 0, 1];
du = -(1/m)*[lambda + x.*dlambdadx, x.*dlambdady, x.*dlambdadu, x.*dlambdadv];
dv = -(1/m)*[y.*dlambdadx, lambda + y.*dlambdady, y.*dlambdadu, y.*dlambdadv];

j = [dx; dy; du; dv];

end
