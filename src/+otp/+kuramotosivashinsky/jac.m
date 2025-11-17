function j = jac(~, u, ik, k24)

circulantU = toeplitz(u, [u(1); flipud(u(2:end))]);
j = diag(k24) - ik / length(u) .* circulantU;

end
