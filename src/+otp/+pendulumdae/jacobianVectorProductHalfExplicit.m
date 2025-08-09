function gyfzvp = jacobianVectorProductHalfExplicit(~, state, vec, g, m, ~, ~)

x = state(1, :);
y = state(2, :);
u = state(3, :);
v = state(4, :);

vec1 = vec(1, :);
vec2 = vec(2, :);
vec3 = vec(3, :);

gyfz1 = -2*(2*u.*vec2.*x + (2*v.*vec2 + g*m*vec3).*y + 2*vec1.*(x.^2 + y.^2));
gyfz2 = -2*(2*(u.^2).*vec2 + 2.*(v.^2).*vec2 + u.*(2*vec1 + m*vec3).*x + 2.*v.*vec1.*y ...
    + m.*v.*vec3.*(g + y) + 2*vec2.*(x.^2 + y.^2));
gyfz3 = -m*((g^2)*m*vec3 + m*(u.^2 + v.^2).*vec3 + 2*vec2.*(u.*x + v.*y) + 2*g*(v.*vec2 + vec1.*y));

gyfzvp = [gyfz1; gyfz2; gyfz3];

end
