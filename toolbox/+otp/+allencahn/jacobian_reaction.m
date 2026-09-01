function j = jacobian_reaction(~, u, L, ~, beta, ~)

j = spdiags(beta * (1 - 3*u.^2), 0, size(L, 1), size(L, 2));

end
