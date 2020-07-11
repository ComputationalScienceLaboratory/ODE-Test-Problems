function J = jac(t, ~, beta)

J = [-1, 1 + t; beta, -1 - beta * t];

end
