function j = jac(~, u, L, alpha)

j = alpha*L + spdiags(1 - 3*u.^2, 0, size(L, 1), size(L, 2));

end
