function dfdy = jac(t, y, alpha, D1x, k, s ,bfun, boundaryVec)

u = y(1:numel(y)/2);
v = y(numel(y)/2+1:end);
df1du = -alpha(1)*D1x - k(1)*speye(numel(u));
df1dv = k(2)*speye(numel(v));
df2du = + k(1)*speye(numel(u));
df2dv = - k(2)*speye(numel(v));
dfdy = [df1du,df1dv;df2du,df2dv];
end