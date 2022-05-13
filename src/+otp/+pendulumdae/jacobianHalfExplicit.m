function gyfz = jacobianHalfExplicit(~, state, g, m, ~, ~)

x = state(1);
y = state(2);
u = state(3);
v = state(4);

gyfz11 = -4*(x^2 + y^2);
gyfz12 = -4*(u*x + v*y);
gyfz13 = -2*g*m*y;
gyfz22 = -4*(x^2 + y^2 + u^2 + v^2);
gyfz23 = -2*m*(u*x + v*(g + y));
gyfz33 = -(m^2)*(g^2 + u^2 + v^2);

gyfz = [gyfz11, gyfz12, gyfz13; ...
    gyfz12, gyfz22, gyfz23; ...
    gyfz13, gyfz23, gyfz33];

end
