function j = jac(~, u, L, alpha)

j = alpha*L + speye(size(L)) - 3*spdiags(u.^2, 0, size(L, 1), size(L, 2));

end
