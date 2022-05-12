function dvp = jacobianAdjointVectorProductAlgebraic(~, state, g, m, ~, ~, control)

x = state(1, :);
y = state(2, :);
u = state(3, :);
v = state(4, :);

z1 = control(1, :);
z2 = control(2, :);
z3 = control(3, :);

dvp1 = 2*(x.*z1 + u.*z2);
dvp2 = 2*(y.*z1 + v.*z2) + g*m*z3;
dvp3 = 2*x.*z2 + m*u.*z3;
dvp4 = 2*y.*z2 + m*v.*z3;

dvp = [dvp1; dvp2; dvp3; dvp4];

end
