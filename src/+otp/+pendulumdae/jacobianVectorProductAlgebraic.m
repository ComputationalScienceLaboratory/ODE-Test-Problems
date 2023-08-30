function dvp = jacobianVectorProductAlgebraic(~, state, vec, g, m, ~, ~)

x = state(1, :);
y = state(2, :);
u = state(3, :);
v = state(4, :);

vec1 = vec(1, :);
vec2 = vec(2, :);
vec3 = vec(3, :);
vec4 = vec(4, :);


dvp1 = 2*(x.*vec1 + y.*vec2);
dvp2 = 2*(u.*vec1 + v.*vec2 + x.*vec3 + y.*vec4);
dvp3 = m*(g*vec2 + u.*vec3 + v.*vec4);

dvp = [dvp1; dvp2; dvp3];

end
