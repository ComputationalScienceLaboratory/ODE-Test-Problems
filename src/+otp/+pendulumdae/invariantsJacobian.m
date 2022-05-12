function dc = invariantsJacobian(~, state, g, m, ~, ~)

x = state(1);
y = state(2);
u = state(3);
v = state(4);

dc1dx = 2*x;
dc1dy = 2*y;
dc1du = 0;
dc1dv = 0;

dc2dx = 2*u;
dc2dy = 2*v;
dc2du = 2*x;
dc2dv = 2*y;

dc3dx = 0;
dc3dy = m*g;
dc3du = m*u;
dc3dv = m*v;

dc = [dc1dx, dc1dy, dc1du, dc1dv; ...
   dc2dx, dc2dy, dc2du, dc2dv; ...
   dc3dx, dc3dy, dc3du, dc3dv];

end
