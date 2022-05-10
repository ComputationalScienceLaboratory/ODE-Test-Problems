function dstate = f(~, state, g, m, l, ~)

x = state(1, :);
y = state(2, :);
u = state(3, :);
v = state(4, :);

lambda =  (m/(l^2))*(u.^2 + v.^2) - (g/(l^2))*y;

dx = u;
dy = v;
du = -(lambda/m).*x;
dv = -(lambda/m)*y - g/m;

dstate = [dx; dy; du; dv];

end
