function dstatevp = jacobianVectorProductDifferential(~, state, g, m, ~, ~, vec)

x = state(1, :);
y = state(2, :);
u = state(3, :);
v = state(4, :);

vec1 = vec(1, :);
vec2 = vec(2, :);
vec3 = vec(3, :);
vec4 = vec(4, :);

lxy2 = x.^2 + y.^2;

lambda = (m./lxy2).*(u.^2 + v.^2) - (g./lxy2).*y;

dlambdadx = (-2*m*(u.^2 + v.^2).*x + 2*g*x.*y)./(lxy2.^2);
dlambdady = (-2*m*(u.^2 + v.^2).*y + g*(y.^2 - x.^2))./(lxy2.^2);
dlambdadu = (2*m./lxy2).*u;
dlambdadv = (2*m./lxy2).*v;

inner = (vec1.*dlambdadx + vec2.*dlambdady + vec3.*dlambdadu + vec4.*dlambdadv);

dxvp = vec3;
dyvp = vec4;
duvp = -(1/m)*(vec1.*lambda + x.*inner);
dvvp = -(1/m)*(vec2.*lambda + y.*inner);

dstatevp = [dxvp; dyvp; duvp; dvvp];

end
