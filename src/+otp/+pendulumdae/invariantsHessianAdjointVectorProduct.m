function dvp = invariantsHessianAdjointVectorProduct(~, ~, g, m, ~, ~, control, vec)

z1 = control(1, :);
z2 = control(2, :);
z3 = control(3, :);

vec1 = vec(1, :);
vec2 = vec(2, :);
vec3 = vec(3, :);
vec4 = vec(4, :);

dvp1 = 2*(vec1.*z1 + vec3.*z2);
dvp2 = 2*(vec2.*z1 + vec4.*z2);
dvp3 = 2*vec1.*z2 + m*vec3.*z3;
dvp4 = 2*vec2.*z2 + m*vec4.*z3;

dvp = [dvp1; dvp2; dvp3; dvp4];

end
