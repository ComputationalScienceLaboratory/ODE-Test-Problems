function J = jacobian(~, uv, L, Dx, Dy, x, y, ~, ~, ~, ~)

usmall = uv(1:(end/2));
vsmall = uv((end/2 + 1):end);

n = sqrt(numel(usmall));

ddudu = L ...
    - spdiags(reshape(x, [], 1), 0, n^2, n^2)*Dx ...
    - spdiags(reshape(y, [], 1), 0, n^2, n^2)*Dy ...
    + speye(n^2, n^2);
ddudv = L - speye(n^2, n^2);
ddvdu = L - spdiags(reshape(2*usmall, [], 1), 0, n^2, n^2);
ddvdv = L - spdiags(reshape(2*vsmall, [], 1), 0, n^2, n^2);


J = [ddudu, ddudv; ddvdu, ddvdv];

end
